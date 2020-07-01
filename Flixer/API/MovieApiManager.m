//
//  MovieApiManager.m
//  Flixer
//
//  Created by Andres Barragan on 01/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "MovieApiManager.h"
#import "Movie.h"

@interface MovieApiManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation MovieApiManager

- (id)init {
    self = [super init];

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    return self;
}

- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            NSArray *dictionaries = dataDictionary[@"results"];
            NSArray *movies = [Movie moviesWithDictionaries:dictionaries];
            completion(movies, nil);
        }
    }];
    [task resume];
}

- (void)fetchCategory:(NSNumber *)category onComplete:(void(^)(NSArray *movies, NSError *error))completion{
    NSArray* categoryId = @[@(508439), @(521531), @(603), @(522098)];
    
    int categorySelection = 0;
    if (categoryId[[category intValue]]) {
        categorySelection = [category intValue];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1", categoryId[categorySelection]];
    NSURL *url = [NSURL URLWithString:urlString]; 
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            NSArray *dictionaries = dataDictionary[@"results"];
            NSArray *movies = [Movie moviesWithDictionaries:dictionaries];
            completion(movies, nil);
        }
        else {
            NSLog(@"%@", [error localizedDescription]);
            completion(nil, error);
        }
    }];
    [task resume];
}

@end
