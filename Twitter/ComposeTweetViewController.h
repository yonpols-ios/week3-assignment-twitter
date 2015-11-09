//
//  ComposeTweetViewController.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/8/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"

@class ComposeTweetViewController;

@protocol ComposeTweetViewControllerDelegate <NSObject>

- (void)composeTweetViewController:(ComposeTweetViewController *)viewController newTweetComposed:(Tweet *)tweet;

@end

@interface ComposeTweetViewController : UIViewController

- (instancetype) initWithUser:(User *)user;
- (instancetype) initWithUser:(User *)user andTweet:(Tweet *)tweet;

@property (weak, nonatomic) id<ComposeTweetViewControllerDelegate> delegate;

@end
