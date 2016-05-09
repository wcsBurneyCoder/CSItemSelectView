//
//  CSItemSelectView.m
//  demo
//
//  Created by wangchengshan on 15/11/23.
//  Copyright © 2015年 wangchengshan. All rights reserved.
//

#import "CSItemSelectView.h"

#define TOPMARGIN 5
#define ANIMATIONDUARATION 0.8
#define CENTERVIEWBORDERWIDTH 1

#define selectColor [UIColor colorWithRed:237/255.0 green:103/255.0 blue:111/255.0 alpha:1]

@interface CSItemSelectView()<UIScrollViewDelegate>
{
    CGFloat _itemWidth;
}
/**内部的scrollView*/
@property (nonatomic,weak) UIScrollView * scrollView;
/**中间的选择框*/
@property (nonatomic,weak) UIView * centerView;
/**按钮的数组*/
@property(nonatomic,strong)NSMutableArray * btnArray;
/**记录被选中的按钮*/
@property (nonatomic,weak) UIButton * selectBtn;

@end

@implementation CSItemSelectView
#pragma mark - lazyLoad
- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

#pragma mark - init
+ (id)itemSelectViewWithData:(NSArray *)dataArray delegate:(id)delegate selectViewWidth:(CGFloat)width defalutIndex:(NSInteger)defalutIndex
{
    CSItemSelectView *view = [[CSItemSelectView alloc]init];
    view.dataArray = dataArray;
    view.delegate = delegate;
    view.selectViewWidth = width;
    view.selectIndex = defalutIndex;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        //default settings
        [self config];
        
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIView *centerView = [[UIView alloc]init];
        [self addSubview:centerView];
        centerView.backgroundColor = [UIColor clearColor];
        centerView.layer.borderColor = _selectViewColor.CGColor;
        centerView.layer.borderWidth = CENTERVIEWBORDERWIDTH;
        self.centerView = centerView;
        
    }
    return self;
}

/**
 *  设置初始值
 */
- (void)config
{
    _selectIndex = 0;
    _selectTitleColor = selectColor;
    _normalTitleColor = [UIColor lightGrayColor];
    _selectViewColor = selectColor;
    _titleFont = [UIFont boldSystemFontOfSize:16.0];
    _selectViewWidth = 0;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGFloat btnH = self.scrollView.bounds.size.height;
    _itemWidth = MAX(_selectViewWidth, (self.bounds.size.height - 2 * TOPMARGIN - 2));
    CGFloat leftMargin = self.bounds.size.width * 0.5 - _itemWidth * 0.5;
    for (int i = 0; i < self.btnArray.count; i ++) {
        UIButton *btn = self.btnArray[i];
        btn.frame = CGRectMake(i * _itemWidth + leftMargin, 0, _itemWidth, btnH);
    }
    UIButton *lastBtn = self.btnArray.lastObject;
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + leftMargin, 0); 
    
    CGFloat viewH = self.bounds.size.height - 2 * TOPMARGIN;
    self.centerView.frame = CGRectMake(leftMargin, TOPMARGIN, _itemWidth, viewH);
    self.centerView.layer.cornerRadius = viewH * 0.5;
    
    NSInteger index = _selectIndex < self.btnArray.count?_selectIndex:(self.btnArray.count - 1);
    UIButton *selectButton = [self.btnArray objectAtIndex:index];
    self.selectBtn.selected = NO;
    selectButton.selected = YES;
    self.selectBtn = selectButton;
    [self.scrollView setContentOffset:CGPointMake(index * _itemWidth, 0)];
}

#pragma mark - setting dataArray
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;

    for (int i = 0; i < dataArray.count; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:dataArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_normalTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:_selectTitleColor forState:UIControlStateSelected];
        btn.titleLabel.font = _titleFont;
        btn.tag = i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        [self.btnArray addObject:btn];
    }
}

- (void)clickItem:(UIButton *)btn
{
    if (btn.tag == self.selectBtn.tag) {
        return;
    }
    
     NSInteger index = [self.btnArray indexOfObject:btn];
    //判断移动方向
    BOOL isRight = btn.tag < self.selectBtn.tag;
    CGFloat moveDistance = isRight?(index * _itemWidth - _itemWidth * 0.2):(index * _itemWidth + _itemWidth * 0.2);
    
    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    
    //执行动画
    [UIView animateKeyframesWithDuration:ANIMATIONDUARATION delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear|UIViewAnimationOptionCurveLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.3 animations:^{
            [self.scrollView setContentOffset:CGPointMake(moveDistance, 0)];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^{
            [self.scrollView setContentOffset:CGPointMake(index * _itemWidth, 0)];
        }];
    } completion:nil];
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(itemSelectView:didSelectItem:atIndex:)]) {
        [self.delegate itemSelectView:self didSelectItem:btn.currentTitle atIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / _itemWidth + 0.5;
    
    if (index >= self.btnArray.count) {
        index = self.btnArray.count -1;
    }
    UIButton *btn = [self.btnArray objectAtIndex:index];

    self.selectBtn.selected = NO;
    btn.selected = YES;
    self.selectBtn = btn;
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat targetX = targetContentOffset->x;
    NSUInteger i = targetX / _itemWidth + 0.5;
    *targetContentOffset = CGPointMake(i * _itemWidth, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / _itemWidth + 0.5;
    
    UIButton *btn = [self.btnArray objectAtIndex:index];
    
    NSString *title = btn.currentTitle;
     //调用代理
    if ([self.delegate respondsToSelector:@selector(itemSelectView:didSelectItem:atIndex:)]) {
        [self.delegate itemSelectView:self didSelectItem:title atIndex:index];
    }
}

#pragma mark - SET METHOD
- (void)setSelectViewColor:(UIColor *)selectViewColor
{
    _selectViewColor = selectViewColor;
    
    self.centerView.layer.borderColor = selectViewColor.CGColor;
}

- (void)setSelectTitleColor:(UIColor *)selectTitleColor
{
    _selectTitleColor = selectTitleColor;
    
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:selectTitleColor forState:UIControlStateSelected];
    }
}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    _normalTitleColor = normalTitleColor;
    
    for (UIButton *btn in self.btnArray) {
        [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectViewWidth:(CGFloat)selectViewWidth
{
    _selectViewWidth = selectViewWidth;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    
    for (UIButton *btn in self.btnArray) {
        btn.titleLabel.font = titleFont;
    }
}

- (void)setSelectIndex:(NSUInteger)selectIndex
{
    if (self.dataArray.count) {
        if (selectIndex >= self.dataArray.count) {
            _selectIndex = self.dataArray.count -1;
        }
        else{
            _selectIndex = selectIndex;
        }
    }
    else{
        _selectIndex = selectIndex;
    }
}
@end
