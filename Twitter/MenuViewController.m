//
//  MenuViewController.m
//  Twitter
//
//  Created by Juan Pablo Marzetti on 11/12/15.
//  Copyright © 2015 Juan Pablo Marzetti. All rights reserved.
//

#import "MenuViewController.h"
#import "TimelineViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarImageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (strong, nonatomic) NSArray *menuActions;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuActions = @[
                         @{@"text": @"Timeline", @"image": @"home"},
                         @{@"text": @"Mentions", @"image": @"mention"},
                         @{@"text": @"Profile", @"image": @"profile"}
                        ];

    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.avatarImage.layer.cornerRadius = 4;
    self.avatarImage.layer.masksToBounds = YES;

    [self.avatarImage setImageWithURL:self.userSession.user.avatarUrl];
    self.nameLabel.text = self.userSession.user.name;
    self.descriptionLabel.text = self.userSession.user.tagLine;
}

- (void) viewWillAppear:(BOOL)animated {
    UIApplication* sharedApplication = [UIApplication sharedApplication];
    CGFloat kStatusBarHeight = sharedApplication.statusBarFrame.size.height;
    self.avatarImageTopConstraint.constant = 8 + kStatusBarHeight;
    self.nameLabelTopConstraint.constant = 8 + kStatusBarHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userAvatarTapGesture:(id)sender {
    [self.userSession showProfile];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self dequeueBasicCellForTableView:tableView];
    cell.textLabel.text = self.menuActions[indexPath.row][@"text"];
    cell.imageView.image = [UIImage imageNamed:self.menuActions[indexPath.row][@"image"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.userSession showTimeline];
            break;

        case 1:
            [self.userSession showMentions];
            break;

        case 2:
            [self.userSession showProfile];
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableViewCell *)dequeueBasicCellForTableView:(UITableView *)tableView {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

@end
