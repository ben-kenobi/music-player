

//
//  YFLrcV.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFLrcV.h"
#import "ZYLrcLine.h"
#import "YFLrcCell.h"

@interface YFLrcV  ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tv;
@property (nonatomic,strong)NSMutableArray *lrcs;
@property (nonatomic,assign)int idx;
@end

@implementation YFLrcV

-(NSMutableArray *)lrcs{
    if(!_lrcs){
        _lrcs=[ZYLrcLine lrcLinesWithFileName:self.file];
    }
    return _lrcs;
}

-(void)setFile:(NSString *)file{
    if([file isEqualToString:_file]){
        return ;
    }
    _file=[file copy];
    [_lrcs removeAllObjects];
    _lrcs= 0;
    [self.tv reloadData];
}
-(void)setCurtime:(NSTimeInterval)curtime{
    NSInteger ind=self.idx;
    if(_curtime>curtime){
        self.idx=0;
    }
    _curtime=curtime;
    
    int minute=curtime/60;
    int second=(int)curtime%60;
    int msecond=(curtime-(int)curtime)*100;
    NSString *curtimestr=[NSString stringWithFormat:@"%02d:%02d.%02d",minute,second,msecond];
    
    for(int i=self.idx;i<self.lrcs.count;i++){
        ZYLrcLine *curline=self.lrcs[i];
        NSString *curlinetime=curline.time;
        NSString *nextlinetime=0;
        if(i<self.lrcs.count-1){
            ZYLrcLine *next=self.lrcs[i+1];
            nextlinetime=next.time;
        }
        if(([curtimestr compare:curlinetime]!=NSOrderedAscending)&&([curtimestr compare:nextlinetime]==NSOrderedAscending)&&(self.idx!=i)){
            NSArray *reloadLines=@[[NSIndexPath indexPathForItem:ind inSection:0 ],[NSIndexPath indexPathForItem:i inSection:0]];
            
            self.idx=i;
            [self.tv reloadRowsAtIndexPaths:reloadLines withRowAnimation:0];
            [self.tv scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    }
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.userInteractionEnabled=YES;
    self.image=[UIImage imageNamed:@"28131977_1383101943208"];
    self.contentMode=UIViewContentModeScaleToFill;
    self.clipsToBounds=YES;
    self.tv=[[UITableView alloc] initWithFrame:self.bounds];
    self.tv.delegate=self;
    self.tv.dataSource=self;
    self.tv.separatorStyle=0;
    self.tv.backgroundColor=[UIColor clearColor];
    [self addSubview:self.tv];
    self.tv.contentInset=(UIEdgeInsets){self.h*.5,0,self.h*.5,0};
}


#pragma  mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YFLrcCell *cell = [YFLrcCell cellWithTv:tableView];
    cell.lrc = self.lrcs[indexPath.row];
    
    if (indexPath.row == self.idx) {
        
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor=[UIColor orangeColor];
    }
    else{
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor=[UIColor whiteColor];
    }
    return cell;
}







@end
