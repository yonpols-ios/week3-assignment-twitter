//
//  TimelineViewController.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSession.h"

@interface TimelineViewController : UIViewController

@property (strong, nonatomic) UserSession *userSession;
@property (assign, nonatomic) TwitterTimelineType timelineType;

@end
