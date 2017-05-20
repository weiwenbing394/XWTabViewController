//
//  HJDefaultTabViewBar.m
//  HJTabViewControllerDemo
//
//  Created by haijiao on 2017/3/16.
//  Copyright © 2017年 olinone. All rights reserved.
//

#import "HJDefaultTabViewBar.h"
#import "UIView+Extension.h"
#import "myScrollerView.h"

@interface HJDefaultTabViewBar () {
    UIView       *_indicatorView;
    UIView       *_seperatorView;
    NSInteger    _curIndex;
    myScrollerView *_titleScrollerView;
}

@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, strong) NSMutableDictionary *widths;

@end

@implementation HJDefaultTabViewBar

//初始化相关设置
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        
        //背景颜色
        self.backgroundColor = [UIColor whiteColor];
        self.widths = [NSMutableDictionary dictionary];
        
        //初始化设置
        self.normalColor = [UIColor blackColor];
        self.highlightedColor = [UIColor redColor];
        self.seperateLineColor= [UIColor colorWithWhite:0 alpha:0.3];
        self.normarlFont=14;
        self.hightFont=14;
        self.buttomPadding=15;
        
        //滚动的视图
        _titleScrollerView=[[myScrollerView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _titleScrollerView.backgroundColor=[UIColor clearColor];
        [_titleScrollerView setShowsVerticalScrollIndicator:NO];
        [_titleScrollerView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_titleScrollerView];
        
        //指示器
        _indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _indicatorView.backgroundColor = self.highlightedColor;
        _indicatorView.layer.cornerRadius = 1;
        _indicatorView.layer.masksToBounds = YES;
        [_titleScrollerView addSubview:_indicatorView];
        
        //分割线
        _seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5)];
        _seperatorView.backgroundColor = self.seperateLineColor;
        _seperatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_seperatorView];
        
        return self;
    }
    return nil;
}

//默认颜色
- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor=normalColor;
     [self reloadTabBar];
}

//选中颜色
- (void)setHighlightedColor:(UIColor *)highlightedColor{
    _highlightedColor=highlightedColor;
    _indicatorView.backgroundColor = self.highlightedColor;
     [self reloadTabBar];
}

//分割线颜色
- (void)setSeperateLineColor:(UIColor *)seperateLineColor{
    _seperateLineColor=seperateLineColor;
    _seperatorView.backgroundColor=seperateLineColor;
     [self reloadTabBar];
}

//普通字体大小
- (void)setNormarlFont:(CGFloat)normarlFont{
    _normarlFont=normarlFont;
     [self reloadTabBar];
}

//选中字体大小
- (void)setHightFont:(CGFloat)hightFont{
    _hightFont=hightFont;
     [self reloadTabBar];
}

//按钮间距
- (void)setButtomPadding:(CGFloat)buttomPadding{
    _buttomPadding=buttomPadding;
    [self reloadTabBar];
}

#pragma mark -初始化按钮
- (void)reloadTabBar {
    
    [self.buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn removeFromSuperview];
    }];
    
    _curIndex=0;
    
    //标题总数
    NSInteger count = [self.delegate numberOfTabForTabViewBar:self];
    
    //按钮总数
    NSMutableArray *newBtns = [NSMutableArray arrayWithCapacity:count];
    
    //计算位置
    CGFloat locationX=0;
    
    for (u_int8_t index = 0; index < count; index++) {
        
        UIButton *btn = [self createButton];
        
        btn.tag = index;
        
        //计算标题的宽度
        id title = [self.delegate tabViewBar:self titleForIndex:index];
        
        CGFloat cellWidth = [self boundingRectWithSize:title Font: btn.titleLabel.font Size:CGSizeMake(280, 44)].width;
        
        [btn setTitle:title forState:UIControlStateNormal];
        
        //按钮的位置
        btn.frame = CGRectMake(locationX, 0, cellWidth+2*_buttomPadding, CGRectGetHeight(self.bounds));
        
        //指示器的位置
        _indicatorView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 2, cellWidth, 2);
        
        _indicatorView.centerX=btn.centerX;
        
        [_titleScrollerView addSubview:btn];
        
        [newBtns addObject:btn];
        
        locationX+=cellWidth+2*_buttomPadding;
    
    }
    
    _titleScrollerView.contentSize=CGSizeMake(locationX, CGRectGetHeight(self.bounds));
    
    //全部的按钮
    self.buttons = newBtns;
    
    if (self.buttons.count == 0) {
        
        return;
        
    }
    
    [self tabDidScrollToIndex:_curIndex];
}

#pragma mark - 当前选中按钮
- (void)tabDidScrollToIndex:(NSInteger)index {
    [self scrollToRow:index];
}


//创建按钮
- (UIButton *)createButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:_normarlFont];
    [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
    [btn setTitleColor:self.highlightedColor forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

//按钮点击事件
- (IBAction)onBtnClick:(UIButton *)sender {
    if (sender.tag==_curIndex) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(tabViewBar:didSelectIndex:)]) {
        [self.delegate tabViewBar:self didSelectIndex:sender.tag];
    }
}

//根据下表获取按钮
- (UIButton *)buttonAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.buttons.count) {
        return nil;
    }
    return self.buttons[index];
}


//计算文本标题的宽度
-(CGSize) boundingRectWithSize:(NSString*) txt Font:(UIFont*) font Size:(CGSize) size{
    
    CGSize _size;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    
    NSStringDrawingUsesLineFragmentOrigin |
    
    NSStringDrawingUsesFontLeading;
    
    _size = [txt boundingRectWithSize:size options: options attributes:attribute context:nil].size;
    
#else
    
    _size = [txt sizeWithFont:font constrainedToSize:size];
    
#endif
    
    return _size;
    
}

//更换位置
- (void)scrollToRow:(NSInteger)row{
    UIButton *selectedButtom=[self buttonAtIndex:row];
    if (selectedButtom) {
        [self.buttons enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            btn.enabled = YES;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:_normarlFont];
        }];
        _curIndex = selectedButtom.tag;
        UIButton *curBtn = [self buttonAtIndex:_curIndex];
        curBtn.enabled = NO;
        curBtn.titleLabel.font = [UIFont boldSystemFontOfSize:_hightFont];
        
        CGFloat x =  selectedButtom.frame.origin.x;
        CGFloat width = self.bounds.size.width;
        CGFloat contentWidth = _titleScrollerView.contentSize.width;
        if (x + selectedButtom.frame.size.width/2.0 < width/2.0) {
            [_titleScrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else if (contentWidth < x + selectedButtom.frame.size.width/2.0 + width/2.0){
            [_titleScrollerView setContentOffset:CGPointMake((contentWidth - width), 0) animated:YES];
        }else{
            CGFloat offset = x + selectedButtom.frame.size.width/2.0 - width/2.0 ;
            [_titleScrollerView setContentOffset:CGPointMake(offset, 0) animated:YES];
        }
    }
    _indicatorView.width=selectedButtom.width-2*_buttomPadding;
    _indicatorView.centerX=selectedButtom.centerX;
}


@end
