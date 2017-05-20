//
//  Home_New_CollectionViewCell.m
//  BaobiaoDog
//
//  Created by 大家保 on 2016/10/26.
//  Copyright © 2016年 大家保. All rights reserved.
//

#import "Home_New_CollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation Home_New_CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setImageString:(NSString *)imageString{
    _imageString=imageString;
    [self.ContentImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"空白图"]];
}

@end
