//
//  YFLrcCell.h
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYLrcLine;
@interface YFLrcCell : UITableViewCell
@property (nonatomic,strong)ZYLrcLine *lrc;
+(instancetype)cellWithTv:(UITableView *)tv;
@end
