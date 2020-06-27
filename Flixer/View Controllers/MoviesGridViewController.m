//
//  MoviesGridViewController.m
//  Flixer
//
//  Created by Andres Barragan on 25/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "MoviesGridViewController.h"
#import "MovieCollectionCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

#define ANIMATION_DURATION ((double) 0.3)

@interface MoviesGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSNumber *categoryChoice;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviesGridViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *titleByCategory = @[@"FAMILY", @"HORROR", @"ACTION", @"ROMANCE"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.categoryChoice = @([defaults integerForKey:@"category_index"]);
    
    self.navigationItem.title = titleByCategory[[self.categoryChoice intValue]];
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    
    //Layout adjustments
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchMovies {
    NSArray* categoryId = @[@(508439), @(521531), @(603), @(522098)];
    
    int categorySelection = 0;
    if (categoryId[[self.categoryChoice intValue]]) {
        categorySelection = [self.categoryChoice intValue];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1", categoryId[categorySelection]];
    
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error != nil) {
                   NSLog(@"%@", [error localizedDescription]);
                   
                   //Error while fetching content
                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                          message:@"Please check your Internet connection."
                   preferredStyle:(UIAlertControllerStyleAlert)];
                   
                   UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                                            [self fetchMovies];
                                                                    }];
                   [alert addAction:tryAgainAction];
                   
                   [self presentViewController:alert animated:YES completion:^{}];
               }
               else {
                   NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                   
                   self.movies = dataDictionary[@"results"];
                   
                   [self.collectionView reloadData];
               }
            
            [self.activityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
           }];
        [task resume];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullposterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullposterURLString];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterURL];
    cell.posterView.image = [UIImage imageNamed:@"posterPlaceHolder"];
    [cell.posterView setImageWithURLRequest:posterRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            cell.posterView.alpha = 0.0;
            cell.posterView.image = image;
            
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                cell.posterView.alpha = 1.0;
            }];
        }
        else {
            cell.posterView.image = image;
        }
    }
    failure:NULL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[MovieCollectionCell class]]) {
        MovieCollectionCell *tappedCell = sender;
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            tappedCell.posterView.alpha = 0.5;
            tappedCell.posterView.alpha = 1.0;
        }];
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        NSDictionary *movie = self.movies[indexPath.item];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.movie = movie;
    }
}

@end
