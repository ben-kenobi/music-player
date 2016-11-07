

//
//  YFPlayVC02.m
//  day40-streamMedia
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 yf. All rights reserved.
//

#import "YFPlayVC02.h"
#import "YFPlayCB.h"
#import "ZYMusic.h"
#import "YFMusicTool.h"
#import "YFLrcV.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "YFAudioMan.h"
@interface YFPlayVC02 ()<AVAudioPlayerDelegate>
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

@implementation YFPlayVC02

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor randColor];
    
    [self initUI];
}

-(void)startPlaying{
    if(self.playing==[YFMusicTool playingMusic]){
        [self addTimer];

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
    
}



-(void)onBtnClicked:(UIButton *)sender{
    if(sender==self.showlrc){
        self.lrcv.hidden=!self.lrcv.hidden;
        sender.selected=!sender.selected;
    }else if(sender==self.exit){
        iApp.keyWindow.userInteractionEnabled=NO;
        [UIView animateWithDuration:.25 animations:^{
            self.view.y=self.view.h;
        }completion:^(BOOL finished) {
            self.view.hidden=YES;
            [self removeTimer];
            iApp.keyWindow.userInteractionEnabled=YES;
        }];
    }
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
    
    UIButton *(^newb)(CGRect,UIImage *)=^(CGRect frame,UIImage *img){
        UIButton *b=[[UIButton alloc] initWithFrame:frame];
        [_top addSubview:b];
        [b setImage:img forState:UIControlStateNormal];
        return b;
    };
    
    self.dragPro=newb((CGRect){(_top.w-52)*.5,namebg.y+pad,52,25},0);
    self.exit=newb((CGRect){pad,pad*3,42,48},img(@"quit"));
    self.showlrc=newb((CGRect){_top.w-pad-42,pad*3,42,48},img(@"lyric_normal"));
    [self.showlrc setImage:img(@"pic_normal") forState:4];
    [self.showlrc addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.exit addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    __weak typeof(self)ws=self;
    [self.cb setOnChange:^(NSInteger flag) {
        [ws playStateChange:flag];
    }];
    
    
    
    
    
    [self.cb setProChange:^(CGFloat curtime,NSInteger state,CGFloat x) {
        [ws.dragPro setTitle:[ws stringWithTime:curtime] forState:0];
        ws.dragPro.x=x;
        

        if(state==-1){
            [[YFAudioMan share]playerBy:ws.playing.filename].currentTime=curtime;
            [ws updateTimer];
        }else if(state==UIGestureRecognizerStateBegan) {
            [ws removeTimer];
            ws.dragPro.hidden=NO;
            ws.dragPro.y=ws.dragPro.superview.h-15-ws.dragPro.h;
        }else if(state==UIGestureRecognizerStateEnded){
             [[YFAudioMan share]playerBy:ws.playing.filename].currentTime=curtime;
            [ws addTimer];
            ws.dragPro.hidden=YES;
        }
        
    }];
}





-(void)addTimer{
    if(![[YFAudioMan share]playerBy:_playing.filename].isPlaying) return ;
    [self removeTimer];
    [self updateTimer];
    self.timer=iTimer(.25, self, @selector(updateTimer), 0);
}

-(void)removeTimer{
    [self.timer invalidate];
    self.timer=0;
}
-(void)updateTimer{
    
    [self.cb setCurtime:[[YFAudioMan share]playerBy:_playing.filename].currentTime];
    if(!self.lrcv.hidden)
        self.lrcv.curtime=[[YFAudioMan share]playerBy:_playing.filename].currentTime;
}





-(void)playStateChange:(NSInteger)flag{
    if(flag==2){
        [[YFAudioMan share]play:self.playing.filename];
        [self addTimer];

    }else if(flag==0){
        [[YFAudioMan share] pause:self.playing.filename];
        [self removeTimer];

    }else{
        iApp.keyWindow.userInteractionEnabled=NO;
        [[YFAudioMan share] stop:self.playing.filename];
        [YFMusicTool setPlayingMusic:flag==1?[YFMusicTool nextMusic]:[YFMusicTool previousMusic]];
        [self removeTimer];

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
    if([[[YFAudioMan share]playerBy:_playing.filename] isPlaying]){
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


@end
