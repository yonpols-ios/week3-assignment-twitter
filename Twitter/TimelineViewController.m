//
//  TimelineViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "TimelineViewController.h"
#import "TweetTableViewCell.h"
#import "TwitterClient.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;
@property (strong, nonatomic) UIRefreshControl *timelineRefreshControl;

@property (strong, nonatomic) TwitterClient *client;
@property (strong, nonatomic) NSArray *tweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Twitter";

    self.client = [TwitterClient sharedInstance];
    
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    self.timelineTableView.estimatedRowHeight = 100;
    self.timelineTableView.rowHeight = UITableViewAutomaticDimension;
    [self.timelineTableView registerNib:[UINib nibWithNibName:@"TweetTableViewCell" bundle:nil] forCellReuseIdentifier:@"tweetCell"];
    
    self.timelineRefreshControl = [[UIRefreshControl alloc] init];
    [self.timelineRefreshControl addTarget:self action:@selector(doTimelineRefresh) forControlEvents:UIControlEventValueChanged];
    [self.timelineTableView insertSubview:self.timelineRefreshControl atIndex:0];
    
    [self.client homeTimeLineWithParameters:nil completion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.timelineTableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    cell.tweet = self.tweets[indexPath.row];
    
    return cell;
}

- (void) doTimelineRefresh {
    [self.client homeTimeLineWithParameters:nil completion:^(NSArray *tweets, NSError *error) {
        [self.timelineRefreshControl endRefreshing];

        if (tweets) {
            self.tweets = tweets;
            [self.timelineTableView reloadData];
        }
    }];
}


@end
