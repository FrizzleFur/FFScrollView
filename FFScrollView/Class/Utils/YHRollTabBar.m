//
//  YHRollTabBar.m
//  GlobalScanner
//
//  Created by MichaelMao on 16/8/18.
//  Copyright © 2016年 xiaojian. All rights reserved.
//

#import "YHRollTabBar.h"

#define DefaultFont [UIFont boldSystemFontOfSize:14.0]

@implementation YHRollTabBar
@synthesize titleFont = _titleFont;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, self.sectionLeft, 0, self.sectionRight);
        _flowLayout.minimumInteritemSpacing = self.itemSpacing;
        _flowLayout.minimumLineSpacing = self.itemSpacing;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        
        _selectLine = [[UIView alloc] init];
        _selectLine.backgroundColor = [UIColor colorWithHex:0x010101];
        [_collectionView addSubview:_selectLine];
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithHex:0xE0E0E0];
        [self addSubview:_bottomLine];
    }
    return self;
}

- (void)reloadData {
    [self reloadDataToRow:0];
}

- (void)reloadDataToRow:(NSInteger)row {
    if (![_delegate respondsToSelector:@selector(numberOfRowsInView:)]) {
        return;
    }
    NSInteger rows = [_delegate numberOfRowsInView:self];
    __block CGFloat allLength = 0;
    __block CGFloat length = 0.0;
    
    for (int i = 0; i < rows; i++) {
        NSString *title = [_delegate rollTabBarView:self titleForRow:i];
        CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        allLength += rect.size.width + self.itemSpacing;
        length += rect.size.width;
    }
    if (allLength < self.width && rows > 1) {
        CGFloat aSpacing = (self.width - length) / (rows + 1);
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, aSpacing, 0, aSpacing);
        _flowLayout.minimumInteritemSpacing = aSpacing;
        _flowLayout.minimumLineSpacing = aSpacing;
    }
    [_collectionView reloadData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_collectionView numberOfItemsInSection:0] == 0) return;
        if (row < 0) {
            [self updateCell:nil animated:NO];
            [self updateCell:nil isSelected:YES];
            return;
        }
        [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        
        UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
        [self updateCell:cell animated:NO];
        [self updateCell:cell isSelected:YES];
    });
}

- (void)scrollToRow:(NSInteger)row animated:(BOOL)animated {
    NSArray *cellArr = [_collectionView visibleCells];
    for (UICollectionViewCell *cell in cellArr) {
        [self updateCell:cell isSelected:NO];
    }
    if (row < 0) {
        [self updateCell:nil animated:animated];
        [self updateCell:nil isSelected:YES];
        return;
    }
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0] animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0]];
    [self updateCell:cell animated:animated];
    [self updateCell:cell isSelected:YES];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    _selectLine.frame = CGRectMake(0, _collectionView.height - 15*ONE_PIXEL, 0, 3*ONE_PIXEL);
    _bottomLine.frame = CGRectMake(0, self.height - ONE_PIXEL, self.width, ONE_PIXEL);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [[_delegate rollTabBarView:self titleForRow:indexPath.row] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    return CGSizeMake(rect.size.width, collectionView.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_delegate numberOfRowsInView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:5];
    if (textLabel == nil) {
        textLabel = [[UILabel alloc] init];
        textLabel.font = self.titleFont;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.tag = 5;
        [cell.contentView addSubview:textLabel];
    }
    textLabel.frame = CGRectMake(0, 0, cell.width, cell.height);
    textLabel.text = [_delegate rollTabBarView:self titleForRow:indexPath.row];
    if (cell.selected) {
        [self updateCell:cell isSelected:YES];
        [self updateCell:cell animated:NO];
    } else {
        [self updateCell:cell isSelected:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *cellArr = [collectionView visibleCells];
    for (UICollectionViewCell *cell in cellArr) {
        [self updateCell:cell isSelected:NO];
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [self updateCell:cell animated:YES];
    [self updateCell:cell isSelected:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath];
    }
}

- (void)updateCell:(UICollectionViewCell *)cell isSelected:(BOOL)isSelected {
    UILabel *textLabel = (UILabel*)[cell.contentView viewWithTag:5];
    if (isSelected) {
        textLabel.textColor = [UIColor colorWithHex:0x000000];
    } else {
        textLabel.textColor = [UIColor colorWithHex:0x63666B];
    }
}

- (void)updateCell:(UICollectionViewCell *)cell animated:(BOOL)animated {
    CGFloat x = cell.left - 1;
    CGFloat y = _selectLine.frame.origin.y;
    CGFloat w = cell.width + 2;
    CGFloat h = _selectLine.frame.size.height;
    _selectLine.hidden = (cell == nil);
    if (cell == nil) return;//cell为空时候不刷新分割线frame
    if (animated) {
        if (_selectLine.frame.origin.x != x) {
            [UIView animateWithDuration:0.25 animations:^{
                _selectLine.frame = CGRectMake(x, y, w, h);
            } completion:^(BOOL finished) {
                _selectLine.frame = CGRectMake(x, y, w, h);
            }];
        }
    } else {
        _selectLine.frame = CGRectMake(x, y, w, h);
    }
}

- (CGFloat)itemSpacing {
    return 25.0;
}

- (CGFloat)sectionLeft {
    return 16.0;
}

- (CGFloat)sectionRight {
    return 16.0;
}

- (void)setTitleFont:(UIFont *)titleFont{
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        [self reloadData];
    }
}

- (UIFont *)titleFont{
    UIFont *barTitleFont = _titleFont?(_titleFont):(DefaultFont);
    return barTitleFont;
}

@end
