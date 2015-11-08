//
//  Session.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface Session : NSObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;


@end
