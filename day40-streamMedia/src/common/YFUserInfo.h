//
//  YFUserInfo.h
//  day39-project01
//
//  Created by apple on 15/11/27.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFUserInfo : NSObject
@property (nonatomic,strong)NSMutableDictionary *dict;
-(id)getByKey:(NSString *)key;
-(void)set:(id)obj forK:(NSString *)key;
+(instancetype)shared;
-(BOOL)islogin;
-(void)login:(NSDictionary *)dict;
-(void)logout;

@property (nonatomic,strong)UIImage *usericon;
@end
