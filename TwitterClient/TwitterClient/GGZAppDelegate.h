//
//  GGZAppDelegate.h
//  TwitterClient
//
//  Created by Guozheng Ge on 7/3/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGZLoginViewController.h"

@interface GGZAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) GGZLoginViewController *loginVC;
@property (nonatomic, strong) UINavigationController *timelineNVC;
@property (nonatomic, strong) UIViewController *currentVC;

@end
