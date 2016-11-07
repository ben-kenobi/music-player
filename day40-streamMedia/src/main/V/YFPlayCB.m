






//
//  YFPlayCB.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFPlayCB.h"

@interface YFPlayCB ()
@property (nonatomic,strong)UIView *cbBg;

@property (nonatomic,strong)UIButton *prev;
@property (nonatomic,strong)UIButton *next;
@property (nonatomic,strong)UIView *probg;
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)UIView *pro;
@property (nonatomic,strong)UIButton *slider;

@end

@implementation YFPlayCB

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}


-(void)initUI{
    self.probg=[[UIView alloc] initWithFrame:(CGRect){0,0,self.w,10}];
    [self addSubview:self.probg];
    self.probg.backgroundColor=iColor(180, 180, 190, 1);
    self.pro=[[UIView alloc] initWithFrame:(CGRect){0,0,0,10}]
    ;
    [self.probg addSubview:self.pro];
    self.pro.backgroundColor=iGlobalBlue;
    
    self.time=[[UILabel alloc] initWithFrame:(CGRect){self.w-42-5,0,42,10}];
    self.time.font=iFont(10);
    self.time.textAlignment=NSTextAlignmentRight;
    [self.probg addSubview:self.time];
    
    
    
    
    self.cbBg=[[UIView alloc] initWithFrame:(CGRect){0,self.pro.b,self.w,self.h-_pro.b}];
    self.cbBg.backgroundColor=iColor(228, 230, 238, 1);
    [self addSubview:self.cbBg];
    
    UIButton *(^newb)(UIImage *,CGRect,UIView*)=^(UIImage *img,CGRect frame,UIView *sup){
        UIButton *b=[[UIButton alloc] initWithFrame:frame];
        [b setBackgroundImage:img forState:0];
        [sup addSubview:b];
        [b addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        return b;
    };
    
    self.play=newb(img(@"play"),(CGRect){0,0,72,46},self.cbBg);
    [self.play setBackgroundImage:img(@"pause") forState:4];
    self.play.center=self.cbBg.innerCenter;
    self.prev=newb(img(@"previous"),(CGRect){self.play.x-15-41,self.play.y,41,46},self.cbBg);
    self.next=newb(img(@"next"),(CGRect){self.play.r+15,self.play.y,41,46},self.cbBg);
    
    self.slider=newb(img(@"process_thumb"),(CGRect){0,-4,42,21},self);
    [self.slider removeTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.slider.titleLabel.font=iFont(12);
    [self.slider setTitleColor:[UIColor blackColor] forState:0];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gest:)];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gest:)];
    [self.probg addGestureRecognizer:tap];
    [self.slider addGestureRecognizer:pan];
    
    
    self.slider.showsTouchWhenHighlighted=YES;
    self.next.showsTouchWhenHighlighted=YES;
    self.prev.showsTouchWhenHighlighted=YES;
    self.play.showsTouchWhenHighlighted=YES;
}

-(void)gest:(UIGestureRecognizer *)gest{
    CGFloat x=[gest locationInView:self.probg].x;
    CGFloat penc=x/self.probg.w;
    _curtime=_dura*penc;
    [self scrollToX:x time:_curtime];
    if(self.proChange)
        self.proChange(_curtime,[gest isKindOfClass:[UITapGestureRecognizer class]]?-1: gest.state,x);
}
-(void)scrollToX:(CGFloat )x time:(CGFloat)time{
    self.pro.r2=x;
    self.slider.cx=x;
    [self.slider setTitle:[self stringWithTime:time] forState:0];
}

-(void)setDura:(CGFloat)dura{
    _dura=dura;
    self.time.text=[self stringWithTime:dura];
}

-(void)setCurtime:(CGFloat)curtime{
    if(curtime<0||curtime>_dura||_dura==0) return ;
    _curtime=curtime;
    [self scrollToX:self.probg.w*(curtime/_dura) time:_curtime];
    
}

-(void)onBtnClicked:(UIButton *)sender{
    NSInteger i=0;
    if(sender==self.play){
        sender.selected=!sender.selected;
        i=sender.selected?2:0;
    }else if(sender==self.prev){
        i=-1;
    }else if(sender==self.next){
        i=1;
    }
    if(_onChange)
        self.onChange(i);
}


- (NSString *)stringWithTime:(NSTimeInterval)time
{
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d",minute, second];
}


@end
