//
//  ProfileViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/13/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Utils.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *profileImageBorderView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *tagLineTextView;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImageBorderView.layer.cornerRadius = 4;
    self.profileImageBorderView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 4;
    self.profileImageView.layer.masksToBounds = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.topItem.title = @"";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

- (void) setUser:(User *)user {
    if ([self view]) {
        [self.headerImageView setImageWithURL:user.backgroundUrl];
        [self.profileImageView setImageWithURL:user.avatarUrl];
        self.nameLabel.text = user.name;
        self.handleLabel.text = user.screenName;
        self.tagLineTextView.text = user.tagLine;
        self.followersCountLabel.text = [Utils numberWithShortcut:user.followersCount];
        self.followingCountLabel.text = [Utils numberWithShortcut:user.friendsCount];
    }
}
@end
