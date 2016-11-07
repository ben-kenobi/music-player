

//
//  YFMusicCell.m
//  day40-streamMedia
//
//  Created by apple on 15/12/1.
//  Copyright (c) 2015年 yf. All rights reserved.
//

#import "YFMusicCell.h"
#import "ZYMusic.h"
#import "YFImgTool.h"
#import "Colours.h"
@implementation YFMusicCell
+(instancetype)cellWithTv:(UITableView *)tv m:(ZYMusic *)m{
    static NSString *const iden=@"musiccelliden";
    YFMusicCell *cell=[tv dequeueReusableCellWithIdentifier:iden];
    if(!cell){
        cell=[[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    cell.music=m;
    return cell;
    
}


-(void)setMusic:(ZYMusic *)music{
    _music=music;
    self.textLabel.text=music.name;
    self.detailTextLabel.text=music.singer;
    if(music.isPlaying){
        self.imageView.image=[YFImgTool circleImage:img(music.singerIcon) borderWidth:2.0 borderColor:[UIColor eggshellColor]];
    }else{
        self.imageView.image=[YFImgTool circleImage:img(music.singerIcon) borderWidth:2.0 borderColor:[UIColor pinkColor]];
    }
}


@end
