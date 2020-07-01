//
//  MovieCollectionCell.m
//  Flixer
//
//  Created by Andres Barragan on 25/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"

#define ANIMATION_DURATION ((double) 0.3)

@implementation MovieCollectionCell

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:self.movie.posterURL];
    self.posterView.image = [UIImage imageNamed:@"posterPlaceHolder"];
    [self.posterView setImageWithURLRequest:posterRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            self.posterView.alpha = 0.0;
            self.posterView.image = image;
            
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                self.posterView.alpha = 1.0;
            }];
        }
        else {
            self.posterView.image = image;
        }
    }
    failure:NULL];
}

@end
