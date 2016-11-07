//
//  YFBasVC.m
//  day39-project01
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFBasVC.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@interface YFBasVC ()
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation YFBasVC

- (void)viewDidLoad {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [super viewDidLoad];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)dismLoadV{
    if(self.hud){
        [_hud removeFromSuperview];
        [_hud hide:YES];
        _hud=0;
    }
}
-(void)showLoadVWithMes:(NSString *)mes{

        self.hud=[[MBProgressHUD alloc] initWithView:self.view];
        self.hud.labelText=mes;
//        self.hud.mode=MBProgressHUDModeText;
        [self.hud show:YES];
    
        [self.view addSubview:self.hud];

}
-(void)showToast:(NSString *)mes{
    [self.view makeToast:mes];
}




@end
