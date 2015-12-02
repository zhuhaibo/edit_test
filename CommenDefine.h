//
//  CommenDefine.h
//  edit_test
//
//  Created by Ants on 15/12/2.
//  Copyright © 2015年 Ants. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#ifndef CommenDefine_h
#define CommenDefine_h

typedef void(^GenericCallback)(BOOL success, id result);

#pragma mark - String
static inline BOOL isStringEmpty(NSString *value)
{
    BOOL result = FALSE;
    if (!value || [value isKindOfClass:[NSNull class]])
    {
        // null object
        result = TRUE;
    }
    else
    {
        NSString *trimedString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([value isKindOfClass:[NSString class]] && [trimedString length] == 0)
        {
            // empty string
            result = TRUE;
        }
    }
    
    return result;
}

#pragma mark - 文件路径(文件名.类型)
static inline NSString* getFilePath(NSString *name)
{
    NSString *fileName = [name stringByDeletingPathExtension];
    NSLog(@"%@",fileName);
    NSString *fileExt = [name pathExtension];
    NSLog(@"%@",fileExt);
    NSString *inputVideoPath = [[NSBundle mainBundle] pathForResource:fileName ofType:fileExt];
    
    return inputVideoPath;
}

#endif /* CommenDefine_h */
