//
//  YFMusicCell.h
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYMusic;

@interface YFMusicCell : UITableViewCell
@property (nonatomic,strong)ZYMusic *music;
+(instancetype)cellWithTv:(UITableView *)tv m:(ZYMusic *)m;
@end
