//
//  User.h
//  TwitterClient
//
//  Created by Guozheng Ge on 7/6/14.
//  Copyright (c) 2014 gzge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestObject.h"

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : RestObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;

@end
