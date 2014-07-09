//
//  GGZTimelineViewController.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/7/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "GGZTimelineViewController.h"
#import "GGZLoginViewController.h"
#import "GGZAppDelegate.h"
#import "GGZTweetCellTableViewCell.h"
#import "GGZTweetViewController.h"
#import "GGZComposeViewController.h"
#import "TwitterClient.h"
#import "TwitterDateUtil.h"
#import "UIImageView+AFNetworking.h"

@interface GGZTimelineViewController ()

@property (nonatomic, strong) TwitterClient *client;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSMutableArray *retweetUsernames;

- (void)reload;
- (void)onSignout;
- (void)onNewTweet;

@end

@implementation GGZTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Home";
        self.client = [TwitterClient instance];
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.TimelineView.delegate = self;
    self.TimelineView.dataSource = self;
    self.TimelineView.rowHeight = 95;
    
    // set background color for nav bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.46 green:0.71 blue:0.91 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // set text color for nav bar
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // sign out button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignout)];
    
    // new tweet button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewTweet)];
    
    [self.TimelineView registerNib:[UINib nibWithNibName:@"GGZTweetCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"GGZTweetCellTableViewCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self reload];
}

- (void)onSignout
{
    NSLog(@"user logging out");
    [self.client logout];
    
    GGZLoginViewController *loginVC = [[GGZLoginViewController alloc] initWithNibName:@"GGZLoginViewController" bundle:nil];
    GGZAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = loginVC;
}

- (void)onNewTweet
{
    NSLog(@"create a new tweet");
    
    GGZComposeViewController *composeVC = [[GGZComposeViewController alloc] initWithNibName:@"GGZComposeViewController" bundle:nil];
    [self.navigationController pushViewController:composeVC animated:YES];
}

- (void)reload
{
    NSLog(@"reload tweets");

    int tweetCount = 20;
    [self.client homeTimelineWithCount:tweetCount success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"home timeline response: %@", responseObject);
        // load tweets
        self.tweets = responseObject;
        
        // load usernames for the last retweet, nil if no retweet
//        self.retweetUsernames = [[NSMutableArray alloc] initWithCapacity:tweetCount];
//        NSLog(@"######### retweetUsernames count: %i, %i", self.retweetUsernames.count, tweetCount);
//        int i = 0;
//        for (NSDictionary *tweet in responseObject) {
//            NSLog(@"getting the latest retweet for tweet id: %@, retweet_count: %@, #%i", tweet[@"id"], tweet[@"retweet_count"], i);
//            if ([tweet[@"retweet_count"] intValue] > 0) {
//                NSLog(@"===== has retweets");
//                [self.client latestRetweetForId:tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                    NSLog(@"retweet response: %@", responseObject);
//                    NSDictionary *retweet = [responseObject objectAtIndex:0];
//                    [self.retweetUsernames addObject:retweet[@"retweeted_status"][@"user"][@"name"]];
//                    NSLog(@"found retweets, the last retweet by %@", retweet[@"retweeted_status"][@"user"][@"name"]);
//                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                    NSLog(@"response error: %@", error);
//                    
//                }];
//                NSLog(@"===== retweet request done");
//            } else {
//                [self.retweetUsernames addObject:nil];
//                NSLog(@"did not find retweet");
//            }
//            i++;
//        }
//        NSLog(@"==============tweets array size: %i", self.tweets.count);
//        NSLog(@"==============retweet usernames array size: %i", self.retweetUsernames.count);
        
        [self.TimelineView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"response error: %@", error);
        
    }];
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGZTweetCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGZTweetCellTableViewCell"];
    
    if (!cell) {
        cell = [[GGZTweetCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GGZTweetCellTableViewCell"];
    }
    
    NSDictionary *tweet = self.tweets[indexPath.row];
    NSDictionary *user = tweet[@"user"];
    
    // tweet icon
    NSURL *imageURL = [NSURL URLWithString:user[@"profile_image_url"]];
    UIImage *placeholderImage = [UIImage imageNamed:@"Placeholder"];
    cell.icon.layer.cornerRadius = 10.0;
    cell.icon.layer.borderColor = [[UIColor grayColor] CGColor];
    cell.icon.layer.borderWidth = 1.0;
    cell.icon.layer.masksToBounds = YES;
    [cell.icon setImageWithURL:imageURL placeholderImage:placeholderImage];
    
    // small icons
    [cell.replyImage setImage:[UIImage imageNamed:@"Reply"]];
    [cell.retweetImage setImage:[UIImage imageNamed:@"Retweet"]];
    [cell.favImage setImage:[UIImage imageNamed:@"Fav"]];
    
    // name
    cell.name.text = user[@"name"];
    
    // screen_name
    cell.screenname.text = [NSString stringWithFormat:@"@%@", user[@"screen_name"]];
    
    // tweet text
    cell.text.text = tweet[@"text"];
    
    // tweet age
    cell.age.text = [TwitterDateUtil tweetAgeFromDateStr:tweet[@"created_at"]];
    
    // show last retweet user
//    NSLog(@"+++++++ retweet usernames: %@", self.retweetUsernames);
    if (self.retweetUsernames.count > 0) {
        NSString *retweetUsername = [self.retweetUsernames objectAtIndex:indexPath.row];
        if (retweetUsername) {
            cell.retweetBy.text = [NSString stringWithFormat:@"%@ retweeted", retweetUsername];
            cell.retweetBy.hidden = NO;
            cell.retweetByImage.hidden = NO;
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GGZTweetViewController *tweetVC = [[GGZTweetViewController alloc] init];
    tweetVC.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tweetVC animated:YES];
}

@end
