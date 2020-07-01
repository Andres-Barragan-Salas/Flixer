//
//  Movie.m
//  Flixer
//
//  Created by Andres Barragan on 01/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
self = [super init];

    // String info
    self.idStr = dictionary[@"id"];
    self.title = dictionary[@"title"];
    self.overview = dictionary[@"overview"];
    self.releaseDate = dictionary[@"release_date"];
    self.voteAverage = dictionary[@"vote_average"];
    
    // URLs
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    // Poster URL
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullposterURLString = [baseURLString stringByAppendingString:posterURLString];
    self.posterURL = [NSURL URLWithString:fullposterURLString];
    // Backdrop URL
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullbackdropURLString = [NSString stringWithFormat:@"%@%@", baseURLString, backdropURLString];
    self.backdropURL = [NSURL URLWithString:fullbackdropURLString];

return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    return movies;
}

@end
