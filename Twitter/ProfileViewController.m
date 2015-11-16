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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageHeightConstraint;

@end

@implementation ProfileViewController {
    CGFloat _originalConstraint;
    CGFloat _kMinHeaderImageHeight;
    CGFloat _kMaxHeaderImageHeight;
    UIVisualEffectView *_blurEffectView;
    UINavigationBar *_navbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    UINavigationBar *navbar = self.navigationController.navigationBar;
    UIApplication* application = [UIApplication sharedApplication];
    CGFloat kStatusBarHeight = application.statusBarFrame.size.height;
    
    if (navbar == nil) {
        _navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, self.view.frame.size.width, 44)];
        navbar = _navbar;
        UIImage *menuImage = [UIImage imageNamed:@"menu"];
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:0 target:self action:@selector(menuButtonTapped:)];
        UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
        navItem.leftBarButtonItem = menuButton;
        navbar.items = @[navItem];
        [self.view addSubview:navbar];
    }
    
    [navbar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navbar.shadowImage = [UIImage new];
    navbar.translucent = YES;
    navbar.tintColor = [UIColor whiteColor];
    navbar.topItem.title = @"";

    self.profileImageBorderView.layer.cornerRadius = 4;
    self.profileImageBorderView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 4;
    self.profileImageView.layer.masksToBounds = YES;
    
    self.headerImageView.clipsToBounds = YES;
    
    CGFloat kNavBarHeight =  navbar.frame.size.height;
    
    _kMinHeaderImageHeight = kStatusBarHeight + kNavBarHeight + 25;
    _kMaxHeaderImageHeight = self.headerImageHeightConstraint.constant * 4.5;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.userSession.currentController setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)onViewPanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        sender.cancelsTouchesInView = NO;
        _originalConstraint = self.headerImageHeightConstraint.constant;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.view];
        CGPoint velocity = [sender velocityInView:self.view];
        CGFloat newConstant = _originalConstraint + translation.y;
        
        if (newConstant >= _kMinHeaderImageHeight && newConstant <= _kMaxHeaderImageHeight) {
            self.headerImageHeightConstraint.constant = newConstant;
        }
        
        if (velocity.y > 0 && translation.y > 20) {
            [self blurHeaderImage];
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headerImageHeightConstraint.constant = _originalConstraint;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.headerImageView setImageWithURL:self.user.bannerUrl];
            [self removeBlurHeaderImage];
        }];
    }
}

- (void) menuButtonTapped:(id)sender {
    [self.userSession showMenu];
}

- (void) blurHeaderImage {
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        if (_blurEffectView == nil) {
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            _blurEffectView.frame = self.headerImageView.bounds;
            _blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.headerImageView addSubview:_blurEffectView];
        } else {
            _blurEffectView.frame = self.headerImageView.bounds;
        }
    }
}

- (void) removeBlurHeaderImage {
    if (_blurEffectView != nil) {
        [_blurEffectView removeFromSuperview];
        _blurEffectView = nil;
    }
}

- (void) setUser:(User *)user {
    if ([self view]) {
        [self.headerImageView setImageWithURL:user.bannerUrl];
        [self.profileImageView setImageWithURL:user.avatarUrl];
        self.nameLabel.text = user.name;
        self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
        self.tagLineTextView.text = user.tagLine;
        self.followersCountLabel.text = [Utils numberWithShortcut:user.followersCount];
        self.followingCountLabel.text = [Utils numberWithShortcut:user.friendsCount];
    }
}
@end
