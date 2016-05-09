//
//  CSItemSelectView.h
//  demo
//
//  Created by wangchengshan on 15/11/23.
//  Copyright © 2015年 wangchengshan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSItemSelectView;

@protocol CSItemSelectViewDelegate <NSObject>

- (void)itemSelectView:(CSItemSelectView *)itemView didSelectItem:(NSString *)item atIndex:(NSInteger)index;

@end

@interface CSItemSelectView : UIView
/**
 *  数据数组
 */
@property(nonatomic, strong) NSArray * dataArray;
/**
 *  代理
 */
@property (nonatomic, weak) id<CSItemSelectViewDelegate> delegate;
/**
 *  选择框的颜色 默认[UIColor colorWithRed:237/255.0 green:103/255.0 blue:111/255.0 alpha:1]
 */
@property (nonatomic, strong) UIColor *selectViewColor;
/**
 *  选择框的宽度
 */
@property (nonatomic, assign) CGFloat selectViewWidth;
/**
 *  被选择的字体颜色 默认[UIColor colorWithRed:237/255.0 green:103/255.0 blue:111/255.0 alpha:1]
 */
@property (nonatomic, strong) UIColor *selectTitleColor;
/**
 *  未被选中的字体颜色 默认[UIColor lightGrayColor];
 */
@property (nonatomic, strong) UIColor *normalTitleColor;
/**
 *  字体大小 默认[UIFont boldSystemFontOfSize:16.0]
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  当前选择的索引 默认0
 */
@property (nonatomic, assign) NSUInteger selectIndex;

/**
 *  初始化类方法
 *
 *  @param dataArray    数据源墅组
 *  @param delegate     代理对象
 *  @param width        选择框的宽度
 *  @param defalutIndex 初始的索引
 */
+ itemSelectViewWithData:(NSArray *)dataArray delegate:(id)delegate selectViewWidth:(CGFloat)width defalutIndex:(NSInteger)defalutIndex;

@end
