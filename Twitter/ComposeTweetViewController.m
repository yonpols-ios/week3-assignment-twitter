//
//  ComposeTweetViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/8/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "UIImageView+AFNetworking.h"

long const TWEET_MAX_LENGTH = 140;

@interface ComposeTweetViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyInfoHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyInfoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tweetTextHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *replyToLabel;

@property (weak, nonatomic) IBOutlet UIView *keyboardBar;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *tweetButton;

@property (strong, nonatomic) User *author;
@property (strong, nonatomic) Tweet *inReplyTo;
@property (weak, nonatomic) IBOutlet UITextView *tweetText;

@end

@implementation ComposeTweetViewController

- (instancetype) initWithUser:(User *)user inReplyTo:(Tweet *)tweet {
    if (self == [super initWithNibName:@"ComposeTweetViewController" bundle:nil]) {
        self.author = user;
        self.inReplyTo = tweet;
    }
    
    return self;
}
- (instancetype) initWithUser:(User *)user {
    return [self initWithUser:user inReplyTo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tweetText.delegate = self;
    [self.keyboardBar removeFromSuperview];
    [self.tweetText setInputAccessoryView:self.keyboardBar];
    
    self.tweetButton.layer.cornerRadius = 4;
    self.tweetButton.layer.masksToBounds = YES;
    
    if (self.inReplyTo) {
        self.replyInfoHeightConstraint.priority = 250;
        self.replyInfoTopConstraint.priority = 999;
        self.replyToLabel.text = [NSString stringWithFormat:@"In Reply To %@", self.inReplyTo.author.name];
        self.tweetText.text = [NSString stringWithFormat:@"@%@ ", self.inReplyTo.author.screenName];
    } else {
        self.replyInfoHeightConstraint.priority = 999;
        self.replyInfoTopConstraint.priority = 250;
        self.tweetText.text = @"";
    }
    
    UIImage *closeImage = [UIImage imageNamed:@"close"];
    closeImage = [closeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *closeCompose = [[UIBarButtonItem alloc]initWithImage:closeImage
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(dismissController)];
    self.navigationItem.rightBarButtonItem = closeCompose;

    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [avatarImageView setImageWithURL:self.author.avatarUrl];
    avatarImageView.layer.cornerRadius = 4;
    avatarImageView.layer.masksToBounds = YES;
    UIBarButtonItem *authorImage = [[UIBarButtonItem alloc] initWithCustomView:avatarImageView];
    self.navigationItem.leftBarButtonItem = authorImage;

    [self textViewDidChange:self.tweetText];
    [self.tweetText becomeFirstResponder];
    [self.tweetText setSelectedTextRange:[self.tweetText textRangeFromPosition:[self.tweetText endOfDocument] toPosition:[self.tweetText endOfDocument]]];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGSize newSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)];
    self.tweetTextHeightConstraint.constant = newSize.height;
    unsigned long count = TWEET_MAX_LENGTH - textView.text.length;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%ld", count];
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger insertDelta = text.length - range.length;
    return (!(textView.text.length + insertDelta > TWEET_MAX_LENGTH));
}

- (IBAction)tweetButtonClicked:(UIButton *)sender {
    [self.delegate composeTweetViewController:self newTweet:self.tweetText.text inReplyTo:self.inReplyTo];
    [self dismissController];
}

- (void) dismissController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
