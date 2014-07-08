//
//  GGZAppDelegate.m
//  TwitterClient
//
//  Created by Guozheng Ge on 7/3/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import "GGZAppDelegate.h"
#import "GGZLoginViewController.h"
#import "GGZTimelineViewController.h"

#import "NSURL+dictionaryFromQueryString.h"
#import "TwitterClient.h"
#import "User.h"

@implementation GGZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    self.window.rootViewController = self.currentVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"cptwitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
//                [client.requestSerializer removeAccessToken];
                [client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"Successfully fetched access token: %@", accessToken.token);
                    [client.requestSerializer saveAccessToken:accessToken];
                    
                    // save access token
                    [client saveAccessToken:accessToken];
                    [self updateRootVC];
                    NSLog(@"after saving access token and update root vc");
                    
                }failure:^(NSError *error) {
                    NSLog(@"Failed to fetch access token: %@", error);
                    
                }];
            }
        }
        return YES;
    }
    return NO;
}

- (UIViewController *)currentVC {
    BDBOAuthToken *accessToken = [[TwitterClient instance] getAccessToken];
    
    if (accessToken) {
        NSLog(@"found existing access token");
        return self.timelineNVC;
    } else {
        NSLog(@"cound not find existing access token, login first");
        return self.loginVC;
    }
}

- (UINavigationController *)timelineNVC {
    if (!_timelineNVC) {
        GGZTimelineViewController *timelineVC = [[GGZTimelineViewController alloc] init];
        _timelineNVC = [[UINavigationController alloc] initWithRootViewController:timelineVC];
    }
    
    return _timelineNVC;
}

- (GGZLoginViewController *)loginVC {
    if (!_loginVC) {
        _loginVC = [[GGZLoginViewController alloc] init];
    }
    
    return _loginVC;
}

- (void)updateRootVC {
    self.window.rootViewController = self.currentVC;
}

@end
