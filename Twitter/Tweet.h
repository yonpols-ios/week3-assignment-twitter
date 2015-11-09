//
//  Tweet.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/7/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (strong, nonatomic) NSString *tweetId;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) User *author;
@property (strong, nonatomic) NSDictionary *rawData;
@property (strong, nonatomic) Tweet *retweetedFrom;
@property (strong, nonatomic) Tweet *inReplyTo;
@property (assign, nonatomic) long long retweetCount;
@property (assign, nonatomic) long long likeCount;
@property (assign, nonatomic) BOOL retweeted;
@property (assign, nonatomic) BOOL liked;

+ (NSArray *) tweetsWithArray:(NSArray *)array;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
- (instancetype) initFromText:(NSString *)text author:(User *)author inReplyTo:(Tweet *)inReplyTo;
- (void) updateWithDictionary:(NSDictionary *)dictionary;

- (NSString *) originalTweetId;

@end
