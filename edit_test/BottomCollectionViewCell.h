//
//  BottomCollectionViewCell.h
//  edit_test
//
//  Created by Ants on 15/11/30.
//  Copyright © 2015年 Ants. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *BottomCollectionViewCellIdentify = @"BottomCollectionViewCellIdentify";
@class BottomModel;
@interface BottomCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) BottomModel *model;
@end
