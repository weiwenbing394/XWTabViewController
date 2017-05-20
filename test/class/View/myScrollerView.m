//
//  myScrollerView.m
//  test
//
//  Created by 大家保 on 2017/5/20.
//  Copyright © 2017年 小魏. All rights reserved.
//

#import "myScrollerView.h"

@implementation myScrollerView

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view{
    //NO scroll不可以滚动 YES scroll可以滚动
    return YES;
}

@end
