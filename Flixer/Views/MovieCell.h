//
//  MovieCell.h
//  Flixer
//
//  Created by Andres Barragan on 24/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (nonatomic, strong) Movie *movie;

- (void)setMovie:(Movie *)movie;

@end

NS_ASSUME_NONNULL_END
