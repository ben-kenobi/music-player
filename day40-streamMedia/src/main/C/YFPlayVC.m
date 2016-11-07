


//
//  YFPlayVC.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFPlayVC.h"
#import "YFPlayCB.h"
#import "ZYMusic.h"
#import "YFMusicTool.h"
#import "YFLrcV.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YFAudioMan.h"

@interface YFPlayVC ()<AVAudioPlayerDelegate>
@property (nonatomic,strong)ZYMusic *playing;
@property (nonatomic,strong)UIView *top;

@property (nonatomic,strong)UIImageView *bgimg;
@property (nonatomic,strong)UILabel *musicName;
@property (nonatomic,strong)UILabel *singerName;
@property (nonatomic,strong)UIButton *dragPro;
@property (nonatomic,strong)UIButton *exit;
@property (nonatomic,strong)UIButton *showlrc;
@property (nonatomic,strong)UIButton *play;
@property (nonatomic,strong)YFPlayCB *cb;

@property (nonatomic,strong)YFLrcV *lrcv;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)CADisplayLink *lrctimer;
@property (nonatomic,assign)BOOL isInterruption;
@end

@implementation YFPlayVC


-(AVAudioPlayer *)player{
    return [[YFAudioMan share]playerBy:_playing.filename];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor randColor];
    
    [self initUI];
}


-(void)show{
    UIWindow *win=iApp.keyWindow;
    self.view.bounds=win.bounds;
    [win addSubview:self.view];
    self.view.y=self.view.h;
    self.view.hidden=NO;
    if(self.playing!=[YFMusicTool playingMusic]){
        [self resetPlaying];
    }
    
    win.userInteractionEnabled=NO;
    [UIView animateWithDuration:.25 animations:^{
        self.view.y=0;
    }completion:^(BOOL finished) {
        win.userInteractionEnabled=YES;
        [self startPlaying];
    }];
}


-(void)startPlaying{
    if(self.playing==[YFMusicTool playingMusic]){
        [self addTimer];
        [self addLrcTimer];
        return ;
    }
    
    self.playing=[YFMusicTool playingMusic];
    self.bgimg.image=img(self.playing.icon);
    self.musicName.text=self.playing.name;
    self.singerName.text=self.playing.singer;
    
    AVAudioPlayer *player = [[YFAudioMan share] play:self.playing.filename];
    player.delegate=self;
    
    self.cb.dura=player.duration;
    self.lrcv.file=self.playing.lrcname;
    self.cb.play.selected=YES;
    
    [self addTimer];
    [self addLrcTimer];
    
    [self updateLockedScreenMusic];

}
-(void)resetPlaying{
    self.bgimg.image=img(@"play_cover_pic_bg");
    self.singerName.text=0;
    self.musicName.text=0;
    self.cb.dura=0;
    self.cb.curtime=0;
    
    [[YFAudioMan share] stop:self.playing.filename];
    self.lrcv.file=@"";
    self.lrcv.curtime=0;
    [self removeTimer];
    [self removeLrcTimer];
    
}

-(void)addTimer{
    [self updateTimer];
    if(!self.player.isPlaying) return ;
    [self removeTimer];
    self.timer=iTimer(.5, self, @selector(updateTimer), 0);
}

-(void)removeTimer{
    [self.timer invalidate];
    self.timer=0;
}
-(void)updateTimer{
    [self.cb setCurtime:self.player.currentTime];
}

-(void)addLrcTimer{
    [self updateLrcTimer];
    if(self.lrcv.hidden||!self.player.isPlaying) return;

    [self removeLrcTimer];
    self.lrctimer=iDLink(self, @selector(updateLrcTimer));
    
}
-(void)removeLrcTimer{
    [self.lrctimer invalidate];
    self.lrctimer=0;
}

-(void)updateLrcTimer{
    self.lrcv.curtime=self.player.currentTime;
}


-(void)onBtnClicked:(UIButton *)sender{
    if(sender==self.showlrc){
        self.lrcv.hidden=!self.lrcv.hidden;
        sender.selected=!sender.selected;
        self.lrcv.hidden?[self removeLrcTimer]:[self addLrcTimer];
    }else if(sender==self.exit){
        iApp.keyWindow.userInteractionEnabled=NO;
        [UIView animateWithDuration:.25 animations:^{
            self.view.y=self.view.h;
        }completion:^(BOOL finished) {
            self.view.hidden=YES;
            [self removeTimer];
            [self removeLrcTimer];
            iApp.keyWindow.userInteractionEnabled=YES;
        }];
    }
}




-(void)initUI{
    CGFloat both=95,pad=10;
    self.top=[[UIView alloc] initWithFrame:(CGRect){0,0,self.view.w,self.view.h-both+pad*.5}];
    [self.view addSubview:_top];
   self.cb= [[YFPlayCB alloc] initWithFrame:(CGRect){0,_top.b-pad*.5,_top.w,both}];
    [self.view addSubview:self.cb];
    
    self.bgimg=[[UIImageView alloc] initWithFrame:_top.bounds];
    self.bgimg.image=img(@"play_cover_pic_bg");
    [_top addSubview:self.bgimg];
    
    UIView *namebg=[[UIView alloc] initWithFrame:(CGRect){0,_top.h-50,_top.w,50}];
    [_top addSubview:namebg];
    
    
    self.musicName=[[UILabel alloc] initWithFrame:(CGRect){pad,0,namebg.w-pad*2,21}];
    self.musicName.font=iFont(15);
    [namebg addSubview:self.musicName];
    self.singerName=[[UILabel alloc] initWithFrame:(CGRect){pad,self.musicName.b,namebg.w-pad*2,namebg.h-self.musicName.b}];
    [namebg addSubview:self.singerName];
    self.singerName.font=iFont(13);
    namebg.backgroundColor=iColor(255, 255, 255, .5);
    
    UIButton *(^newb)(CGRect,UIImage *)=^(CGRect frame,UIImage *img){
        UIButton *b=[[UIButton alloc] initWithFrame:frame];
        [_top addSubview:b];
        [b setImage:img forState:UIControlStateNormal];
        return b;
    };
    
    self.dragPro=newb((CGRect){(_top.w-42)*.5,namebg.y+pad,42,25},0);
    self.dragPro.backgroundColor=iColor(0, 0, 0, .7);
    self.dragPro.titleLabel.font=iFont(14);
    self.dragPro.hidden=YES;
    self.exit=newb((CGRect){pad,pad*3,42,48},img(@"quit"));
    self.showlrc=newb((CGRect){_top.w-pad-42,pad*3,42,48},img(@"lyric_normal"));
    [self.showlrc setImage:img(@"pic_normal") forState:4];
    [self.showlrc addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.exit addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.showlrc.showsTouchWhenHighlighted=YES;
    self.exit.showsTouchWhenHighlighted=YES;
    __weak typeof(self)ws=self;
    [self.cb setOnChange:^(NSInteger flag) {
        [ws playStateChange:flag];
    }];
    
    
    
    
    
    [self.cb setProChange:^(CGFloat curtime,NSInteger state,CGFloat x) {
        [ws.dragPro setTitle:[ws stringWithTime:curtime] forState:0];
        ws.dragPro.x=x;
        if(state==-1){
            [ws updateLrcTimer];
            ws.player.currentTime=curtime;
        }else if(state==UIGestureRecognizerStateBegan) {
            [ws removeTimer];
            [ws removeLrcTimer];
            ws.dragPro.hidden=NO;
            ws.dragPro.y=ws.dragPro.superview.h-15-ws.dragPro.h;
        }else if(state==UIGestureRecognizerStateEnded){
            ws.player.currentTime=curtime;
            [ws addLrcTimer];
            [ws addTimer];
            ws.dragPro.hidden=YES;
        }
        
    }];
}

-(void)playStateChange:(NSInteger)flag{
    if(flag==2){
        [[YFAudioMan share]play:self.playing.filename];
        [self addTimer];
        [self addLrcTimer];
    }else if(flag==0){
        [[YFAudioMan share] pause:self.playing.filename];
        [self removeTimer];
        [self removeLrcTimer];
    }else{
        iApp.keyWindow.userInteractionEnabled=NO;
        [[YFAudioMan share] stop:self.playing.filename];
        [YFMusicTool setPlayingMusic:flag==1?[YFMusicTool nextMusic]:[YFMusicTool previousMusic]];
        [self removeTimer];
        [self removeLrcTimer];
        [self startPlaying];
        iApp.keyWindow.userInteractionEnabled=YES;
        
    }

}








-(YFLrcV *)lrcv{
    if(!_lrcv){
        _lrcv=[[YFLrcV alloc] initWithFrame:(CGRect){0,0,_top.w,_top.h-50}];
        _lrcv.hidden=YES;
        [self.top addSubview:_lrcv];
        [self.top insertSubview:self.exit aboveSubview:_lrcv];
        [self.top insertSubview:self.showlrc aboveSubview:_lrcv];
    }
    return _lrcv;
}

- (NSString *)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute, second];
}





#pragma mark --delegate


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playStateChange:1];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if([self.player isPlaying]){
        [self playStateChange:0];
        self.isInterruption = YES;
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (self.isInterruption) {
        self.isInterruption = NO;
        [self playStateChange:2];
    }
}






#pragma mark ----锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic
{
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = self.playing.name;
    // 歌手
    info[MPMediaItemPropertyArtist] = self.playing.singer;
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = self.playing.name;
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.playing.icon]];
    // 设置持续时间（歌曲的总时间）
    info[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    // 设置当前播放进度
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    
    // 切换播放信息
    center.nowPlayingInfo = info;
    
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
    // 开始监控
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

#pragma mark - 远程控制事件监听
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //    event.type; // 事件类型
    //    event.subtype; // 事件的子类型
    //    UIEventSubtypeRemoteControlPlay                 = 100,
    //    UIEventSubtypeRemoteControlPause                = 101,
    //    UIEventSubtypeRemoteControlStop                 = 102,
    //    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
    //    UIEventSubtypeRemoteControlNextTrack            = 104,
    //    UIEventSubtypeRemoteControlPreviousTrack        = 105,
    //    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
    //    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
    //    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
    //    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [self playStateChange:2 ];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self playStateChange:0 ];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self playStateChange:1 ];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self playStateChange:-1 ];
            
        default:
            break;
    }
}




@end
