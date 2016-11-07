
//
//  YFLrcCell.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFLrcCell.h"
#import "ZYLrcLine.h"
@implementation YFLrcCell

+(instancetype)cellWithTv:(UITableView *)tv{
    static NSString *const iden=@"YFLrcCellIden";
    YFLrcCell *cell=[tv dequeueReusableCellWithIdentifier:iden];
    if(!cell){
        cell=[[self alloc] initWithStyle:0 reuseIdentifier:iden];
        cell.backgroundColor=[UIColor clearColor];
        cell.selectionStyle=0;
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.numberOfLines=0;
//        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(@0);
//        }];
    }
    return cell;
}

-(void)setLrc:(ZYLrcLine *)lrc{
    _lrc=lrc;
    self.textLabel.text=lrc.word;
}
@end
