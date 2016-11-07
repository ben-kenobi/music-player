//
//  YFImgTool.h
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YFImgTool : NSObject

+ (UIImage *)imageCompress:(UIImage *)img targetSize:(CGSize)targetSize;
    

+ (UIImage *)addTextOnImage:(UIImage *)img mark:(NSString *)mark rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color;
    

+ (UIImage *)circleImage:(UIImage *)img borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
    

@end
