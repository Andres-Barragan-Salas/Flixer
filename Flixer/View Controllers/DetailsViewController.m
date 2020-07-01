//
//  DetailsViewController.m
//  Flixer
//
//  Created by Andres Barragan on 24/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"

#define ANIMATION_DURATION ((double) 0.5)

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteAverageLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.posterView.image = [UIImage imageNamed:@"posterPlaceHolder"];
    
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:self.movie.posterURL];
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
    
    NSURLRequest *backdropRequest = [NSURLRequest requestWithURL:self.movie.backdropURL];
    [self.backdropView setImageWithURLRequest:backdropRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            self.backdropView.alpha = 0.0;
            self.backdropView.image = image;
            
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                self.backdropView.alpha = 1.0;
            }];
        }
        else {
            self.backdropView.image = image;
        }
    }
    failure:NULL];
    
    self.titleLabel.text = [self.movie.title uppercaseString];
    self.releaseDateLabel.text = self.movie.releaseDate;
    
    NSNumber *voteAverage = self.movie.voteAverage;
    self.voteAverageLabel.text = [NSString stringWithFormat:@"%@", voteAverage];
    if ([voteAverage intValue] < 6) {
        self.voteAverageLabel.textColor = UIColor.redColor;
    }
    
    self.synopsisLabel.text = self.movie.overview;
                               
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movieId = self.movie.idStr;
}

@end
