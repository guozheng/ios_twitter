//
//  GGZTweetCellTableViewCell.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/7/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "GGZTweetCellTableViewCell.h"
#import "GGZComposeViewController.h"
#import "TwitterClient.h"

@implementation GGZTweetCellTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)onReply:(id)sender {
    NSLog(@"reply button pressed");
    GGZComposeViewController *replyVC = [[GGZComposeViewController alloc] init];
    replyVC.tweet = self.tweet;
    [self.navigationController pushViewController:replyVC animated:YES];
}

- (IBAction)onRetweet:(id)sender {
    NSLog(@"retweet button pressed");
    [[TwitterClient instance] retweetWithStatusId:self.tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *retweetImageName = ([self.tweet[@"retweeted"] boolValue]) ? @"Retweet" : @"RetweetOn";
        [self.retweetButton setImage:[UIImage imageNamed:retweetImageName] forState:UIControlStateNormal];
        self.retweetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        self.retweetButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        NSLog(@"successfully retweeted");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to retweet: %@", error);
    }];
}

- (IBAction)onFav:(id)sender {
    NSLog(@"fav button pressed");
    [[TwitterClient instance] favoriteWithStatusId:self.tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // switch the image status
        NSString *favImageName = ([self.tweet[@"favorited"] boolValue]) ? @"Fav" : @"FavOn";
        [self.favButton setImage:[UIImage imageNamed:favImageName] forState:UIControlStateNormal];
        self.favButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        self.favButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        NSLog(@"successfully faved tweet");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fav tweet: %@", error);
    }];
}
@end
