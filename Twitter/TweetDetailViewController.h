//
//  TweetDetailViewController.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/8/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@class TweetDetailViewController;

@protocol TweetDetailViewControllerDelegate<NSObject>

@optional

- (void) tweetDetail:(TweetDetailViewController *)detail replyTweet:(Tweet *)tweet;

@end

@interface TweetDetailViewController : UIViewController

@property (strong, nonatomic) id<TweetDetailViewControllerDelegate> delegate;

- (instancetype) initWithUser:(User *)user andTweet:(Tweet *)tweet;


@end
