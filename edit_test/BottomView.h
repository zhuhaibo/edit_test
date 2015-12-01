//
//  BottomView.h
//  edit_test
//
//  Created by Ants on 15/11/30.
//  Copyright © 2015年 Ants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BottomType) {
    filterType,
    mvType,
    musicType,
    waterMarkType
};

@interface BottomView : UIView
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) void(^itemDidSelected)(NSIndexPath* indexPath, BottomType type, id someThing);
- (void)bottomViewTypeChange:(BottomType)type;
@end
