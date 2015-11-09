//
//  TweetTableViewCell.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "Utils.h"

extern long const kActiveRetweetColor;
extern long const kActiveLikeColor;
extern long const kNormalActionColor;

@class TweetTableViewCell;

@protocol TweetTableViewCellDelegate<NSObject>

@optional

- (void) tweetCell:(TweetTableViewCell *)cell replyTweet:(Tweet *)tweet;

@end

@interface TweetTableViewCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) id<TweetTableViewCellDelegate> delegate;

@end
