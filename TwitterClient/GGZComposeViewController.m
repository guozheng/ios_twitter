//
//  GGZComposeViewController.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/8/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "GGZComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface GGZComposeViewController ()

@property (nonatomic, strong) TwitterClient *client;
@property (nonatomic, strong) NSDictionary *user;

@end

@implementation GGZComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.client = [TwitterClient instance];
        self.user = [self.client getCurrentUser];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"in ComposeVC viewDidLoad");
    
    // set background color for nav bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.46 green:0.71 blue:0.91 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // set text color for nav bar
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // tweet button
    if (self.tweet) {
        // reply to an existing tweet button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply)];
        self.text.text = [NSString stringWithFormat:@"@%@", self.tweet[@"user"][@"name"]];
        NSLog(@"the original tweet to reply: %@", self.tweet);
    } else {
        // new tweet button
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];
    }
    
    // user icon
    NSURL *imageURL = [NSURL URLWithString:self.user[@"profile_image_url"]];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    self.icon.layer.cornerRadius = 10.0;
    self.icon.layer.borderColor = [[UIColor grayColor] CGColor];
    self.icon.layer.borderWidth = 1.0;
    self.icon.layer.masksToBounds = YES;
    [self.icon setImageWithURL:imageURL placeholderImage:placeholderImage];
    
    // name
    self.name.text = self.user[@"name"];
    
    // screen name
    self.screenname.text = self.user[@"screen_name"];
    
    NSLog(@"done with ComposeVC viewDidLoad");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTweet
{
    NSLog(@"creating a new tweet...");
    [self.client updateWithStatus:self.text.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successfully created a new tweet: %@", self.text.text);
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to create a new tweet: %@", error);
    }];
}

- (void)onReply
{
    NSLog(@"replying to an existing tweet...");
    [self.client replyWithStatus:self.text.text statusId:self.tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to reply the tweet: %@", error);
    }];
}

@end
