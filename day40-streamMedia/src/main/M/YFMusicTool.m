

//
//  YFMusicTool.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFMusicTool.h"
#import "MJExtension.h"
#import "ZYMusic.h"

static NSArray *_musics;
static ZYMusic *_playing;

@implementation YFMusicTool
+ (NSArray *)musics
{
    if (_musics == nil) {
        _musics = [ZYMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}

+ (ZYMusic *)playingMusic
{
    return _playing;
}

+ (void)setPlayingMusic:(ZYMusic *)playingMusic
{
    if (playingMusic == nil || ![_musics containsObject:playingMusic] || playingMusic == _playing) {
        return;
    }
    _playing = playingMusic;
}


+ (ZYMusic *)nextMusic
{
    int nextIndex = 0;
    if (_playing) {
        int playingIndex = (int)[[self musics] indexOfObject:_playing];
        nextIndex = playingIndex + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex = 0;
        }
    }
    return [self musics][nextIndex];
}

+ (ZYMusic *)previousMusic
{
    int previousIndex = 0;
    if (_playing) {
        int playingIndex = (int)[[self musics] indexOfObject:_playing];
        previousIndex = playingIndex - 1;
        if (previousIndex < 0) {
            previousIndex = (int)[self musics].count - 1;
        }
    }
    return [self musics][previousIndex];
}


@end
