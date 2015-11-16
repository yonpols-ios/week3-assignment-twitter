//
//  HamburgerMenuViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/12/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "HamburgerMenuViewController.h"

@interface HamburgerMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *menuContainerView;
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentContainerLeadingConstraint;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation HamburgerMenuViewController {
    CGFloat _originalcontentContainerLeadingConstant;
    BOOL _delegateActionAnswer;
    UIView *_overlayView;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _menuOpen = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.contentViewController) {
        return [self.contentViewController preferredStatusBarStyle];
    } else {
        return [super preferredStatusBarStyle];
    }
}

- (void) setMenuViewController:(UIViewController *)menuViewController {
    if (self.view) {
        if (_menuViewController && _menuViewController != menuViewController) {
            [_menuViewController willMoveToParentViewController:nil];
            [_menuViewController.view removeFromSuperview];
            [_menuViewController didMoveToParentViewController:nil];
        }
        _menuViewController = menuViewController;

        [_menuViewController willMoveToParentViewController:self];
        [self.menuContainerView addSubview:menuViewController.view];
        [_menuViewController didMoveToParentViewController:self];
    }
}

- (void) setContentViewController:(UIViewController *)contentViewController {
    if (self.view) {
        if (self.delegate && ![self.delegate hamburgerMenuViewController:self willChangeContentWithAnimation:YES from:_contentViewController to:contentViewController]) {
            return;
        }

        if (_contentViewController && _contentViewController != contentViewController) {
            [_contentViewController willMoveToParentViewController:nil];
            [_contentViewController.view removeFromSuperview];
            [_contentViewController didMoveToParentViewController:nil];
        }
        
        [contentViewController willMoveToParentViewController:self];
        [self.contentContainerView addSubview:contentViewController.view];
        [contentViewController didMoveToParentViewController:self];
        
        [self.delegate hamburgerMenuViewController:self didChangeContentWithAnimation:YES from:_contentViewController to:contentViewController];
        _contentViewController = contentViewController;
        [self setNeedsStatusBarAppearanceUpdate];
        
        if (self.menuOpen) {
            [self closeMenu];
        }
    }
}

- (void) openMenu {
    if (_overlayView == nil) {
        _overlayView = [[UIView alloc] initWithFrame:self.contentContainerView.frame];
        _overlayView.backgroundColor = [UIColor blackColor];
    }

    _overlayView.alpha = 0;
    [self.contentContainerView addSubview:_overlayView];
    self.contentViewController.view.userInteractionEnabled = NO;
    self.tapGestureRecognizer.cancelsTouchesInView = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentContainerLeadingConstraint.constant = self.view.frame.size.width - 50;
        _overlayView.alpha = 0.4;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _menuOpen = YES && finished;
        
        if (finished && self.delegate) {
            [self.delegate hamburgerMenuViewController:self didShowMenuWithAnimation:YES];
        }
    }];
}

- (void) closeMenu {
    [UIView animateWithDuration:0.25 animations:^{
        self.contentContainerLeadingConstraint.constant = 0;
        if (_overlayView) {
            _overlayView.alpha = 0;
        }
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _menuOpen = !finished;
        if (_overlayView) {
            [_overlayView removeFromSuperview];
        }
        if (finished && self.delegate) {
            [self.delegate hamburgerMenuViewController:self didCloseMenuWithAnimation:YES];
        }
        self.contentViewController.view.userInteractionEnabled = YES;
        self.tapGestureRecognizer.cancelsTouchesInView = NO;
    }];
}

- (IBAction)onTapContentGesture:(UITapGestureRecognizer *)sender {
    if (self.menuOpen) {
        [self closeMenu];
    }
}

- (IBAction)onPanContentContainerGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _originalcontentContainerLeadingConstant = self.contentContainerLeadingConstraint.constant;
        if (self.delegate) {
            if (_menuOpen) {
                _delegateActionAnswer = [self.delegate hamburgerMenuViewController:self willCloseMenuWithAnimation:YES];
            } else {
                _delegateActionAnswer = [self.delegate hamburgerMenuViewController:self willShowMenuWithAnimation:YES];
            }
        } else {
            _delegateActionAnswer = YES;
        }
    } else if (sender.state == UIGestureRecognizerStateChanged && _delegateActionAnswer) {
        CGFloat newConstant = _originalcontentContainerLeadingConstant + translation.x;
        if (newConstant >= 0) {
            self.contentContainerLeadingConstraint.constant = newConstant;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded && _delegateActionAnswer) {
        if (velocity.x > 0) {
            [self openMenu];
        } else {
            [self closeMenu];
        }
    }
}

@end
