//
//  BottomModel.m
//  edit_test
//
//  Created by Ants on 15/11/30.
//  Copyright © 2015年 Ants. All rights reserved.
//

#import "BottomModel.h"

@implementation BottomModel

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
