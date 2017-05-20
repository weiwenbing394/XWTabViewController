//
//  ViewController.m
//  test
//
//  Created by 大家保 on 2017/5/12.
//  Copyright © 2017年 小魏. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "HJTabViewControllerPlugin_HeaderScroll.h"
#import "HJTabViewControllerPlugin_TabViewBar.h"
#import "HJDefaultTabViewBar.h"
#import "ShouyeHeadViewCell.h"
#define SDHEIGHT             SCREEN_WIDTH*243/375.0
#define COLLECTIONVIEWHEIGHT 97
#define SCREEN_HEIGHT         ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_WIDTH          [[UIScreen mainScreen]bounds].size.width

@interface ViewController ()<HJTabViewControllerDataSource, HJTabViewControllerDelagate, HJDefaultTabViewBarDelegate,ShouyeHeadViewCell_Delegate>

@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.tabDataSource = self;
    
    self.tabDelegate = self;
    
    HJDefaultTabViewBar *tabViewBar = [[HJDefaultTabViewBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HJTabViewBarDefaultHeight)];
    tabViewBar.normalColor=[UIColor darkGrayColor];
    tabViewBar.highlightedColor=[UIColor orangeColor];
    tabViewBar.seperateLineColor=[UIColor lightGrayColor];
    tabViewBar.normarlFont=14;
    tabViewBar.hightFont=16;
    tabViewBar.buttomPadding=15;
    tabViewBar.delegate = self;
    
    HJTabViewControllerPlugin_TabViewBar *tabViewBarPlugin = [[HJTabViewControllerPlugin_TabViewBar alloc] initWithTabViewBar:tabViewBar delegate:nil];
    
    [self enablePlugin:tabViewBarPlugin];
    
    [self enablePlugin:[HJTabViewControllerPlugin_HeaderScroll new]];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"点我刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
}

- (void)refresh{
    _array=[[NSMutableArray alloc]initWithObjects:@"刷新测试1",@"刷新测试2",@"刷新测试3测试",@"刷新测试4",@"刷新测试5测试",@"刷新测试6",@"刷新测试7测试",@"刷新测试8", nil];
    [self reloadData];
}

#pragma mark HJDefaultTabViewBarDelegate

- (NSInteger)numberOfTabForTabViewBar:(HJDefaultTabViewBar *)tabViewBar {
    return [self numberOfViewControllerForTabViewController:self];
}

- (id)tabViewBar:(HJDefaultTabViewBar *)tabViewBar titleForIndex:(NSInteger)index {
    return self.array[index];
}

//点击跨越多个的时候会不会有动画效果
- (void)tabViewBar:(HJDefaultTabViewBar *)tabViewBar didSelectIndex:(NSInteger)index {
    BOOL anim = labs(index - self.curIndex) > 1 ? NO: YES;
    [self scrollToIndex:index animated:anim];
}

#pragma HJTabViewControllerDelagate

//竖直方向移动的百分比
- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {
    self.navigationController.navigationBar.alpha = contentPercentY;
}

#pragma mark HJTabViewControllerDataSource

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.array.count;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    TableViewController *vc = [TableViewController new];
    vc.index = index;
    return vc;
}

//tableview的tableHeadView
- (UIView *)tabHeaderViewForTabViewController:(HJTabViewController *)tabViewController {
    ShouyeHeadViewCell * _headCell=[[ShouyeHeadViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SDHEIGHT+COLLECTIONVIEWHEIGHT+HJTabViewBarDefaultHeight)];
    _headCell.delegate=self;
    [_headCell setModel];
    return _headCell;
}

//tableviewController head的高度
- (CGFloat)tabHeaderBottomInsetForTabViewController:(HJTabViewController *)tabViewController {
    return HJTabViewBarDefaultHeight+CGRectGetMaxY(self.navigationController.navigationBar.frame);;
}


//self距离顶部的高度
- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)clickCell:(ShouyeHeadViewCell *)cell onTheBannerIndex:(NSInteger )index{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"广告%ld",index] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
};

- (void)clickCell:(ShouyeHeadViewCell *)cell onTheCollectionViewIndex:(NSInteger )index{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"功能%ld",index] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
};


- (NSMutableArray *)array{
    if (!_array) {
        _array=[[NSMutableArray alloc]initWithObjects:@"测试1",@"测试2",@"测试3",@"测试4",@"测试5",@"测试6",@"测试7",@"测试8", nil];
    }
    return _array;
}


@end
