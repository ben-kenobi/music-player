//
//  YFMusicTool.h
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYMusic;
@interface YFMusicTool : NSObject

+ (ZYMusic *)playingMusic;

+ (void)setPlayingMusic:(ZYMusic *)playingMusic;


+ (NSArray *)musics;


+ (ZYMusic *)nextMusic;


+ (ZYMusic *)previousMusic;
@end
