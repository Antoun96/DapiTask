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

@property (weak, nonatomic) IBOutlet UIButton *buttonStart;

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
    
//    [self getContentLength:^(long long returnValue) {
//         NSLog(@"your content length : %lld",returnValue);
//    } url:tableData[indexPath.row]];
    
    [cell setDetails:[tableData objectAtIndex:indexPath.row]];
    
//    cell.imageViewLogo.image = myImage;
    
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

- (void) getContentLength : (void(^)(NSString* returnValue))completionHandler url:(NSString*) url {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *fullurl = @"https://www.";
    fullurl = [fullurl stringByAppendingString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:fullurl]];
    request.HTTPMethod = @"HEAD";
    [request addValue:@"identity" forHTTPHeaderField:@"Accept-Encoding"];
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    NSURLSessionDownloadTask *uploadTask
    = [session downloadTaskWithRequest:request
                     completionHandler:^(NSURL *url,NSURLResponse *response,NSError *error) {
        
        NSLog(@"handler size: %lld", response.expectedContentLength);
        long totalContentFileLength = [[NSNumber alloc] initWithFloat:response.expectedContentLength].longLongValue;
        
        if (totalContentFileLength == -1){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
            totalContentFileLength = httpResponse.statusCode;
            
            completionHandler([NSString stringWithFormat:@"%ld", totalContentFileLength]);
        }else{
         
            completionHandler([self changeBytesToPrintableValues:totalContentFileLength]);
        }
        
        dispatch_semaphore_signal(sem);
    }];
    [uploadTask resume];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}
- (IBAction)actionStart:(id)sender {
    
    _buttonStart.hidden = YES;
    
    [self loadInBackground];
}

-(void)loadInBackground{
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        [self startLoadingImageAndContent:0];
    });
}

-(void)startLoadingImageAndContent:(int) index{
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.dapi.queue", DISPATCH_QUEUE_SERIAL);

    dispatch_sync(serialQueue, ^{
        
        NSLog(@"loadimage: %d", index);
        NSData *imageData = [self showImage:index];
        
        __block NSString *formatedContentLength = @"";
        
        [self getContentLength:^(NSString* returnValue) {
            NSLog(@"your content length : %@",returnValue);
             formatedContentLength = returnValue;
        } url:tableData[index]];
        
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            
            NSLog(@"show: %d", index);
            LinksTableViewCell *cell = [self->_tableViewSites cellForRowAtIndexPath: [NSIndexPath indexPathForRow:index inSection:0]];
            
            cell.imageViewLogo.image = [[UIImage alloc] initWithData:imageData];
            cell.imageViewLogo.superview.hidden = NO ;
            
            cell.labelSize.hidden = NO;
            cell.labelSize.text = formatedContentLength;
        });
    });
    
    index += 1;
    if (index < tableData.count){
        
        [self startLoadingImageAndContent: index];
        NSLog(@"loop: %d",index);
    }
}

-(NSData*)showImage:(int) index{
    
    NSString *baseUrl = @"http://www.google.com/s2/favicons?domain=";
    NSString *urlString = [baseUrl stringByAppendingString:tableData[index]];
    NSURL *imageUrl=[NSURL URLWithString: urlString];
    NSData *data=[NSData dataWithContentsOfURL:imageUrl];
    
    NSLog(@"fetch: %d", index);
    
    return data;
}

-(NSString*)changeBytesToPrintableValues:(long long) size{
    
    size = size/1024;
    
    if (size < 1000){
        
        return [NSString stringWithFormat:@"%lld KB", size];
    
    }else if (size >= 1000){
        
        size = size/1024;
        
        return [NSString stringWithFormat:@"%lld MB", size];
    }
    return @"";
}

@end
