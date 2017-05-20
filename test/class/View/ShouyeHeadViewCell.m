//
//  ShouyeHeadViewCell.m
//  DaJiaBaoMall
//
//  Created by 大家保 on 2017/3/28.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "ShouyeHeadViewCell.h"
#import "Home_New_CollectionViewCell.h"
#import "SDCycleScrollView.h"
#define SCREEN_WIDTH          [[UIScreen mainScreen]bounds].size.width
#define INTERVAL 5
#define SDHEIGHT SCREEN_WIDTH*243/375.0
#define COLLECTIONVIEWHEIGHT 97
#define SPACE_ITEM 10

@interface ShouyeHeadViewCell ()<SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
//广告栏
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
//功能栏
@property (nonatomic,strong)UICollectionView *myCollectionView;
//分割线
@property (nonatomic,strong)UIView *lineView;
//功能栏数组
@property (nonatomic,strong) NSMutableArray *CollectionArray;
//广告栏数组
@property (nonatomic,strong) NSMutableArray *bannarImageArray;


@end

static NSString  * const Indentifer=@"CollectTion_Cell";

@implementation ShouyeHeadViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)initUI{
    self.backgroundColor=[UIColor clearColor];
    // 网络加载 --- 创建不带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imageURLStringsGroup:nil];
    // 是否无限循环,默认Yes
    self.cycleScrollView.infiniteLoop = YES;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.placeholderImage=[UIImage imageNamed:@"空白图"];
    self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    self.cycleScrollView.autoScrollTimeInterval = INTERVAL;
    self.cycleScrollView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    self.cycleScrollView.pageDotColor=[UIColor colorWithWhite:1 alpha:0.5];
    self.cycleScrollView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SDHEIGHT);
    [self addSubview:self.cycleScrollView];
    
    //添加collectionview
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.myCollectionView.backgroundColor=[UIColor whiteColor];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([Home_New_CollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:Indentifer];
    self.myCollectionView.delegate=self;
    self.myCollectionView.dataSource=self;
    self.myCollectionView.backgroundColor=[UIColor redColor];
    self.myCollectionView.frame=CGRectMake(self.cycleScrollView.frame.origin.x, self.cycleScrollView.frame.size.height, SCREEN_WIDTH, COLLECTIONVIEWHEIGHT);
    [self addSubview:self.myCollectionView];
    
}


- (void)setModel{
    //banner滚动视图
    [self.bannarImageArray removeAllObjects];
    [self.bannarImageArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1495175890&di=39d430b5bced115f7beaa0120d288ed9&src=http://t1.niutuku.com/960/10/10-202370.jpg"];
    [self.bannarImageArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1495175890&di=298a8a922772ad46f7cd74b589ad8c0d&src=http://pic44.huitu.com/res/20151207/851091_20151207021811415200_1.jpg"];
    [self.bannarImageArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1495175890&di=102257c88d7863330f5dc400b5b6be93&src=http://pic29.nipic.com/20130530/9885883_172956607000_2.jpg"];
    self. cycleScrollView.imageURLStringsGroup = self.bannarImageArray;
    
    //collectionview视图
    [self.CollectionArray removeAllObjects];
    [self.CollectionArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1495175890&di=298a8a922772ad46f7cd74b589ad8c0d&src=http://pic44.huitu.com/res/20151207/851091_20151207021811415200_1.jpg"];
    [self.CollectionArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1495175890&di=102257c88d7863330f5dc400b5b6be93&src=http://pic29.nipic.com/20130530/9885883_172956607000_2.jpg"];
    [self.CollectionArray addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1495175890&di=39d430b5bced115f7beaa0120d288ed9&src=http://t1.niutuku.com/960/10/10-202370.jpg"];
    [self.myCollectionView reloadData];
}



#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheBannerIndex:)]) {
        [self.delegate clickCell:self onTheBannerIndex:index];
    }
}

- (void)indexOnPageControl:(NSInteger)index{
    
}


#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.CollectionArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Home_New_CollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:Indentifer forIndexPath:indexPath];
    cell.imageString=self.CollectionArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickCell:onTheCollectionViewIndex:)]) {
        [self.delegate clickCell:self onTheCollectionViewIndex:indexPath.row];
    }
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/self.CollectionArray.count, COLLECTIONVIEWHEIGHT-2*15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
        return 0;
}

#pragma mark 懒加载
- (NSMutableArray *)CollectionArray{
    if (_CollectionArray==nil) {
        _CollectionArray=[NSMutableArray array];
   }
    return _CollectionArray;
}

- (NSMutableArray *)bannarImageArray{
    if (!_bannarImageArray) {
        _bannarImageArray=[NSMutableArray array];
    }
    return _bannarImageArray;
}


@end
