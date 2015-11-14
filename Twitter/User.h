//
//  User.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSURL *avatarUrl;
@property (strong, nonatomic) NSURL *backgroundUrl;
@property (strong, nonatomic) NSString *tagLine;
@property (assign, nonatomic) NSInteger followersCount;
@property (assign, nonatomic) NSInteger friendsCount;

@property (strong, nonatomic) NSDictionary *rawData;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
