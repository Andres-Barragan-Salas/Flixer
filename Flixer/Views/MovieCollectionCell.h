//
//  MovieCollectionCell.h
//  Flixer
//
//  Created by Andres Barragan on 25/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (nonatomic, strong) Movie *movie;

- (void)setMovie:(Movie *)movie; 

@end

NS_ASSUME_NONNULL_END
