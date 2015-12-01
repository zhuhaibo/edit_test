//
//  BottomView.m
//  edit_test
//
//  Created by Ants on 15/11/30.
//  Copyright © 2015年 Ants. All rights reserved.
//

#import "BottomView.h"
#import "WaterFLayout.h"
#import "BottomCollectionViewCell.h"
#import "BottomModel.h"

@interface BottomView () <UICollectionViewDataSource, WaterFLayoutDelegate>
@property (nonatomic, assign) BottomType type;

@property (nonatomic, strong) UICollectionView *collView;
@property (nonatomic, strong) WaterFLayout *waterFlow;
@end

@implementation BottomView

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = [dataArray copy];
    [self.collView reloadData];
}

- (void)awakeFromNib {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 2;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN.size.width, self.bounds.size.height) collectionViewLayout:layout];
    self.collView.backgroundColor = [UIColor clearColor];
    self.collView.dataSource = self;
    self.collView.delegate = self;
    [self addSubview:self.collView];
    [self.collView registerNib:[UINib nibWithNibName:@"BottomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:BottomCollectionViewCellIdentify];
}

- (void)bottomViewTypeChange:(BottomType)type {
    self.type = type;
    switch (type) {
        case filterType:
        {
            [self filtertype];
        }
            break;
            
        case mvType:
        {
            [self mvtype];
        }
            break;
            
        case musicType:
        {
            [self musictype];
        }
            break;
        case stickType:
        {
            [self stickType];
        }
            break;
            
        default:
            break;
    }
}

- (void)filtertype {
    
}

- (void)mvtype {
    
}

- (void)musictype {
    [self.collView reloadData];
}

- (void)stickType {
    
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BottomCollectionViewCellIdentify forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 128);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.itemDidSelected) {
        self.itemDidSelected(indexPath, self.type, self.dataArray[indexPath.row]);
    }
}

@end
