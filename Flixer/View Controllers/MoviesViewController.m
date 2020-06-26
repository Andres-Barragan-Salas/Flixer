//
//  MoviesViewController.m
//  Flixer
//
//  Created by Andres Barragan on 24/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged]; //function to be called when the refresh control is called
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchMovies {
        //Cancel current search when reloading
        [self searchBarCancelButtonClicked:self.searchBar];
    
        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
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
                   self.filteredMovies = self.movies;
                   
                   [self.tableView reloadData];
               }
            
            [self.activityIndicator stopAnimating];
            [self.refreshControl endRefreshing];
           }];
        [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    cell.titleLable.text = [movie[@"title"] uppercaseString];
    cell.synopsisLable.text = movie[@"overview"];

    
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
            
            [UIView animateWithDuration:0.5 animations:^{
                cell.posterView.alpha = 1.0;
            }];
        }
        else {
            cell.posterView.image = image;
        }
    }
    failure:NULL];
    
    NSString *backdropURLString = movie[@"backdrop_path"];
    NSString *fullbackdropURLString = [NSString stringWithFormat:@"%@%@", baseURLString, backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullbackdropURLString];
    NSURLRequest *backdropRequest = [NSURLRequest requestWithURL:backdropURL];
    [cell.backdropView setImageWithURLRequest:backdropRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        if (imageResponse) {
            cell.backdropView.alpha = 0.0;
            cell.backdropView.image = image;
            
            [UIView animateWithDuration:0.5 animations:^{
                cell.backdropView.alpha = 0.3;
            }];
        }
        else {
            cell.backdropView.image = image;
        }
    }
    failure:NULL];
    
    return cell; 
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie; 
}


@end
