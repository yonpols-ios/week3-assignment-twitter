//
//  TwitterClient.h
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/3/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1RequestOperationManager.h>
#import "User.h"
#import "Tweet.h"
#import "Session.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;

- (void) processOpenUrl:(NSURL *)url;

- (void) homeTimeLineWithParameters:(NSDictionary *)parameters completion:(void (^)(NSArray * tweets, NSError * error))completion;

- (void) likeTweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError *error))completion;
- (void) unlikeTweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError * error))completion;
- (void) retweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError *error))completion;
- (void) unRetweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError * error))completion;
- (void) tweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError * error))completion;

@end
