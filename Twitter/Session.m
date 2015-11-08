//
//  Session.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterUserSetting = @"twitterUser";
NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@implementation Session

static User *__currentUser = nil;

+ (User *)currentUser {
    if (__currentUser == nil) {
        NSData *currentUserData = [[NSUserDefaults standardUserDefaults] objectForKey:kTwitterUserSetting];
        if (currentUserData) {
            NSDictionary *currentUser = [NSJSONSerialization JSONObjectWithData:currentUserData options:0 error:NULL];
            __currentUser = [[User alloc] initWithDictionary:currentUser];
        }
    }
    
    return __currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    if (currentUser == nil) {
        [settings setObject:nil forKey:kTwitterUserSetting];
    } else {
        NSData *currentUserData = [NSJSONSerialization dataWithJSONObject:currentUser.rawData options:0 error:NULL];
        [settings setObject:currentUserData forKey:kTwitterUserSetting];
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:currentUser];
    }
    [settings synchronize];
    
    __currentUser = currentUser;
}

+ (void) destroy {
    [Session setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}



@end
