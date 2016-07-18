//
//  ViewController.m
//  recorder
//
//  Created by Rémi Guyon on 14/07/16.
//  Copyright © 2016 RemiGuyon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
	[super viewDidLoad];
}

#pragma mark - Touch recording

/**
 Get all touches event, only track start of events thus we do not record dragging or long press for example
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	// Get the specific point that was touched
	CGPoint point = [touch locationInView:self.view.window];
	[[RecorderManager sharedInstance] recordPoint:NSStringFromCGPoint(point)];
}

#pragma mark - Memory

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
