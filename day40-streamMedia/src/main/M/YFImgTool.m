//
//  YFImgTool.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFImgTool.h"

@implementation YFImgTool
+ (UIImage *)imageCompress:(UIImage *)img targetSize:(CGSize)targetSize{
    CGFloat scalew=targetSize.width/img.size.width;
    CGFloat scaleh=targetSize.height/img.size.height;
    CGFloat scale=scalew<scaleh?scaleh:scalew;
    CGSize isize=(CGSize){img.size.width*scale,img.size.height*scale};
    UIGraphicsBeginImageContextWithOptions(targetSize, 0, 0);
    [img drawInRect:(CGRect){(targetSize.width-isize.width)*.5,(targetSize.height-isize.height)*.5,isize}];
    UIImage *newimg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


+ (UIImage *)addTextOnImage:(UIImage *)img mark:(NSString *)mark rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(img.size, 0, 0);
    [img drawAtPoint:(CGPoint){0,0}];
    [color set];
    [mark drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:0];
    UIImage *newimg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


//+ (UIImage *)circleImage:(UIImage *)img borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
//    CGFloat len=(img.size.width>img.size.height?img.size.height:img.size.width)+borderWidth*2;
//    UIGraphicsBeginImageContextWithOptions((CGSize){len,len}, 0, 0);
//    CGContextRef con=UIGraphicsGetCurrentContext();
//    CGContextAddArc(con, len*.5, len*.5, len*.5, 0, 2*M_PI, 0);
//    CGContextClip(con);
//    
//    [img drawAtPoint:(CGPoint){(len-img.size.width)*.5,(len-img.size.height)*.5}];
//    
//    CGContextAddArc(con, len*.5, len*.5, len*.5-borderWidth*.5, 0, 2*M_PI, 0);
//    CGContextSetLineWidth(con, borderWidth);
//    [borderColor setStroke];
//    CGContextDrawPath(con, 2);
//    UIImage *newimg=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newimg;
//    
//}

+ (UIImage *)circleImage:(UIImage *)img borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    CGFloat len=(img.size.width>img.size.height?img.size.height:img.size.width)+borderWidth*2;
    UIGraphicsBeginImageContextWithOptions((CGSize){len,len}, 0, 0);
    CGContextRef con=UIGraphicsGetCurrentContext();
    
    CGContextAddArc(con, len*.5, len*.5, len*.5, 0, 2*M_PI, 0);
    [borderColor set];
    CGContextDrawPath(con, 0);
    
    CGContextAddArc(con, len*.5, len*.5, len*.5-borderWidth, 0, 2*M_PI, 0);
    CGContextClip(con);
    
    
    [img drawAtPoint:(CGPoint){(len-img.size.width)*.5,(len-img.size.height)*.5}];
    
    UIImage *newimg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
    
}




@end
