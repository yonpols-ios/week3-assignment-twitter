//
//  UserSession.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/13/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "UserSession.h"
#import "HamburgerMenuViewController.h"
#import "MenuViewController.h"
#import "TimelineViewController.h"
#import "TweetDetailViewController.h"
#import "ProfileViewController.h"

@interface UserSession()<HamburgerMenuViewControllerDelegate, TweetDetailViewControllerDelegate>

@end

@implementation UserSession {
    HamburgerMenuViewController *_hvc;
    MenuViewController *_mvc;

    UINavigationController *_tlnc;
    TimelineViewController *_tlvc;
    
    ProfileViewController *_pvc;
}

#pragma mark public methods
- (instancetype) initWithUser:(User *)user {
    if (self = [super init]) {
        _user = user;
        _client = [TwitterClient sharedInstance];
    }
    
    return self;
}

- (void) presentInWindow:(UIWindow *)window {
    window.rootViewController = [self rootViewController];
    [self showTimeline];
}

- (void) showProfile {
    [self showProfile:self.user];
}

- (void) showProfile:(User *)user {
    if (_pvc == nil) {
        _pvc = [[ProfileViewController alloc] init];
    }
    
    _pvc.user = user;
    _hvc.contentViewController = _pvc;
}

- (void) showTimeline {
    if (_tlnc == nil) {
        _tlvc = [[TimelineViewController alloc] init];
        _tlvc.userSession = self;

        _tlnc = [[UINavigationController alloc] initWithRootViewController:_tlvc];
    }
    
    _hvc.contentViewController = _tlnc;
}

- (void) showMentions {
    
}

- (void) showTweet:(Tweet *)tweet {
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] initWithUser:self.user andTweet:tweet];
    vc.delegate = self;
    [_tlnc pushViewController:vc animated:YES];
}

- (Tweet *) composeTweet:(NSString *)text inReplyTo:(Tweet *)inReplyTo {
    Tweet *newTweet = [[Tweet alloc] initFromText:text author:_user inReplyTo:inReplyTo];

    [_client tweet:newTweet completion:^(NSDictionary *newTweetInfo, NSError *error) {
        //Take care of this
    }];

    return newTweet;
}


#pragma mark delegate: HamburgerMenuViewControllerDelegate
- (BOOL)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController willShowMenuWithAnimation:(BOOL)animation {
    return YES;
}

- (void)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController didShowMenuWithAnimation:(BOOL)animation {
}

- (BOOL)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController willCloseMenuWithAnimation:(BOOL)animation {
    return YES;
}

- (void)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController didCloseMenuWithAnimation:(BOOL)animation {
}

- (BOOL)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController willChangeContentWithAnimation:(BOOL)animation from:(UIViewController *)from to:(UIViewController *)to {
    return YES;
}

- (void)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController didChangeContentWithAnimation:(BOOL)animation from:(UIViewController *)from to:(UIViewController *)to {
}

#pragma mark delegate: TweetDetailViewControllerDelegate

- (void) tweetDetail:(TweetDetailViewController *)detail replyTweet:(Tweet *)tweet {
    
}

#pragma mark private methods
- (UIViewController *)rootViewController {
    if (_hvc == nil) {
        _hvc = [[HamburgerMenuViewController alloc] init];
        _hvc.delegate = self;
        
        _mvc = [[MenuViewController alloc] init];
        _mvc.userSession = self;
        _hvc.menuViewController = _mvc;
    }
    
    return _hvc;
}

@end
