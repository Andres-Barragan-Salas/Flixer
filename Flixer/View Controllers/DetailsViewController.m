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

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLable;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.posterView.image = [UIImage imageNamed:@"posterPlaceHolder"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullposterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullposterURLString];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterURL];
    [self.posterView setImageWithURLRequest:posterRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            self.posterView.alpha = 0.0;
            self.posterView.image = image;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.posterView.alpha = 1.0;
            }];
        }
        else {
            self.posterView.image = image;
        }
    }
    failure:NULL];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullbackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullbackdropURLString];
    NSURLRequest *backdropRequest = [NSURLRequest requestWithURL:backdropURL];
    [self.backdropView setImageWithURLRequest:backdropRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            self.backdropView.alpha = 0.0;
            self.backdropView.image = image;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.backdropView.alpha = 1.0;
            }];
        }
        else {
            self.backdropView.image = image;
        }
    }
    failure:NULL];
    
    self.titleLable.text = [self.movie[@"title"] uppercaseString];
    self.synopsisLable.text = self.movie[@"overview"];
                               
    [self.titleLable sizeToFit];
    [self.synopsisLable sizeToFit];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movieId = self.movie[@"id"];
}

@end
