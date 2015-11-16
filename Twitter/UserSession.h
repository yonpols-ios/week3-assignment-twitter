//
//  UserSession.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/13/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TwitterClient.h"

@interface UserSession : NSObject

@property (strong, nonatomic, readonly) User *user;
@property (strong, nonatomic, readonly) TwitterClient *client;
@property (strong, nonatomic, readonly) UIViewController *currentController;

- (instancetype) initWithUser:(User *)user;
- (void) presentInWindow:(UIWindow *)window;
- (void) showProfile;
- (void) showTimeline;
- (void) showMentions;
- (void) showMenu;
- (void) showTweet:(Tweet *)tweet;
- (Tweet *) composeTweet:(NSString *)text inReplyTo:(Tweet *)inReplyTo;

@end
