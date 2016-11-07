//
//  YFAudioMan.h
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface YFAudioMan : NSObject

+(instancetype)share;
-(AVAudioPlayer *)play:(NSString *)file;
-(AVAudioPlayer *)playerBy:(NSString *)file;
-(void)pause:(NSString *)file;
-(void)stop:(NSString *)file;
-(void)playSound:(NSString *)file;
-(void)disposeSound:(NSString *)file;

@end
