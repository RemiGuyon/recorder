//
//  RecorderManager.h
//  recorder
//
//  Created by Rémi Guyon on 14/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecorderManager : NSObject

/**
 This class is the single point of access of the UI to the business logic. It is a singleton that abstracts all the logic of the app. The UI only needs to communicate with this manager whose role is to dispatch the requests to the appropriate managers then process
 their responses to return a comprehensive response to the UI.
 */
+ (instancetype)sharedInstance;

/*!
 *  @method recordPoint:
 *
 *  @param pointString	Coordinates of the point to save. The coordinates are saved as a string with the format {x, y}.
 *
 *  @discussion	This method adds the coordinates (as a string) to a array of point coordinates.
 *
 */
- (void)recordPoint:(NSString *)pointString;

/*!
 *  @method sendPointBatchSuccess:success:failure
 *
 *  @discussion	This method calls the ApiManager POST /points path with an array of coordinates. If the request is successful the success block is called and the saved points are removed from the points array. If the request failed, the failure block is called and the points are kept.
 *
 */
- (void)sendPointBatchSuccess:(void (^)(void))success failure:(void (^)(void))failure;

@end
