//
//  GGZTweetViewController.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/7/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "GGZTweetViewController.h"
#import "GGZComposeViewController.h"
#import "TwitterClient.h"
#import "UIImageView+AFNetworking.h"

@interface GGZTweetViewController ()

- (void)reply;

@end

@implementation GGZTweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"in TweetVC viewDidLoad");
    
    // set background color for nav bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.46 green:0.71 blue:0.91 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // set text color for nav bar
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // reply button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(reply)];
    
    NSDictionary *user = self.tweet[@"user"];
    
    // tweet user icon
    NSURL *imageURL = [NSURL URLWithString:user[@"profile_image_url"]];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    self.icon.layer.cornerRadius = 10.0;
    self.icon.layer.borderColor = [[UIColor grayColor] CGColor];
    self.icon.layer.borderWidth = 1.0;
    self.icon.layer.masksToBounds = YES;
    [self.icon setImageWithURL:imageURL placeholderImage:placeholderImage];
    
    // buttons
    [self.replyButton setImage:[UIImage imageNamed:@"Reply"] forState:UIControlStateNormal];
    self.replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.replyButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    NSString *retweetImageName = ([self.tweet[@"retweeted"] boolValue]) ? @"RetweetOn" : @"Retweet";
    [self.retweetButton setImage:[UIImage imageNamed:retweetImageName] forState:UIControlStateNormal];
    self.retweetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.retweetButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    NSString *favImageName = ([self.tweet[@"favorited"] boolValue]) ? @"FavOn" : @"Fav";
    [self.favButton setImage:[UIImage imageNamed:favImageName] forState:UIControlStateNormal];
    self.favButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.favButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    // name
    self.name.text = user[@"name"];
    
    // screen_name
    self.screenname.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];
    
    // tweet text
    self.text.text = self.tweet[@"text"];

    // tweet time
    self.time.text = self.tweet[@"created_at"];

    // retweet count
    self.retweetCount.text = [NSString stringWithFormat:@"%@", self.tweet[@"retweet_count"]];

    // favorite count
    self.favoriateCount.text = [NSString stringWithFormat:@"%@", self.tweet[@"favorite_count"]];
    
    NSLog(@"done with TweetVC viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reply {
    GGZComposeViewController *replyVC = [[GGZComposeViewController alloc] init];
    replyVC.tweet = self.tweet;
    [self.navigationController pushViewController:replyVC animated:YES];
}

- (IBAction)onReply:(id)sender {
    NSLog(@"reply button pressed");
    [self reply];
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
