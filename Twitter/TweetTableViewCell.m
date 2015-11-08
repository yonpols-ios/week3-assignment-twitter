//
//  TweetTableViewCell.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "Utils.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

long const kActiveRetweetColor = 0x19CF86;
long const kActiveLikeColor = 0xE81C4F;
long const kNormalActionColor = 0xAAB8C2;

@interface TweetTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *authorImage;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCreatedAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedTopSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *retweetedView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedAuthorLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation TweetTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.authorImage.layer.cornerRadius = 4;
    self.authorImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)replyButtonClicked:(id)sender {
}

- (IBAction)retweetButtonClicked:(id)sender {
    if (self.tweet.retweeted) {
        [[TwitterClient sharedInstance] unRetweet:self.tweet completion:^(NSDictionary *newTweetInfo, NSError *error) {
            if (error) {
                [self updateRetweetedState:self.tweet.retweeted withCount:self.tweet.retweetCount animated:YES];
            } else {
                self.tweet.retweeted = NO;
                self.tweet.retweetCount--;
            }
        }];
        [self updateRetweetedState:NO withCount:(self.tweet.retweetCount - 1) animated:YES];
    } else {
        [[TwitterClient sharedInstance] retweet:self.tweet completion:^(NSDictionary *newTweetInfo, NSError *error) {
            if (error) {
                [self updateRetweetedState:self.tweet.retweeted withCount:self.tweet.retweetCount animated:YES];
            } else {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount++;
            }
        }];

        [self updateRetweetedState:YES withCount:(self.tweet.retweetCount + 1) animated:YES];
    }
}

- (IBAction)likeButtonClicked:(id)sender {
    BOOL newLiked = !self.tweet.liked;
    long newCount = self.tweet.likeCount;

    void (^completedRequest)(NSDictionary *newTweetInfo, NSError *error) = ^void(NSDictionary *newTweetInfo, NSError *error) {
        BOOL animated = NO;

        if (error) {
            NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
            
            NSLog(@"error: %@", errorResponse);
            animated = YES;
        } else {
            [self.tweet updateWithDictionary:newTweetInfo];
        }
        
        [self updateLikedState:self.tweet.liked withCount:self.tweet.likeCount animated:animated];
    };

    if (self.tweet.liked) {
        newCount--;
        [[TwitterClient sharedInstance] unlikeTweet:self.tweet completion:completedRequest];

    } else {
        newCount++;
        [[TwitterClient sharedInstance] likeTweet:self.tweet completion:completedRequest];
    }
    
    [self updateLikedState:newLiked withCount:newCount animated:YES];
}

- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;

    [self.authorImage setImageWithURL:tweet.author.avatarUrl];
    self.authorNameLabel.text = tweet.author.name;
    self.authorHandleLabel.text = [NSString stringWithFormat:@"@%@", tweet.author.screenName];
    self.tweetCreatedAtLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
    self.tweetLabel.text = tweet.text;

    if (tweet.retweetedFrom) {
        self.retweetedAuthorLabel.text = [NSString stringWithFormat:@"%@ Retweeted", tweet.retweetedFrom.author.name];
        self.retweetedHeightConstraint.priority = 250;
        self.retweetedTopSpaceConstraint.priority = 999;
    } else {
        self.retweetedHeightConstraint.priority = 999;
        self.retweetedTopSpaceConstraint.priority = 250;
    }
    
    [self updateRetweetedState:tweet.retweeted withCount:tweet.retweetCount animated:NO];
    [self updateLikedState:tweet.liked withCount:tweet.likeCount animated:NO];
}

- (void) updateRetweetedState:(BOOL)retweeted withCount:(long long)count animated:(BOOL)animated {
    if (retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet_active"] forState:UIControlStateNormal];
        self.retweetCountLabel.textColor = UIColorFromRGB(kActiveRetweetColor);
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet"] forState:UIControlStateNormal];
        self.retweetCountLabel.textColor = UIColorFromRGB(kNormalActionColor);
    }
    
    if (count == 0) {
        self.retweetCountLabel.text = @"";
    } else {
        self.retweetCountLabel.text = [Utils numberWithShortcut:count];
    }
}

- (void) updateLikedState:(BOOL)liked withCount:(long long)count animated:(BOOL)animated {
    if (liked) {
        [self.likeButton setImage:[UIImage imageNamed:@"like_active"] forState:UIControlStateNormal];
        self.likeCountLabel.textColor = UIColorFromRGB(kActiveLikeColor);
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        self.likeCountLabel.textColor = UIColorFromRGB(kNormalActionColor);
    }

    if (count == 0) {
        self.likeCountLabel.text = @"";
    } else {
        self.likeCountLabel.text = [Utils numberWithShortcut:count];
    }
}

@end
