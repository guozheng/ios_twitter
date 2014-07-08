//
//  TwitterClient.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/3/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "TwitterClient.h"

#define BASE_URL [NSURL URLWithString:@"https://api.twitter.com/"]
#define CONSUMER_KEY @"Unawe1A1ohIbmBLpmvHNAu1RG"
#define CONSUMER_SECRET @"9zZ7Xk9QYPVEIYxeWamO2JUCm2tQMq22jTK7ioiFkd1nymXjJZ"

@implementation TwitterClient

static NSString * const kAccessTokenKey = @"kAccessTokenKey";

// get a singleton Twitter client
+ (TwitterClient *)instance
{
    static TwitterClient *sharedInstance = nil;
    static dispatch_once_t pred;
    
    if (sharedInstance)
    {
        return sharedInstance;
    }
    
    dispatch_once(&pred, ^{
        sharedInstance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET];
    });
    
    return sharedInstance;
}

- (void)saveAccessToken:(BDBOAuthToken *)accessToken
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:accessToken];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAccessToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAccessTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BDBOAuthToken *)getAccessToken
{
    BDBOAuthToken *accessToken = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:kAccessTokenKey];
    if (data) {
        accessToken = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return accessToken;
}

- (void)login
{
    [self fetchRequestTokenWithPath:@"oauth/request_token"
        method:@"POST"
        callbackURL:[NSURL URLWithString:@"cptwitter://oauth"]
        scope:nil
        success:^(BDBOAuthToken *requestToken){
            NSLog(@"Got the request token");
            NSString *authURL = [NSString stringWithFormat:@"%@oauth/authorize?oauth_token=%@",
                                 BASE_URL,
                                 requestToken.token];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
            NSLog(@"Opened the auth url");
            
        } failure:^(NSError *error) {
            NSLog(@"Failed to get the request token");
        }];
}

- (AFHTTPRequestOperation *)homeTimelineWithCount:(int)count
                                          success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/home_timeline.json?count=%i", count];
    return [self GET:url parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *)latestRetweetForId:(NSString *)tweetId
                                          success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"1.1/statues/retweets/%@.json?count=1", tweetId];
    return [self GET:url parameters:nil success:success failure:failure];
}
@end
