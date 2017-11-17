//
//  InfosHomeViewController.m
//  FFScrollView
//
//  Created by MichaelMao on 2017/11/11.
//  Copyright © 2017年 GlobalScanner. All rights reserved.
//

#import "InfosHomeViewController.h"
#import "InfosListViewController.h"
#import "YHRollTabBar.h"
#import "HorizSlideView.h"
#import "GameInfos.h"

@import AVFoundation;
static const CGFloat bannerHeight = 211;
@interface InfosHomeViewController () <YHRollTabBarDelegate, HorizSlideViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) YHRollTabBar *tabBar;
@property (nonatomic, strong) HorizSlideView *mSlideView;
@property (nonatomic, strong) UIImageView *bannerPlayView;

@property (nonatomic, strong) NSArray *navigationList;/**< tab类型列表 */
@property (nonatomic, strong) NSArray *navigationTabList;/**< tab类型列表 */
@property (nonatomic, strong) NSArray *sourceDataList;/**< data列表 */
@property (nonatomic, strong) NSArray *bannerList;/**< banner列表 */

@end

@implementation InfosHomeViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View Life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSubScrollDidScroll:) name:kEditChoiceSubScrollDidScroll object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSubScrollDidEndDragging:) name:kEditChoiceSubScrollDidEndDragging object:nil];

    [self setupUI];
    [self createDataSource];
}

- (void)setupUI{

    CGFloat sectionTabHeaderHeight = 45;
    self.title = @"游戏资讯";
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.mScrollView = [[UIScrollView alloc] init];
    self.mScrollView.delegate = self;
    self.mScrollView.frame = CGRectMake(0, self.navigationController.navigationBar.bottom, self.view.width, self.view.height - self.navigationController.navigationBar.bottom);
    self.mScrollView.backgroundColor = [UIColor clearColor];
    self.mScrollView.showsVerticalScrollIndicator = true;
    [self.view addSubview:self.mScrollView];
    
    self.bannerPlayView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bannerPlayView.frame = CGRectMake(0, 0, self.mScrollView.width, bannerHeight);
    [self.mScrollView addSubview: self.bannerPlayView];
    
    self.tabBar = [[YHRollTabBar alloc] init];
    self.tabBar.delegate = self;
    self.tabBar.frame = CGRectMake(0, self.bannerPlayView.bottom, self.mScrollView.width, sectionTabHeaderHeight);
    self.tabBar.backgroundColor = [UIColor whiteColor];
    [self.mScrollView addSubview:self.tabBar];
    
    self.mSlideView = [[HorizSlideView alloc] init];
    self.mSlideView.delegate = self;
    self.mSlideView.frame = CGRectMake(0, self.tabBar.bottom, self.mScrollView.width, self.mScrollView.height - self.tabBar.height);
    self.mSlideView.backgroundColor = [UIColor clearColor];
    [self.mScrollView addSubview:self.mSlideView];
}


- (void)createChildVc{
    [self removeViewControllers];
    for (NSArray *souceList in self.sourceDataList) {
        InfosListViewController *childVc = [[InfosListViewController alloc] initWithInfoList:souceList RootVC:self];
        [self addChildViewController:childVc];
    }
}

- (void)removeViewControllers {
    if (self.childViewControllers.count == 0) return;
    for (UIViewController *viewController in self.childViewControllers) {
        [viewController.view removeFromSuperview];
        [viewController removeFromParentViewController];
    }
}

#pragma mark - Data Source

- (void)createDataSource{
    //banner列表
    self.bannerList = @[@"placeholderImageBanner.jpeg", @"placeholderImageBanner.jpeg", @"placeholderImageBanner.jpeg", @"placeholderImageBanner.jpeg"];
    //tab列表
    NSArray *tabsArray= @[@"LOL英雄联盟", @"大逃杀", @"炉石传说"];
    self.navigationList = [NSArray arrayWithArray:tabsArray];
    //Infolist
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dataSource" ofType:@"archiver"];
    NSData *sourceData = (NSData *)[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSDictionary *sourceDict =[NSJSONSerialization JSONObjectWithData:sourceData options:kNilOptions error:nil];
    NSArray *lolArr = [sourceDict objectForKey:@"lolArr"];
    NSArray *chijiArr = [sourceDict objectForKey:@"chijiArr"];
    NSArray *lushiArr = [sourceDict objectForKey:@"lushiArr"];
    NSArray *dictListArr = @[lolArr, chijiArr, lushiArr];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSArray *dictArr in dictListArr) {
        NSArray *modelArr = [self modelArr:dictArr];
        [tempArr addObject:modelArr];
    }
    self.sourceDataList = [NSArray arrayWithArray:tempArr];
    self.mScrollView.contentSize = CGSizeMake(self.mSlideView.width, self.mScrollView.height + bannerHeight);

    //刷新页面
    if (self.navigationList.count > 0) {
        [self createChildVc];
        [self.tabBar reloadDataToRow:0];
        [self.mSlideView reloadData];
        self.mSlideView.selectedIndex = 0;
    }
    [self performSelector:@selector(playVideoLayer) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
}

- (NSArray *)modelArr:(NSArray*)dictArr{
    NSInteger totalCount = dictArr.count;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i < totalCount; i++) {
        NSDictionary *dict = [dictArr objectAtIndex:i];
        GameInfos *infos = [[GameInfos alloc] initWithDictionary:(dict)];
        [tempArr addObject:infos];
    }
    return tempArr;
}

- (void)reloadData{
    [self createDataSource];
}

- (void)playVideoLayer{
    if (!self.bannerPlayView) return;
    
    //get video URL
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Starcraft2_HeartOfTheSwarmCG" withExtension:@"mp4"];
    
    AVPlayer *player = [AVPlayer playerWithURL:URL];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.bannerPlayView.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.bannerPlayView.layer addSublayer:playerLayer];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [player play];
    });

}

#pragma mark - NSNotification

- (void)handleSubScrollDidScroll:(NSNotification *)notification{
    UIScrollView *subScroll = notification.userInfo[kEditChoiceSubScrollView];
    if (![subScroll isKindOfClass:[UIScrollView class]]) return;
    BOOL mainScrollEnable = (self.mScrollView.contentOffset.y < self.tabBar.top);
    CGFloat offsetY = subScroll.contentOffset.y + self.mScrollView.contentOffset.y;
    if (mainScrollEnable) {
        [self.mScrollView setContentOffset:CGPointMake(0, offsetY)];
        [subScroll setContentOffset:CGPointZero];
    } else if (subScroll.contentOffset.y <= 0 && !mainScrollEnable) {
        if (self.mScrollView.contentOffset.y >= self.tabBar.top) {
            [self.mScrollView setContentOffset:CGPointMake(0, offsetY)];
        }
    }
    subScroll.showsVerticalScrollIndicator = !mainScrollEnable;
}

- (void)handleSubScrollDidEndDragging:(NSNotification *)notification{
    
    UIScrollView *subScroll = notification.userInfo[kEditChoiceSubScrollView];
    if (![subScroll isKindOfClass:[UIScrollView class]]) return;
    
    CGFloat offsetY = self.mScrollView.contentOffset.y;
    if (offsetY < 0) {
        [self.mScrollView setContentOffset:CGPointZero
                                  animated:YES];
    }
}

#pragma mark - YHRollTabBarDelegate

- (NSInteger)numberOfRowsInView:(YHRollTabBar *)rollTabBar {
    return [self.navigationList count];
}

- (NSString *)rollTabBarView:(YHRollTabBar *)rollTabBarView titleForRow:(NSInteger)row {
    NSString *tabName = self.navigationList[row];
    return tabName;
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.mSlideView.selectedIndex = indexPath.row;
}


#pragma mark - HorizSlideViewDelegate
// 顶部tab个数
- (NSUInteger)numberOfTabsInSlideView:(HorizSlideView *)slideView {
    return self.childViewControllers.count;
}

// 每个tab所属的viewController
- (UIViewController *)slideView:(HorizSlideView *)slideView viewForTabIndex:(NSUInteger)tabIndex {
    if (tabIndex < self.childViewControllers.count) {
        return self.childViewControllers[tabIndex];
    }
    return nil;
}

// 点击tab
- (void)slideView:(HorizSlideView *)slideView didSelectTab:(NSUInteger)tabIndex {
    if (tabIndex < self.childViewControllers.count) {
        [self.tabBar scrollToRow:tabIndex animated:true];
        [self.mSlideView addChildViewWithIndex:tabIndex];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = self.mScrollView.contentOffset.y;
    BOOL mainScrollEnable = (offsetY < self.tabBar.top);
    self.mScrollView.scrollEnabled = mainScrollEnable;
    if( !mainScrollEnable){
        [self.mScrollView setContentOffset:CGPointMake(0, self.tabBar.top) animated:false];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
