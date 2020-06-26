//
//  WebViewController.m
//  Flixer
//
//  Created by Andres Barragan on 25/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "WebViewController.h"
#import "WebKit/WebKit.h"

@interface WebViewController () <WKUIDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webVideo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    self.webVideo.UIDelegate = self;
    
    NSString *movieVideoDetailsURLString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", self.movieId];
    NSURL *url = [NSURL URLWithString:movieVideoDetailsURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSArray *movieTrailerDetails = dataDictionary[@"results"];
               
               NSString *trailerURLString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=\%@", movieTrailerDetails[0][@"key"]];
               
               NSURL *trailerURL = [NSURL URLWithString:trailerURLString];
               NSURLRequest *videoRequest = [NSURLRequest requestWithURL:trailerURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
               
               [self.webVideo loadRequest:videoRequest];
           }
        [self.activityIndicator stopAnimating];
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
