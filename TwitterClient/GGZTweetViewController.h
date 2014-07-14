//
//  GGZTweetViewController.h
//  TwitterClient
//
//  Created by Guozheng Ge on 7/7/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGZTweetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *screenname;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriateCount;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favButton;

- (IBAction)onReply:(id)sender;
- (IBAction)onRetweet:(id)sender;
- (IBAction)onFav:(id)sender;

@property (nonatomic, strong) NSDictionary *tweet;

@end
