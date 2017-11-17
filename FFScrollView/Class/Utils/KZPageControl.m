//
//  KZPageControl.m
//  
//
//  Created by kiefer on 13-11-9.
//  Copyright (c) 2013年 kiefer. All rights reserved.
//

#import "KZPageControl.h"

#define DEFAULT_INDICATOR_WIDTH  10.0f
#define DEFAULT_INDICATOR_MARGIN 10.0f

@implementation KZPageControl
{
@private
    NSInteger			_displayedPage;
	CGFloat				_measuredIndicatorWidth;
	CGFloat				_measuredIndicatorHeight;
	NSMutableDictionary	*_pageImages;
	NSMutableDictionary	*_currentPageImages;
}

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
		[self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
	[self initialize];
}

- (void)initialize {
    _numberOfPages = 0;
	_measuredIndicatorWidth = DEFAULT_INDICATOR_WIDTH;
	_measuredIndicatorHeight = DEFAULT_INDICATOR_WIDTH;
	_indicatorDiameter = DEFAULT_INDICATOR_WIDTH;
	_indicatorMargin = DEFAULT_INDICATOR_MARGIN;
	_alignment = PageControlAlignmentCenter;
	_verticalAlignment = PageControlVerticalAlignmentMiddle;
    
	_pageImages = [[NSMutableDictionary alloc] init];
	_currentPageImages = [[NSMutableDictionary alloc] init];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[self _renderPages:context rect:rect];
}

- (void)_renderPages:(CGContextRef)context rect:(CGRect)rect
{
	if (_numberOfPages < 2 && _hidesForSinglePage) {
		return;
	}
	
	CGFloat left = [self _leftOffset];
	CGFloat xOffset = left;
	CGFloat yOffset = [self _topOffset];
	UIColor *fillColor = nil;
	UIImage *image = nil;
    
	for (NSUInteger i = 0; i < _numberOfPages; i++) {
		if (i == _displayedPage) {
			fillColor = _currentPageIndicatorTintColor ? _currentPageIndicatorTintColor : [UIColor whiteColor];
			image = _currentPageImages[@(i)];
			if (image == nil) {
				image = _currentPageIndicatorImage;
			}
		} else {
			fillColor = _pageIndicatorTintColor ? _pageIndicatorTintColor : [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
			image = _pageImages[@(i)];
			if (image == nil) {
				image = _pageIndicatorImage;
			}
		}
		[fillColor set];
        
		if (image) {
            [image drawAtPoint:CGPointMake(xOffset, yOffset)];
		} else {
			CGContextFillEllipseInRect(context, CGRectMake(xOffset, yOffset, _measuredIndicatorWidth, _measuredIndicatorHeight));
		}
        
		xOffset += _measuredIndicatorWidth + _indicatorMargin;
	}
}

- (CGFloat)_leftOffset
{
	CGRect rect = self.bounds;
	CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
	CGFloat left = 0.0f;
	switch (_alignment) {
		case PageControlAlignmentCenter:
			left = CGRectGetMidX(rect) - (size.width / 2.0f);
			break;
		case PageControlAlignmentRight:
			left = CGRectGetMaxX(rect) - size.width;
			break;
		default:
			break;
	}
	
	return left;
}

- (CGFloat)_topOffset
{
	CGRect rect = self.bounds;
	CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
	CGFloat top = 0.0;
	switch (_verticalAlignment) {
		case PageControlVerticalAlignmentMiddle:
			top = CGRectGetMidY(rect) - (_measuredIndicatorHeight / 2.0);
			break;
		case PageControlVerticalAlignmentBottom:
			top = CGRectGetMaxY(rect) - size.height;
			break;
		default:
			break;
	}
    
	return top;
}

- (void)updateCurrentPageDisplay
{
	_displayedPage = _currentPage;
	[self setNeedsDisplay];
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
	CGFloat marginSpace = MAX(0, pageCount - 1) * _indicatorMargin;
	CGFloat indicatorSpace = pageCount * _measuredIndicatorWidth;
	return CGSizeMake(marginSpace + indicatorSpace, _measuredIndicatorHeight);
}

- (CGRect)rectForPageIndicator:(NSInteger)pageIndex
{
	if (pageIndex < 0 || pageIndex >= _numberOfPages) {
		return CGRectZero;
	}
	
	CGFloat left = [self _leftOffset];
	CGSize size = [self sizeForNumberOfPages:pageIndex + 1];
	CGRect rect = CGRectMake(left + size.width - _measuredIndicatorWidth, 0, _measuredIndicatorWidth, _measuredIndicatorWidth);
	return rect;
}

- (void)_setImage:(UIImage *)image forPage:(NSInteger)pageIndex current:(BOOL)current
{
	if (pageIndex < 0 || pageIndex >= _numberOfPages) {
		return;
	}
	
	NSMutableDictionary *dictionary = current ? _currentPageImages : _pageImages;
	dictionary[@(pageIndex)] = image;
}

- (void)setImage:(UIImage *)image forPage:(NSInteger)pageIndex;
{
	[self _setImage:image forPage:pageIndex current:NO];
}

- (void)setCurrentImage:(UIImage *)image forPage:(NSInteger)pageIndex
{
	[self _setImage:image forPage:pageIndex current:YES];
}

- (UIImage *)_imageForPage:(NSInteger)pageIndex current:(BOOL)current
{
	if (pageIndex < 0 || pageIndex >= _numberOfPages) {
		return nil;
	}
	
	NSDictionary *dictionary = current ? _currentPageImages : _pageImages;
	return dictionary[@(pageIndex)];
}

- (UIImage *)imageForPage:(NSInteger)pageIndex
{
	return [self _imageForPage:pageIndex current:NO];
}

- (UIImage *)currentImageForPage:(NSInteger)pageIndex
{
	return [self _imageForPage:pageIndex current:YES];
}

- (void)sizeToFit
{
	CGRect frame = self.frame;
	CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
	size.height = MAX(size.height, 36.0f);
	frame.size = size;
	self.frame = frame;
}

- (void)updatePageNumberForScrollView:(UIScrollView *)scrollView
{
	NSInteger page = (int)floorf(scrollView.contentOffset.x / scrollView.frame.size.width);
	self.currentPage = page;
}

#pragma mark -

- (void)_updateMeasuredIndicatorSizes
{
	_measuredIndicatorWidth = _indicatorDiameter;
	_measuredIndicatorHeight = _indicatorDiameter;
	
	// If we're only using images, ignore the _indicatorDiameter
	if (self.pageIndicatorImage && self.currentPageIndicatorImage) {
		_measuredIndicatorWidth = 0;
		_measuredIndicatorHeight = 0;
	}
	
	if (self.pageIndicatorImage) {
		CGSize imageSize = self.pageIndicatorImage.size;
		_measuredIndicatorWidth = MAX(_indicatorDiameter, imageSize.width);
		_measuredIndicatorHeight = MAX(_indicatorDiameter, imageSize.height);
	}
	
	if (self.currentPageIndicatorImage) {
		CGSize imageSize = self.currentPageIndicatorImage.size;
		_measuredIndicatorWidth = MAX(_indicatorDiameter, imageSize.width);
		_measuredIndicatorHeight = MAX(_indicatorDiameter, imageSize.height);
	}
}


#pragma mark - Tap Gesture

// We're using touchesEnded: because we want to mimick UIPageControl as close as possible
// As of iOS 6, UIPageControl still does not use a tap gesture recognizer. This means that actions like
// touching down, sliding around, and releasing, still results in the page incrementing or decrementing.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	CGSize size = [self sizeForNumberOfPages:self.numberOfPages];
	CGFloat left = [self _leftOffset];
	CGFloat middle = left + (size.width / 2.0f);
    
	if (point.x < middle) {
		[self setCurrentPage:self.currentPage - 1 sendEvent:YES canDefer:YES];
	} else {
		[self setCurrentPage:self.currentPage + 1 sendEvent:YES canDefer:YES];
	}
}

#pragma mark - Accessors

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	[self setNeedsDisplay];
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter
{
	if (indicatorDiameter == _indicatorDiameter) {
		return;
	}
	
	_indicatorDiameter = indicatorDiameter;
	[self _updateMeasuredIndicatorSizes];
	[self setNeedsDisplay];
}

- (void)setIndicatorMargin:(CGFloat)indicatorMargin
{
	if (indicatorMargin == _indicatorMargin) {
		return;
	}
	
	_indicatorMargin = indicatorMargin;
	[self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
	if (numberOfPages == _numberOfPages) {
		return;
	}
	
	_numberOfPages = MAX(0, numberOfPages);
	[self setNeedsDisplay];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
	[self setCurrentPage:currentPage sendEvent:NO canDefer:NO];
}

- (void)setCurrentPage:(NSInteger)currentPage sendEvent:(BOOL)sendEvent canDefer:(BOOL)defer
{
	if (currentPage < 0 || currentPage >= _numberOfPages) {
		return;
	}
	
	_currentPage = currentPage;
	if (NO == self.defersCurrentPageDisplay || NO == defer) {
		_displayedPage = _currentPage;
		[self setNeedsDisplay];
	}
    
	if (sendEvent) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}

- (void)setCurrentPageIndicatorImage:(UIImage *)currentPageIndicatorImage
{
    if (_currentPageIndicatorImage != currentPageIndicatorImage) {
        _currentPageIndicatorImage = currentPageIndicatorImage;
        
        [self _updateMeasuredIndicatorSizes];
        [self setNeedsDisplay];
    }
}

- (void)setPageIndicatorImage:(UIImage *)pageIndicatorImage
{
    if (_pageIndicatorImage != pageIndicatorImage) {
        _pageIndicatorImage = pageIndicatorImage;
        
        [self _updateMeasuredIndicatorSizes];
        [self setNeedsDisplay];
    }
}

@end
