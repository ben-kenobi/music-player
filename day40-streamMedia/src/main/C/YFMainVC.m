//
//  YFMainVC.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFMainVC.h"
#import "YFMusicTool.h"
#import "YFMusicCell.h"
#import "YFPlayVC.h"
#import "ZYMusic.h"
#import "YFPlayVC02.h"

@interface YFMainVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tv;
@property (nonatomic,strong)YFPlayVC *vc;
@property (nonatomic,strong)YFPlayVC02 *vc02;
@property (nonatomic,assign)NSInteger curidx;
@end

@implementation YFMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor randColor]];
    self.navigationItem.title=@"player";
    self.tv=[[UITableView alloc] initWithFrame:(CGRect){0,0,self.view.w,self.view.h} style:UITableViewStylePlain];
    [self.view addSubview:self.tv];
    self.tv.delegate=self;
    self.tv.dataSource=self;
    self.tv.rowHeight=70;
    
}

-(YFPlayVC *)vc{
    if(!_vc){
        _vc=[[YFPlayVC alloc] init];
    }
    return _vc;
}

-(YFPlayVC02 *)vc02{
    if(!_vc02){
        _vc02=[[YFPlayVC02 alloc] init];
    }
    return _vc02;
}


#pragma mark delegate





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [YFMusicTool musics].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YFMusicCell cellWithTv:tableView m:[YFMusicTool musics][indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [YFMusicTool setPlayingMusic:[YFMusicTool musics][indexPath.row]];
    ZYMusic *prem=[YFMusicTool musics][self.curidx];
    prem.playing=NO;
    ZYMusic *curm=[YFMusicTool musics][indexPath.row];
    curm.playing=YES;
    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.curidx inSection:0],indexPath] withRowAnimation:0];
    self.curidx=indexPath.row;
    [self.vc show];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
