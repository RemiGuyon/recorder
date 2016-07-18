//
//  Constants.m
//  recorder
//
//  Created by Rémi Guyon on 14/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import "Constants.h"

@implementation Constants

// Environment
#ifdef DEBUG
NSString *const HOST_KEY = @"api-dev";
#else
NSString *const HOST_KEY = @"api-prod";
#endif

// Settings
NSString *const BATCH_INTERVAL_KEY = @"batch-interval";
NSTimeInterval const BATCH_INTERVAL_DEFAULT = 10;

// User defaults
NSString *const USER_DEFAULTS_POINTS_KEY = @"points";

@end
