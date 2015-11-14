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

@end

@implementation HamburgerMenuViewController {
    CGFloat _originalcontentContainerLeadingConstant;
    BOOL _delegateActionAnswer;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    _menuOpen = NO;
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
        
        if (self.menuOpen) {
            [self closeMenuWithAnimation:YES];
        }
    }
}

- (void) openMenuWithAnimation:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.25 : 0) animations:^{
        self.contentContainerLeadingConstraint.constant = self.view.frame.size.width - 50;
    } completion:^(BOOL finished) {
        _menuOpen = YES && finished;
    }];
}

- (void) closeMenuWithAnimation:(BOOL)animated {
    [UIView animateWithDuration:(animated ? 0.25 : 0) animations:^{
        self.contentContainerLeadingConstraint.constant = 0;
    } completion:^(BOOL finished) {
        _menuOpen = !finished;
    }];
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
        self.contentContainerLeadingConstraint.constant = _originalcontentContainerLeadingConstant + translation.x;
    } else if (sender.state == UIGestureRecognizerStateEnded && _delegateActionAnswer) {
        [UIView animateWithDuration:0.25 animations:^{
            if (velocity.x > 0) {
                self.contentContainerLeadingConstraint.constant = self.view.frame.size.width - 50;
            } else {
                self.contentContainerLeadingConstraint.constant = 0;
            }
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (finished) {
                _menuOpen = !_menuOpen;
                if (self.delegate) {
                    if (_menuOpen) {
                        [self.delegate hamburgerMenuViewController:self didShowMenuWithAnimation:YES];
                    } else {
                        [self.delegate hamburgerMenuViewController:self didCloseMenuWithAnimation:YES];
                    }
                }
            }
        }];
    }
}

@end
