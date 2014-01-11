//
//  LLGViewController.m
//  AnimateLayouts
//
//  Created by Lluis Gerard on 10/01/14.
//  Copyright (c) 2014 Lluis Gerard. All rights reserved.
//

#import "LLGViewController.h"

#import "LLGCell.h"

@interface LLGViewController ()

@end

@implementation LLGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Autolayout animation test";

}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    // Cell
    LLGCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[LLGCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"Cell number %ld", (long)indexPath.row];
    cell.percentage = indexPath.row % 101;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(__unused UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(__unused UITableView *)tableView numberOfRowsInSection:(__unused NSInteger)section {
    return 1010;
}

- (CGFloat)tableView:(__unused UITableView *)tableView heightForRowAtIndexPath:(__unused NSIndexPath *)indexPath {
    return 70.0f;
};

@end
