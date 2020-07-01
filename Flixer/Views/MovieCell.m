//
//  MovieCell.m
//  Flixer
//
//  Created by Andres Barragan on 24/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

#define ANIMATION_DURATION ((double) 0.5)

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColor.systemGray2Color;
    self.selectedBackgroundView = backgroundView;
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;

    self.titleLabel.text = [self.movie.title uppercaseString];
    self.synopsisLabel.text = self.movie.overview;

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
    
    NSURLRequest *backdropRequest = [NSURLRequest requestWithURL:movie.backdropURL];
    [self.backdropView setImageWithURLRequest:backdropRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            self.backdropView.alpha = 0.0;
            self.backdropView.image = image;
            
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                self.backdropView.alpha = 0.3;
            }];
        }
        else {
            self.backdropView.image = image;
        }
    }
    failure:NULL];
}

@end
