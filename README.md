# CSItemSelectView
## <a id="如何使用CSItemSelectView"></a>如何使用CSItemSelectView
### 手动导入：
* 将`selectView`文件夹中的所有文件拽入项目中
* 导入主头文件：`#import "CSItemSelectView.h"`

### 效果图
![](https://github.com/wcsBurneyCoder/CSItemSelectView/screenShot/test.gif)

### 用法
在需要用到`CSItemSelectView`的地方添加如下代码
```objc
CSItemSelectView *selectView = [CSItemSelectView itemSelectViewWithData:[self data] delegate:self selectViewWidth:60 defalutIndex:5];
       		 selectView.frame = CGRectMake(10, 100, self.view.bounds.size.width - 20, 40);
selectView.selectTitleColor = [UIColor greenColor];
selectView.selectViewColor = [UIColor cyanColor];
selectView.normalTitleColor = [UIColor blueColor];
selectView.titleFont = [UIFont systemFontOfSize:18.0];
[self.view addSubview:selectView];
```
###代理方法
```objc
-(void)itemSelectView:(CSItemSelectView *)itemView didSelectItem:(NSString *)item atIndex:(NSInteger)index{
    NSLog(@"item---%@,index --- %zd",item,index);
}
```
### 自定义内容
```objc
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
```