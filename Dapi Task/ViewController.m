//
//  ViewController.m
//  Dapi Task
//
//  Created by Antoun on 15/02/2021.
//  Copyright © 2021 Antoun. All rights reserved.
//

#import "ViewController.h"
#import "LinksTableViewCell.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableViewSites;

@property NSArray *myArray;

@end

@implementation ViewController

NSArray *tableData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initArray];
    
    [_tableViewSites registerNib:[UINib nibWithNibName:@"LinksTableViewCell" bundle:nil] forCellReuseIdentifier:@"LinksTableViewCell"];
    _tableViewSites.delegate = self;
    _tableViewSites.dataSource = self;
    _tableViewSites.rowHeight = 70;
    
    
}- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    LinksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinksTableViewCell"];
    
    if (cell == nil) {
        cell = [[LinksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LinksTableViewCell"];
    }
    
    [cell setDetails:[tableData objectAtIndex:indexPath.row]];
//    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableData count];
    
}

- (void) initArray{
    tableData = [NSArray arrayWithObjects:@"apple.com",
                 @"spacex.com",
                 @"dapi.co",
                 @"facebook.com",
                 @"microsoft.com",
                 @"amazon.com",
                 @"boomsupersonic.com",
                 @"twitter.com",
                 nil];
}

@end
