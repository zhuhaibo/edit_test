//
//  BottomCollectionViewCell.m
//  edit_test
//
//  Created by Ants on 15/11/30.
//  Copyright © 2015年 Ants. All rights reserved.
//

#import "BottomCollectionViewCell.h"
#import "BottomModel.h"

@interface BottomCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation BottomCollectionViewCell

- (void)setModel:(BottomModel *)model {
    _model = model;
    self.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", model.img]];
    self.label.text = model.text;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
