//
//  YFPlayCB.h
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFPlayCB : UIView
@property (nonatomic,strong)UIButton *play;

@property (nonatomic,strong)void(^onChange)(NSInteger flag);
@property (nonatomic,strong)void(^proChange)(CGFloat curtime,NSInteger state,CGFloat x);

@property (nonatomic,assign)CGFloat dura;
@property (nonatomic,assign)CGFloat curtime;

@end
