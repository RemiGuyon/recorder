//
//  ApiManager.m
//  recorder
//
//  Created by Rémi Guyon on 14/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import "ApiManager.h"

@interface ApiManager ()

@end

@implementation ApiManager

#pragma mark - Singleton

+ (instancetype)sharedInstance {
	static ApiManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:[Configuration sharedInstance].HOST] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	});
	
	return sharedInstance;
}

#pragma mark - Init

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
	self = [super initWithBaseURL:url sessionConfiguration:configuration];
	if (self) {
		self.requestSerializer = [AFHTTPRequestSerializer serializer];
		self.responseSerializer = [AFHTTPResponseSerializer serializer];
	}
	return self;
}

- (void)postPoints:(NSArray *)points success:(void (^)(NSURLSessionDataTask *task))success failure:(void (^)(NSError *error))failure {
	NSDictionary *parametersDictionary = @{@"points": points};
	
	[self POST:@"points" parameters:parametersDictionary progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"Success");
		success(task);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"Error: %@", error);
		failure(error);
	}];
}

@end
