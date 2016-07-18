//
//  Constants.h
//  recorder
//
//  Created by Rémi Guyon on 14/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

// Environment
extern NSString *const HOST_KEY;

// Settings
extern NSString *const BATCH_INTERVAL_KEY;
extern NSTimeInterval const BATCH_INTERVAL_DEFAULT;

// User defaults
extern NSString *const USER_DEFAULTS_POINTS_KEY;

@end
