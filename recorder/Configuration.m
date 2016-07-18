//
//  Configuration.m
//  recorder
//
//  Created by Rémi Guyon on 18/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import "Configuration.h"

@interface Configuration ()

@property (strong, nonatomic) NSDictionary *settings;

@end

@implementation Configuration

#pragma mark - Singleton

+ (instancetype)sharedInstance {
	static id sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

#pragma mark - Init

- (instancetype)init {
	self = [super init];
	if (self) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
		_settings = [[NSDictionary alloc] initWithContentsOfFile:path];
		
		if (_settings[HOST_KEY]) {
			_HOST = _settings[HOST_KEY];
		} else {
#warning TODO Force an error if host is not defined
		}
		
		if ([_settings[BATCH_INTERVAL_KEY] isKindOfClass:[NSNumber class]]) {
			_BATCH_INTERVAL = [_settings[BATCH_INTERVAL_KEY] integerValue];
		} else {
			_BATCH_INTERVAL = BATCH_INTERVAL_DEFAULT;
		}
		
	}
	return self;
}

@end
