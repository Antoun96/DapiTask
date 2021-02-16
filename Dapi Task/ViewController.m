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
    _tableViewSites.rowHeight = 60;
    
}- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    LinksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinksTableViewCell"];
    
    if (cell == nil) {
        cell = [[LinksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LinksTableViewCell"];
    }
    
    NSString *baseUrl = @"http://www.google.com/s2/favicons?domain=";
    NSString *urlString = [baseUrl stringByAppendingString:tableData[indexPath.row]];
    NSURL *myURL=[NSURL URLWithString: urlString];
    NSData *myData=[NSData dataWithContentsOfURL:myURL];

    UIImage *myImage=[[UIImage alloc] initWithData:myData];
    
//    [self getContentLength:^(long long returnValue) {
//         NSLog(@"your content length : %lld",returnValue);
//    } url:tableData[indexPath.row]];
    
    [cell setDetails:[tableData objectAtIndex:indexPath.row]];
    
    cell.imageViewLogo.image = myImage;
    cell.imageViewLogo.superview.hidden = NO ;
    
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [tableData count];
    
}

//init table array
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

- (void) getContentLength : (void(^)(long long returnValue))completionHandler url:(NSString*) url {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *fullurl = @"https://www.";
    fullurl = [fullurl stringByAppendingString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fullurl]];
    request.HTTPMethod = @"HEAD";
    [request addValue:@"identity" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDownloadTask *uploadTask
    = [session downloadTaskWithRequest:request
                     completionHandler:^(NSURL *url,NSURLResponse *response,NSError *error) {
        
        NSLog(@"handler size: %lld", response.expectedContentLength);
        long totalContentFileLength = [[NSNumber alloc] initWithFloat:response.expectedContentLength].longLongValue;
       
        NSLog(@"content length=%ld", totalContentFileLength);
        completionHandler(totalContentFileLength);
        
    }];
    [uploadTask resume];
    
}

@end
