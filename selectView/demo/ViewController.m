//
//  ViewController.m
//  demo
//
//  Created by wangchengshan on 15/11/23.
//  Copyright © 2015年 wangchengshan. All rights reserved.
//

#import "ViewController.h"
#import "CSItemSelectView.h"

@interface ViewController ()<CSItemSelectViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    CSItemSelectView *selectView = [CSItemSelectView itemSelectViewWithData:[self data] delegate:self selectViewWidth:60 defalutIndex:5];
    selectView.frame = CGRectMake(10, 100, self.view.bounds.size.width - 20, 40);
    selectView.selectTitleColor = [UIColor greenColor];
    selectView.selectViewColor = [UIColor cyanColor];
    selectView.normalTitleColor = [UIColor blueColor];
    selectView.titleFont = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:selectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - delegate
- (void)itemSelectView:(CSItemSelectView *)itemView didSelectItem:(NSString *)item atIndex:(NSInteger)index
{
    NSLog(@"item---%@,index --- %zd",item,index);
}

//fake data
- (NSArray *)data
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 20; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d",i + 1];
        [array addObject:str];
    }
    return [array copy];
}
@end
