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
#import "MovieApiManager.h"
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
    CGFloat itemWidth = (self.view.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

- (void)fetchMovies {
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchCategory:self.categoryChoice onComplete:^(NSArray *movies, NSError *error) {
            if (error){
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
                self.movies = movies;
                [self.collectionView reloadData];
            }
            
            [self.activityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
        }];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.item];
    
    [cell setMovie:movie];
    
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
        Movie *movie = self.movies[indexPath.item];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.movie = movie;
    }
}

@end
