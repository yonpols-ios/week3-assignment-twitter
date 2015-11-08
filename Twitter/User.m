//
//  User.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self == [super init]) {
        self.rawData = dictionary;
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.avatarUrl = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        self.tagLine = dictionary[@"description"];
    }
    
    return self;
}

@end