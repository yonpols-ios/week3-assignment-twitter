//
//  TwitterClient.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/3/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"UpZS9wo03yj0e9hnsWg1dc8jI";
NSString * const kTwitterConsumerSecret = @"0WO8WHLO9FUEVqB3Ft2ou7rzxj511EHEqe6gIw9etWPsPrGKV2";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (strong, nonatomic) void (^loginCompletion)(User *, NSError *);

@end

@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl]consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *, NSError *))completion {
    if (!completion) {
        return;
    }

    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"got the request token: %@", requestToken);
        
        NSURL *authorizationUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authorizationUrl];
    } failure:^(NSError *error) {
        self.loginCompletion(nil, error);
    }];
}

- (void) timeline:(TwitterTimelineType)type withParameters:(NSDictionary *)parameters completion:(void (^)(NSArray * tweets, NSError * error))completion {
    NSString *endpoint;

    switch (type) {
        case TwitterMentionsTimeline:
            endpoint = @"/1.1/statuses/mentions_timeline.json";
            break;

        case TwitterUserTimeline:
            endpoint = @"/1.1/statuses/home_timeline.json";
            break;
            
        default:
            break;
    }
    
    [self GET:endpoint parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void) processOpenUrl:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"GET" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"/1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [Session setCurrentUser:user];
            self.loginCompletion(user, nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        self.loginCompletion(nil, error);
    }];
}

- (void) likeTweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError * error))completion {
    NSDictionary *parameters = @{@"id": tweet.tweetId};
    
    [self POST:@"/1.1/favorites/create.json" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void) unlikeTweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError * error))completion {
    NSDictionary *parameters = @{@"id": tweet.tweetId};
    
    [self POST:@"/1.1/favorites/destroy.json" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void) retweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError *error))completion {
    NSDictionary *parameters = @{@"id": tweet.tweetId};
    
    NSString *endpoint = [NSString stringWithFormat:@"/1.1/statuses/retweet/%@.json", tweet.tweetId];
    [self POST:endpoint parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void) unRetweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError * error))completion {
    NSString *endpoint = [NSString stringWithFormat:@"/1.1/statuses/show/%@.json", [tweet originalTweetId]];
    NSDictionary *parameters = @{@"include_my_retweet": @(YES)};
    
    [self GET:endpoint parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *tweetId = responseObject[@"current_user_retweet"][@"id_str"];
        NSString *endpoint = [NSString stringWithFormat:@"/1.1/statuses/destroy/%@.json", tweetId];
        [self POST:endpoint parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            completion(nil, nil);
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            completion(nil, error);
        }];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void) tweet:(Tweet *)tweet completion:(void (^)(NSDictionary *newTweetInfo, NSError * error))completion {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"status"] = tweet.text;
    if (tweet.inReplyTo) {
        parameters[@"in_reply_to_status_id"] = tweet.inReplyTo.tweetId;
    };
    
    [self POST:@"/1.1/statuses/update.json" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}



@end
