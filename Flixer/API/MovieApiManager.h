//
//  MovieApiManager.h
//  Flixer
//
//  Created by Andres Barragan on 01/07/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieApiManager : NSObject

- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;
- (void)fetchCategory:(NSNumber *)category onComplete:(void(^)(NSArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
