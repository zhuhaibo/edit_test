//
//  BottomModel.h
//  edit_test
//
//  Created by Ants on 15/11/30.
//  Copyright © 2015年 Ants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BottomModel : NSObject
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *text;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end
