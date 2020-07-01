//
//  Movie.h
//  Flixer
//
//  Created by Andres Barragan on 01/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSNumber *voteAverage;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSURL *backdropURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
