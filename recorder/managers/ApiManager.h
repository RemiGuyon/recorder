//
//  ApiManager.h
//  recorder
//
//  Created by Rémi Guyon on 14/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface ApiManager : AFHTTPSessionManager

/**
 This class manages the requests to the API. It contains no business logic and has no knowledge of the app.
 */
+ (instancetype)sharedInstance;

/*!
 *  @method	postPoints:success:failure:
 *
 *  @discussion	
 *	API Doc:
 *	• POST /points/
 *	Argument “points”: An array of points, each point being the string “x,y” where x is the x coordinate of the point (int) and y is the y coordinate of the point (int)
 *	Returns: A PNG image
 *	Example of call:
 *	POST /points/ with HTTP body: “points[]=1,2&points[]=42,98&points[]=34,-2”
 *
 */
- (void)postPoints:(NSArray *)points success:(void (^)(NSURLSessionDataTask *task))success failure:(void (^)(NSError *error))failure;

@end
