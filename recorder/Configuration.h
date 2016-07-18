//
//  Configuration.h
//  recorder
//
//  Created by Rémi Guyon on 18/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

+ (instancetype)sharedInstance;

/**
 *	Interval (in seconds) between each batch of points sent to server
 */
@property (strong, nonatomic) NSString *HOST;

/**
 *	Interval (in seconds) between each batch of points sent to server
 */
@property (assign, nonatomic) float BATCH_INTERVAL;


@end
