//
//  DetailsViewController.h
//  Flixer
//
//  Created by Andres Barragan on 24/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
