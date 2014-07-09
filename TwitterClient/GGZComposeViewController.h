//
//  GGZComposeViewController.h
//  TwitterClient
//
//  Created by Guozheng Ge on 7/8/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface GGZComposeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UITextField *text;

@end
