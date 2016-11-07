
//
//  YFNav.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFNav.h"
#import "YFMainVC.h"

@interface YFNav ()

@end

@implementation YFNav

- (void)viewDidLoad {
    [super viewDidLoad];
 
}
-(instancetype)init{
    YFMainVC *vc=[[YFMainVC alloc] init];
    [self.navigationBar setTranslucent:NO];
    return [super initWithRootViewController:vc];
}


@end
