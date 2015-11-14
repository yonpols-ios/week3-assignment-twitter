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

@property (strong, nonatomic) NSArray *menuActions;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuActions = @[
                         @{@"text": @"Profile"},
                         @{@"text": @"Timeline"},
                         @{@"text": @"Mentions"},
                        ];

    self.menuTableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuActions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self dequeueBasicCellForTableView:tableView];
    
    cell.textLabel.text = self.menuActions[indexPath.row][@"text"];
    
    return cell;
}


- (void) setUser:(User *)user {
    _user = user;
    if (self.view) {
        [self.avatarImage setImageWithURL:user.avatarUrl];
        self.nameLabel.text = user.name;
        self.descriptionLabel.text = user.tagLine;
    }
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
