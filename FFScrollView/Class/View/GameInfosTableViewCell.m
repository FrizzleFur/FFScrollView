//
//  GameInfosTableViewCell.m
//  FFScrollView
//
//  Created by MichaelMao on 2017/11/13.
//  Copyright © 2017年 GlobalScanner. All rights reserved.
//

#import "GameInfosTableViewCell.h"
#import "GameInfos.h"
#import "ExpandTitleButton.h"
#import "PhotoBrowserManager.h"

#define descSubtitleLabel_Font  [UIFont systemFontOfSize:12.0]

static const NSInteger textMaxLines = 4;

@interface GameInfosTableViewCell (){
    UIImageView *avatarView;
    UIImageView *starImgView;

    UILabel *titleLabel;
    UILabel *descTitleLabel;
    UILabel *descSubtitleLabel;
    ExpandTitleButton *textExpendBtn;
    UIView *separatorLine;
}

@property (nonatomic, strong) UIImageView *bannerView;

@end

@implementation GameInfosTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        __weak typeof(self) weakSelf = self;

        avatarView = [[UIImageView alloc] init];
        avatarView.layer.masksToBounds = true;
        avatarView.layer.borderColor = [UIColor whiteColor].CGColor;
        avatarView.layer.borderWidth = ONE_PIXEL;
        [self.contentView addSubview:avatarView];
        
        _bannerView = [[UIImageView alloc] init];
        _bannerView.contentMode = UIViewContentModeScaleAspectFit;
        _bannerView.image = [UIImage imageNamed:@"placeholderImageBanner.jpeg"];
        _bannerView.layer.masksToBounds = true;
        _bannerView.userInteractionEnabled = true;
        [_bannerView setTapActionWithBlock:^{
            [weakSelf clickBannerView:weakSelf.bannerView];
        }];
        [self.contentView addSubview:_bannerView];
        
        starImgView = [[UIImageView alloc] init];
        starImgView.image = [UIImage imageNamed:@"star"];
        [self.contentView addSubview:starImgView];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLabel];
        
        descTitleLabel = [[UILabel alloc] init];
        descTitleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        descTitleLabel.textColor = [UIColor blackColor];
        descTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:descTitleLabel];
        
        descSubtitleLabel = [[UILabel alloc] init];
        descSubtitleLabel.font = descSubtitleLabel_Font;
        descSubtitleLabel.textColor = [UIColor blackColor];
        descSubtitleLabel.textAlignment = NSTextAlignmentLeft;
        descSubtitleLabel.numberOfLines = 0;
        descSubtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:descSubtitleLabel];
        
        textExpendBtn = [[ExpandTitleButton alloc] init];
        textExpendBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        textExpendBtn.backgroundColor = [UIColor whiteColor];
        [textExpendBtn setTitleColor:[UIColor colorWithHex:0x00000] forState:UIControlStateNormal];
        [textExpendBtn addTarget:self action:@selector(clickTextExpendBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:textExpendBtn];

        separatorLine = [[UIView alloc] init];
        separatorLine.backgroundColor = [UIColor colorWithHex:0xE0E0E0];
        [self.contentView addSubview:separatorLine];
        
        textExpendBtn.hidden = starImgView.hidden = true;
    }
    return self;
}

- (void)setGameInfos:(GameInfos *)gameInfos{
    if (_gameInfos != gameInfos) {
        _gameInfos = gameInfos;
        [self updateCell];
    }
}

- (void)updateCell{
    [avatarView setImage:[UIImage imageNamed:self.gameInfos.avatar]];
    [_bannerView setImage:[UIImage imageNamed:self.gameInfos.roleBanner]];
    titleLabel.text = self.gameInfos.name;
    descTitleLabel.text = self.gameInfos.descTitle;
    descSubtitleLabel.text = self.gameInfos.descSubTitle;
    starImgView.hidden =  !self.gameInfos.showStar;

    NSString *textExpendTitle = self.gameInfos.isTextDetailExpand?@"收起":@"查看全文";
    [textExpendBtn setTitle:textExpendTitle forState:UIControlStateNormal];
    [textExpendBtn setTitleColor:[UIColor colorWithHex:0x0076FF] forState:(UIControlStateNormal)];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat topMargin = 10;
    CGFloat leftMargin = 10;
    CGFloat avatarLength = 44;
    CGFloat textExpendBtnWidth = 80;
    CGSize  starSize = starImgView.image.size;
    CGFloat detailMaxHeight = descSubtitleLabel_Font.lineHeight * textMaxLines;
    CGFloat descSubTitleWidth = self.width - 10*3 - 100;
    CGFloat descSubTextContentHeight = [self.gameInfos.descSubTitle boundingRectWithSize:CGSizeMake(descSubTitleWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:descSubtitleLabel.font} context:nil].size.height;

    CGFloat descSubTextHeight = descSubTextContentHeight;
    if (descSubTextContentHeight > detailMaxHeight) {
        descSubTextHeight = (self.gameInfos.isTextDetailExpand ? descSubTextContentHeight : detailMaxHeight);
    }

    avatarView.frame = CGRectMake(leftMargin, topMargin, avatarLength, avatarLength);
    _bannerView.frame = CGRectMake(leftMargin, avatarView.bottom + 10, bannerWidth, bannerHeight);
    titleLabel.frame = CGRectMake(avatarView.right + 15, topMargin, self.width - avatarView.right - 15*2, 20);
    descTitleLabel.frame = CGRectMake(_bannerView.right + 10, _bannerView.top, self.width - _bannerView.right - 10*2, 20);
    descSubtitleLabel.frame = CGRectMake(_bannerView.right + 10, descTitleLabel.bottom + 5, self.width - _bannerView.right - leftMargin*2, descSubTextHeight);
    starImgView.frame = CGRectMake(self.width - starSize.width - leftMargin*1.5, avatarView.top + 5, starSize.width, starSize.height);
    textExpendBtn.frame = CGRectMake(self.width - textExpendBtnWidth - leftMargin, descSubtitleLabel.bottom + 10, textExpendBtnWidth, 20);
    separatorLine.frame = CGRectMake(0, self.height - ONE_PIXEL*2, self.width, ONE_PIXEL*2);
    
    textExpendBtn.hidden = (descSubTextContentHeight <= detailMaxHeight);
    avatarView.layer.cornerRadius = avatarView.height/2;
    titleLabel.centerY = avatarView.centerY;
}

+ (CGFloat)cellHeightWithModel:(GameInfos *)gameInfos cellWidth:(CGFloat)cellWidth {
    if (![gameInfos isKindOfClass:[GameInfos class]]) return 0;
    
    CGFloat textExpendBtnHeight = 20;
    CGFloat descSubTitleWidth = cellWidth - 10*3 - bannerWidth;
    CGFloat avatarHeight = 64;
    CGFloat descTitleHeight = 25;
    CGFloat bottomMargin = 12;
    CGFloat sgLineHeight = ONE_PIXEL*2;

    CGFloat detailMaxHeight = descSubtitleLabel_Font.lineHeight * textMaxLines;
    CGFloat descSubTextContentHeight = [gameInfos.descSubTitle boundingRectWithSize:CGSizeMake(descSubTitleWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:descSubtitleLabel_Font} context:nil].size.height;
    BOOL hideExpandTitle = (descSubTextContentHeight <= detailMaxHeight);
    
    CGFloat descSubTextHeight = descSubTextContentHeight;
    if (descSubTextContentHeight > detailMaxHeight) {
        descSubTextHeight = (gameInfos.isTextDetailExpand ? descSubTextContentHeight : detailMaxHeight);
    }

    CGFloat textContentHeight = descTitleHeight + descSubTextHeight + (hideExpandTitle?0:(textExpendBtnHeight + 12));
    if (descTitleHeight + descSubTextHeight < bannerHeight) {
        textContentHeight = bannerHeight;
    }

    CGFloat cellHeight = avatarHeight + textContentHeight + bottomMargin + sgLineHeight;
    return cellHeight;
}

#pragma mark - Selector

- (void)clickTextExpendBtn{
    if ([self.delegate respondsToSelector:@selector(clickTextExpend:)]) {
        [self.delegate clickTextExpend:_gameInfos];
    }
}

- (void)clickBannerView:(UIImageView *)selectBannerView{
    NSInteger imgIndex = 0;
    NSArray *imageList = @[self.gameInfos.roleBanner];
    NSMutableArray *srcImageViews = [NSMutableArray array];
    for (int i = 0; i < imageList.count; i++) {
        [srcImageViews addObject:selectBannerView];
    }

    [[PhotoBrowserManager sharedManager] showInVc:nil imageList:imageList currentIndex:imgIndex srcImageViews:srcImageViews];
}

@end
