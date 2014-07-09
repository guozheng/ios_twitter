//
//  GGZTweetViewController.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/7/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "GGZTweetViewController.h"
#import "UIImageView+AFNetworking.h"

@interface GGZTweetViewController ()

- (void)onReply;

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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply)];
    
    NSDictionary *user = self.tweet[@"user"];
    
    // tweet user icon
    NSURL *imageURL = [NSURL URLWithString:user[@"profile_image_url"]];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    self.icon.layer.cornerRadius = 10.0;
    self.icon.layer.borderColor = [[UIColor grayColor] CGColor];
    self.icon.layer.borderWidth = 1.0;
    self.icon.layer.masksToBounds = YES;
    [self.icon setImageWithURL:imageURL placeholderImage:placeholderImage];
    
    // small icons
    [self.replyImage setImage:[UIImage imageNamed:@"Reply"]];
    [self.retweetImage setImage:[UIImage imageNamed:@"Retweet"]];
    [self.favoriateImage setImage:[UIImage imageNamed:@"Fav"]];
    
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

- (void)onReply
{
    NSLog(@"Replying for the tweet: %@", self.tweet[@"id"]);
}

@end
