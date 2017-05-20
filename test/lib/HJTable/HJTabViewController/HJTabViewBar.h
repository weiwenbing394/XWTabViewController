//
//  HJTabViewBar.h
//  HJTabViewControllerDemo
//
//  Created by haijiao on 2017/3/15.
//  Copyright © 2017年 olinone. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat HJTabViewBarDefaultHeight = 50.0f;

@protocol HJTabViewBar

@required

// Subclass must implement -reloadTabBar
- (void)reloadTabBar;

@optional

- (void)tabScrollXPercent:(CGFloat)percent;

- (void)tabScrollXOffset:(CGFloat)contentOffsetX;

- (void)tabDidScrollToIndex:(NSInteger)index;

@end

@interface HJTabViewBar : UIView <HJTabViewBar>

@end
