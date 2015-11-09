//
//  TweetDetailViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/8/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetTableViewCell.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedViewTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *retweetedAuthorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorAvatarImage;
@property (weak, nonatomic) IBOutlet UILabel *authorUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorUserHandleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetCreatedAtLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@property (strong, nonatomic) Tweet *tweet;
@property (strong, nonatomic) User *user;

@end

@implementation TweetDetailViewController

- (instancetype) initWithUser:(User *)user andTweet:(Tweet *)tweet {
    if (self == [super initWithNibName:@"TweetDetailViewController" bundle:nil]) {
        self.user = user;
        self.tweet = tweet;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem.title = @"";
    self.navigationItem.title = @"Tweet";
    
    [self.authorAvatarImage setImageWithURL:self.tweet.author.avatarUrl];
    self.authorAvatarImage.layer.cornerRadius = 4;
    self.authorAvatarImage.layer.masksToBounds = YES;

    self.authorUserNameLabel.text = self.tweet.author.name;
    self.authorUserHandleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.author.screenName];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    self.tweetCreatedAtLabel.text = [dateFormatter stringFromDate:self.tweet.createdAt];
    self.tweetTextLabel.text = self.tweet.text;
    self.tweetTextView.text = self.tweet.text;
    
    if (self.tweet.retweetedFrom) {
        self.retweetedAuthorLabel.text = [NSString stringWithFormat:@"%@ Retweeted", self.tweet.retweetedFrom.author.name];
        self.retweetedViewHeightConstraint.priority = 250;
        self.retweetedViewTopConstraint.priority = 999;
    } else {
        self.retweetedViewHeightConstraint.priority = 999;
        self.retweetedViewTopConstraint.priority = 250;
    }
    
    [self updateRetweetedState:self.tweet.retweeted withCount:self.tweet.retweetCount animated:NO];
    [self updateLikedState:self.tweet.liked withCount:self.tweet.likeCount animated:NO];
}

- (IBAction)replyButtonClicked:(id)sender {
    if (self.delegate) {
        [self.delegate tweetDetail:self replyTweet:self.tweet];
    }
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
