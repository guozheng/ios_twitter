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
#import "TwitterClient.h"
#import "TwitterDateUtil.h"
#import "GGZTweetCellTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface GGZTimelineViewController ()

@property (nonatomic, strong)TwitterClient *client;

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSDictionary *retweet;

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
    self.TimelineView.rowHeight = 100;
    
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
    NSLog(@"user signing out");
    [self.client removeAccessToken];
    
    GGZLoginViewController *loginVC = [[GGZLoginViewController alloc] initWithNibName:@"GGZLoginViewController" bundle:nil];
    GGZAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = loginVC;
}

- (void)onNewTweet
{
    NSLog(@"create a new tweet");
}

- (void)reload
{
    NSLog(@"reload tweets");

    [self.client homeTimelineWithCount:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
        self.tweets = responseObject;
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
    
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
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
    if ([tweet[@"retweet_count"] intValue] > 0) {
        NSLog(@"getting the latest retweet for tweet id: %@", tweet[@"id"]);
        [self.client latestRetweetForId:tweet[@"id"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response: %@", responseObject);
            self.retweet = [responseObject objectAtIndex:0];
            cell.retweetBy.text = [NSString stringWithFormat:@"%@ retweeted", self.retweet[@"retweeted_status"][@"user"][@"name"]];
            cell.retweetBy.hidden = NO;
            cell.retweetByImage.hidden = NO;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"response error: %@", error);
            
        }];
    }
    
    return cell;
    
}


@end
