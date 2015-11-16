//
//  CustomNavigationViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/16/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "CustomNavigationViewController.h"

@interface CustomNavigationViewController ()

@end

@implementation CustomNavigationViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.visibleViewController preferredStatusBarStyle];
}


@end
