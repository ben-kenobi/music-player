//
//  YFBasNavVC.m
//  day39-project01
//
//  Created by apple on 15/11/21.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFBasNavVC.h"
#import "YFTabBarVC.h"



@interface YFBasNavVC ()


@end

@implementation YFBasNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:pan];
    
    [iNotiCenter addObserver:self selector:@selector(onPan:) name:HOMESCROLLIDEN object:0];
    
    [self initNav];
}

-(void)dealloc{
    [iNotiCenter removeObserver:self];
}
-(void)onPan:(UIPanGestureRecognizer *)gest{
    YFTabBarVC *tab=self.tabBarController;
    [tab hideSubbot];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    YFTabBarVC *tab=self.tabBarController;
    if( self.navigationController.childViewControllers.count==1){
        [tab hideBottom:NO];
        self.lb.hidden=YES;
    }else{
        [tab hideBottom:YES];
        self.lb.hidden=NO;
    }
    [self updateLoginState];
}

-(BOOL)login:(NSString *)username pwd:(NSString *)pwd{
    NSDictionary *dict= iRes4dict(@"login.plist");
    if([username isEqualToString:dict[@"mobile"]]&&[[IProUtil digestStr:pwd] isEqualToString:[IProUtil digestStr:dict[@"user_id"]]]){
        [[YFUserInfo shared] login:dict];
        return 1;
    }
    return 0;
    
}
-(void)logout{
    [[YFUserInfo shared] logout];
}

-(void)initNav{
    self.navigationController.navigationBar.hidden=YES;
    UIView *nav=[[UIView alloc] initWithFrame:(CGRect){0,0,iScreenW,iTopBarH}];
    self.topnav=nav;
    [nav setBackgroundColor:iGlobalBlue];
    [self.view addSubview:nav];
    UIButton *lb=[[UIButton alloc] initWithFrame:(CGRect){0,iStBH,iNavH,iNavH}];
    [nav addSubview:lb];
    [lb addTarget:self action:@selector(onLbClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.lb=lb;
    [lb setImage:img(@"nav_back") forState:UIControlStateNormal];
    UIButton *rb=[[UIButton alloc] init];
    [nav addSubview:rb];
    [rb addTarget:self action:@selector(onRbClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rb=rb;
    [rb setTitle:@"123" forState:0];
    rb.titleLabel.font=iFont(15);
    [rb setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    UILabel *title=[[UILabel alloc] initWithFrame:(CGRect){iNavH,iStBH,iScreenW-2*iNavH,iNavH}];
    [nav addSubview:title];
    [title setTextColor:[UIColor whiteColor]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setFont:iBFont(20)];
    self.navtitle=title;
    title.text=self.navtitleStr;
}
-(void)setNavtitleStr:(NSString *)navtitleStr{
    _navtitleStr=navtitleStr;
    self.navtitle.text=self.navtitleStr;
}

-(void)updateLoginState{
    if([YFUserInfo shared].islogin){
        [self.rb setTitle:@"" forState:UIControlStateNormal];
        [self.rb setImage:img(@"nav_user") forState:UIControlStateNormal];
        [self.rb sizeToFit];
        self.rb.frame=(CGRect){iScreenW-iNavH,iStBH,iNavH,iNavH};
    }else{
        [self.rb setImage:0 forState:UIControlStateNormal];
        [self.rb setTitle:@"登录/注册" forState:UIControlStateNormal];
        [self.rb sizeToFit];
        self.rb.frame=(CGRect){iScreenW-self.rb.w-16,iStBH,self.rb.w+16,iNavH};
    }
}


-(void)onLbClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onRbClicked:(UIButton *)sender{
   
}

@end
