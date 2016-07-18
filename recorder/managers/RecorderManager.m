//
//  RecorderManager.m
//  recorder
//
//  Created by Rémi Guyon on 14/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import "RecorderManager.h"

#import "ApiManager.h"

@interface RecorderManager ()

@property (strong, nonatomic) NSMutableArray *pointArray;
@property (strong, nonatomic) NSTimer *batchTimer;
@property (assign, nonatomic) UIBackgroundTaskIdentifier batchTaskIdentifier;

@end

@implementation RecorderManager

#pragma mark - Singleton

+ (instancetype)sharedInstance {
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		// Init the batch timer
		_batchTimer = [self startBatchTimer];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
		
		// We get saved points if needed
		_pointArray = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_POINTS_KEY] mutableCopy];
	}
	return self;
}

#pragma mark - Points

- (void)recordPoint:(NSString *)pointString {
	if (!self.pointArray) {
		self.pointArray = [[NSMutableArray alloc] init];
	}
	
	[self.pointArray addObject:pointString];
	NSLog(@"Point recorded: %@", pointString);
	[[NSUserDefaults standardUserDefaults] setObject:self.pointArray forKey:USER_DEFAULTS_POINTS_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sendBatch:(NSTimer *)timer {
	// We send a batch only if we have at least one point to send
	if (self.pointArray.count > 0) {
		[self sendPointBatchSuccess:nil failure:nil];
	}
}

- (void)sendPointBatchSuccess:(void (^)(void))success failure:(void (^)(void))failure {
	[[ApiManager sharedInstance] postPoints:self.pointArray success:^(NSURLSessionDataTask *task) {
		// Points were saved, we can remove them from the points array
		self.pointArray = nil;
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_POINTS_KEY];
		[[NSUserDefaults standardUserDefaults] synchronize];
		success();
	} failure:^(NSError *error) {
		// Points were not saved, we keep them for the next batch
	}];
}

#pragma mark - Notifications

- (void)applicationWillEnterForeground:(NSNotification *)notification {
	// The app is in foreground, we start the batch timer
	if (self.batchTimer) {
		[self.batchTimer invalidate];
		self.batchTimer = nil;
	}
	
	self.batchTimer = [self startBatchTimer];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
	// The app is in background:
	// - We stop the batch timer
	// - We force a batch request with a background task because the request could take some time to complete
	if (self.batchTimer) {
		[self.batchTimer invalidate];
		self.batchTimer = nil;
	}
	
	NSLog(@"Start background task");
	self.batchTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		NSLog(@"Expiration handler called");
		// The batch couldn't complete in time, we assume that the points were not saved by the server
		[[UIApplication sharedApplication] endBackgroundTask:self.batchTaskIdentifier];
		self.batchTaskIdentifier = UIBackgroundTaskInvalid;
	}];
	
	[self sendPointBatchSuccess:^{
		NSLog(@"Batch task ended with success in background");
		[[UIApplication sharedApplication] endBackgroundTask:self.batchTaskIdentifier];
		self.batchTaskIdentifier = UIBackgroundTaskInvalid;
	} failure:^{
		NSLog(@"Batch task failed in background");
		[[UIApplication sharedApplication] endBackgroundTask:self.batchTaskIdentifier];
		self.batchTaskIdentifier = UIBackgroundTaskInvalid;
	}];
}

#pragma mark - Timer

- (NSTimer *)startBatchTimer {
	return [NSTimer scheduledTimerWithTimeInterval:[Configuration sharedInstance].BATCH_INTERVAL target:self selector:@selector(sendBatch:) userInfo:nil repeats:YES];
}

#pragma mark - Memory

- (void)dealloc {
	if (self.batchTimer) {
		[self.batchTimer invalidate];
		self.batchTimer = nil;
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

@end
