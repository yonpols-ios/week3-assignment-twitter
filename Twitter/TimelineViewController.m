//
//  TimelineViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetTableViewCell.h"
#import "ComposeTweetViewController.h"
#import "TweetDetailViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, TweetTableViewCellDelegate, ComposeTweetViewControllerDelegate, TweetDetailViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) UIRefreshControl *timelineRefreshControl;

@property (strong, nonatomic) NSArray *tweets;
@property (assign, nonatomic) unsigned long long minTweetId;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetWidthConstraint;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *titleImage = [UIImage imageNamed:@"twitter"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];

    UIImage *newTweetImage = [UIImage imageNamed:@"new"];
    newTweetImage = [newTweetImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *newTweet = [[UIBarButtonItem alloc]initWithImage:newTweetImage
                                                         style:UIBarButtonItemStylePlain
                                                         target:self
                                                         action:@selector(composeTweet)];
    self.navigationItem.rightBarButtonItem = newTweet;
    
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    self.timelineTableView.estimatedRowHeight = 100;
    self.timelineTableView.rowHeight = UITableViewAutomaticDimension;
    [self.timelineTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"tweetCell"];
    
    self.timelineRefreshControl = [[UIRefreshControl alloc] init];
    [self.timelineRefreshControl addTarget:self action:@selector(doTimelineRefresh) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView insertSubview:self.timelineRefreshControl atIndex:0];
    
    [self doTimelineRefresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    
    if (indexPath.row == (self.tweets.count - 1)) {
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 50)];
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        loadingView.center = tableFooterView.center;
        [tableFooterView addSubview:loadingView];
        tableView.tableFooterView = tableFooterView;
        
        [self loadTweets];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    TweetDetailViewController *vc = [[TweetDetailViewController alloc] initWithUser:[Session currentUser] andTweet:tweet];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) tweetCell:(TweetTableViewCell *)cell replyTweet:(Tweet *)tweet {
    ComposeTweetViewController *vc = [[ComposeTweetViewController alloc] initWithUser:[Session currentUser] inReplyTo:tweet];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) tweetCell:(TweetTableViewCell *)cell profileTap:(User *)user {
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = user;
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void) tweetDetail:(TweetDetailViewController *)detail replyTweet:(Tweet *)tweet {
    [self tweetCell:nil replyTweet:tweet];
}

- (void) composeTweetViewController:(ComposeTweetViewController *)viewController newTweet:(NSString *)text inReplyTo:(Tweet *)tweet {
    Tweet *newTweet = [self.userSession composeTweet:text inReplyTo:tweet];
    
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    [tweets addObject:newTweet];
    [tweets addObjectsFromArray:self.tweets];
    self.tweets = tweets;
    [self.timelineTableView reloadData];
}

- (void) loadTweets {
    NSDictionary *parameters = nil;
    
    if (self.minTweetId < ULLONG_MAX) {
        parameters = @{@"max_id": @(self.minTweetId)};
    }

    [self.userSession.client homeTimeLineWithParameters:parameters completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            if (parameters) {
                self.tweets = [self.tweets arrayByAddingObjectsFromArray:tweets];
            } else {
                [self.timelineRefreshControl endRefreshing];
                self.tweets = tweets;
            }
            
            for (Tweet *tweet in tweets) {
                unsigned long long tid = [tweet.tweetId longLongValue];
                if (tid < self.minTweetId) {
                    self.minTweetId = tid;
                }
            }
            self.minTweetId--;
            
            [self.timelineTableView reloadData];
        }
    }];
}

- (void) composeTweet {
    ComposeTweetViewController *vc = [[ComposeTweetViewController alloc] initWithUser:[Session currentUser]];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) doTimelineRefresh {
    self.minTweetId = ULLONG_MAX;
    [self loadTweets];
}


@end
