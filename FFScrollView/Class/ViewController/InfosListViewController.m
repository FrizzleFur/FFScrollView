//
//  InfosListViewController.m
//  FFScrollView
//
//  Created by MichaelMao on 2017/11/11.
//  Copyright © 2017年 GlobalScanner. All rights reserved.
//

#import "InfosListViewController.h"
#import "GameInfosTableViewCell.h"
#import "PhotoBrowserManager.h"
#import "GameInfos.h"

@interface InfosListViewController () <UITableViewDelegate, UITableViewDataSource, GameInfosTableViewCellDelegate>

@property (nonatomic, strong) NSArray *infosList;/**< 测试列表 */
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIViewController *rootVC;

@end

@implementation InfosListViewController

- (instancetype)initWithInfoList:(NSArray *)infosList RootVC:(UIViewController *)rootVC {
    self = [super init];
    if (self) {
        self.infosList = infosList;
        self.rootVC = rootVC;
    }
    return self;
}

//更新ChildVC的frame
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.tableView reloadData];
}

- (NSArray *)infosList{
    if (!_infosList) {
        _infosList = [NSArray array];
    }
    return _infosList;
}

- (void)setupUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = self.view.bounds;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[GameInfosTableViewCell class] forCellReuseIdentifier:NSStringFromClass([GameInfosTableViewCell class])];
    [self.view addSubview:_tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infosList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GameInfos *roles = [self.infosList objectAtIndex:indexPath.row];
    GameInfosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GameInfosTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.gameInfos = roles;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    GameInfos *role = [self.infosList objectAtIndex:indexPath.row];
    CGFloat cellHeight = [GameInfosTableViewCell cellHeightWithModel:role cellWidth:tableView.width];
    return cellHeight;
}


#pragma mark - DynamicComplexCellDelegate

//文案展开
- (void)clickTextExpend:(GameInfos *)selectGameInfos{
    if (!selectGameInfos) return;
    NSInteger row = [self.infosList indexOfObject:selectGameInfos];
    selectGameInfos.isTextDetailExpand = !selectGameInfos.isTextDetailExpand;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEditChoiceSubScrollDidScroll object:nil userInfo:@{kEditChoiceSubScrollView : scrollView}];//到顶通知父视图改变状态
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //处理因子视图向下拖拽而导致父视图无法回到原位置
    [[NSNotificationCenter defaultCenter] postNotificationName:kEditChoiceSubScrollDidEndDragging object:nil userInfo:@{kEditChoiceSubScrollView : scrollView}];//到顶通知父视图改变状态
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
