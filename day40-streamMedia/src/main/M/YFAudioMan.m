
//
//  YFAudioMan.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFAudioMan.h"
@interface YFAudioMan ()
@property (nonatomic,strong)NSMutableDictionary *players;
@property (nonatomic,strong)NSMutableDictionary *ids;
@end
@implementation YFAudioMan

+(void)initialize{
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:0];
    [session setActive:YES error:0];
}

+(instancetype)share{
    static long l=0;
    static YFAudioMan *man=nil;
    dispatch_once(&l, ^{
        man=[[self alloc] init];
        man.players=[NSMutableDictionary dictionary];
        man.ids=[NSMutableDictionary dictionary];
    });
    return man;
}

-(AVAudioPlayer *)play:(NSString *)file{
    if(emptyStr(file)) return 0;
    AVAudioPlayer *player=self.players[file];
    if(!player){
        NSURL *url=[iBundle URLForResource:file withExtension:0];
        if(!url) return 0;
        player =[[AVAudioPlayer alloc]initWithContentsOfURL:url error:0];
        if(![player prepareToPlay]) return nil;
        self.players[file]=player;
    }
    if(![player isPlaying]){
        [player play];
    }
    return player;
}

-(AVAudioPlayer *)playerBy:(NSString *)file{
    return _players[file];
}
-(void)pause:(NSString *)file{
    if(emptyStr(file)) return;
    [self.players[file] pause];
}

-(void)stop:(NSString *)file{
    if(emptyStr(file)) return ;
   AVAudioPlayer *player= self.players[file];
    [player stop];
    [self.players removeObjectForKey:file];
}


-(void)playSound:(NSString *)file{
    if(emptyStr(file))return ;
    SystemSoundID soundid=(int)[self.ids[file] unsignedLongValue];
    if(!soundid){
        NSURL *url=[iBundle URLForResource:file withExtension:0];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundid );
        self.ids[file]=@(soundid);
    }
    AudioServicesPlaySystemSound(soundid);
}

-(void)disposeSound:(NSString *)file{
    if(emptyStr(file)) return ;
    unsigned int sid=(int)[self.ids[file] unsignedLongValue];
    if(sid){
        AudioServicesDisposeSystemSoundID(sid);
        [self.ids removeObjectForKey:file];
    }
    
    
}


@end
