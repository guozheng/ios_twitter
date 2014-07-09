//
//  TwitterClient.h
//  TwitterClient
//
//  Created by Guozheng Ge on 7/3/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void)saveAccessToken:(BDBOAuthToken *)accessToken;

- (void)removeAccessToken;

- (BDBOAuthToken *)getAccessToken;

- (void)saveUser:(NSDictionary *)currentUser;

- (void)removeUser;

- (NSDictionary *)getCurrentUser;

- (void)logout;

- (void)login;

- (AFHTTPRequestOperation *)homeTimelineWithCount:(int)count
                                          success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)latestRetweetForId:(NSString *)tweetId
                                       success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)currentUserWithSuccess:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)updateWithStatus:(NSString *)status
                                     success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)replyWithStatus:(NSString *)status
                                   statusId:(NSString *)statusId
                                    success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)retweetWithStatusId:(NSString *)statusId
                                        success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)favoriteWithStatusId:(NSString *)statusId
                                         success:(void (^) (AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^) (AFHTTPRequestOperation *operation, NSError *error))failure;

@end
