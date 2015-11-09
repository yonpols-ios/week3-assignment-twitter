//
//  Tweet.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "Tweet.h"
#import "TwitterClient.h"

@implementation Tweet

+ (NSArray *) tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] init];
    
    for (NSDictionary *tweetData in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:tweetData]];
    }
    
    return tweets;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self == [super init]) {
        [self updateWithDictionary:dictionary];
    }
    
    return self;
}

- (instancetype) initFromText:(NSString *)text author:(User *)author inReplyTo:(nullable Tweet *)inReplyTo {
    if (self == [super init]) {
        self.text = text;
        self.author = author;
        self.inReplyTo = inReplyTo;
        self.createdAt = [NSDate date];
    }
    
    return self;
}

- (void) updateWithDictionary:(NSDictionary *)dictionary {
    self.rawData = dictionary;
    self.tweetId = dictionary[@"id_str"];
    self.text = dictionary[@"text"];
    self.author = [[User alloc] initWithDictionary:dictionary[@"user"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
    self.createdAt = [formatter dateFromString:dictionary[@"created_at"]];
    if (dictionary[@"retweeted_status"]) {
        self.retweetedFrom = [[Tweet alloc]initWithDictionary:dictionary[@"retweeted_status"]];
    }
    self.retweetCount = [dictionary[@"retweet_count"] longLongValue];
    self.likeCount = [dictionary[@"favorite_count"] longLongValue];
    self.retweeted = [dictionary[@"retweeted"] boolValue];
    self.liked = [dictionary[@"favorited"] boolValue];
}

- (NSString *) originalTweetId {
    if (!self.retweeted) {
        return nil;
    }
    
    if (self.retweetedFrom) {
        return self.retweetedFrom.tweetId;
    } else {
        return self.tweetId;
    }
}


@end
