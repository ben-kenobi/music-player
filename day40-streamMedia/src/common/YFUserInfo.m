
//
//  YFUserInfo.m
//  day39-project01
//
//  Created by apple on 15/11/27.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFUserInfo.h"
@interface YFUserInfo ()

@end
@implementation YFUserInfo
@synthesize usericon=_usericon;
-(UIImage *)usericon{
    if(!_usericon){
         _usericon= imgFromF([[self getByKey:@"icon"] strByAppendToDocPath]);
        _usericon=_usericon?_usericon:img(@"guide_2");
    }
    return _usericon;
}
-(void)setUsericon:(UIImage *)usericon{
    _usericon=usericon;
    NSString *path=[[self getByKey:@"icon"] strByAppendToDocPath];
    [UIImagePNGRepresentation(usericon) writeToFile:path atomically:YES];
}

-(id)getByKey:(NSString *)key{
    return _dict[key];
}
-(void)set:(id)obj forK:(NSString *)key{
    [_dict setValue:obj forKeyPath:key];
    [iPref(0)setObject:_dict forKey:@"userinfo"];
}
+(instancetype)shared{
    static YFUserInfo *user;
    static long l=0;
    dispatch_once(&l, ^{
        user=[[self alloc] init];
    });
    return user;
}

-(void)login:(NSDictionary *)dict{
    [iPref(0) setObject:dict forKey:@"userinfo"];
    [iPref(0) synchronize];
    self.dict=0;
    [self islogin];
}
-(void)logout{
    _dict=0;
    [iPref(0) removeObjectForKey:@"userinfo"];
    [iPref(0) synchronize];
}

-(BOOL)islogin{
    if(!_dict){
        _dict = [NSMutableDictionary dictionaryWithDictionary:[iPref(0) objectForKey:@"userinfo"]];
    }
    return _dict.allKeys.count;
}




@end
