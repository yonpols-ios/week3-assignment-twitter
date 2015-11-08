//
//  TweetTableViewCell.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterClient.h"
#import "Utils.h"

@interface TweetTableViewCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;

@end
