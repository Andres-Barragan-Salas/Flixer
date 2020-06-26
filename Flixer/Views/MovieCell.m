//
//  MovieCell.m
//  Flixer
//
//  Created by Andres Barragan on 24/06/20.
//  Copyright © 2020 Andres Barragan. All rights reserved.
//

#import "MovieCell.h"

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

@end
