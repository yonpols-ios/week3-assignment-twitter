//
//  HamburgerMenuViewController.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/12/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HamburgerMenuViewController;

@protocol HamburgerMenuViewControllerDelegate <NSObject>

@required
- (BOOL)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController willShowMenuWithAnimation:(BOOL)animation;
- (void)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController didShowMenuWithAnimation:(BOOL)animation;
- (BOOL)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController willCloseMenuWithAnimation:(BOOL)animation;
- (void)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController didCloseMenuWithAnimation:(BOOL)animation;

- (BOOL)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController willChangeContentWithAnimation:(BOOL)animation from:(UIViewController *)from to:(UIViewController *)to;
- (void)hamburgerMenuViewController:(HamburgerMenuViewController *)viewController didChangeContentWithAnimation:(BOOL)animation from:(UIViewController *)from to:(UIViewController *)to;

@end

@interface HamburgerMenuViewController : UIViewController

@property (weak, nonatomic) id<HamburgerMenuViewControllerDelegate> delegate;
@property (weak, nonatomic) UIViewController *menuViewController;
@property (weak, nonatomic) UIViewController *contentViewController;
@property (assign, readonly, nonatomic) BOOL menuOpen;

- (void) openMenu;
- (void) closeMenu;

@end
