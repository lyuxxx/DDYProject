//
//  BtnTestVC.m
//  DDYProject
//
//  Created by LingTuan on 17/7/21.
//  Copyright © 2017年 Starain. All rights reserved.
//

#import "BtnTestVC.h"
#import "DDYButton.h"
#import "DDYButton+LinkLock.h"

#define  kDegreesToRadians(degrees)  ((3.14159265359 * degrees)/ 180)

@interface BtnTestVC ()

@end

@implementation BtnTestVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepare];
    [self setupButton];
}

- (void)prepare
{
    // 64当起点布局
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = DDYColor(245, 245, 245, 1);
}

- (void)setupButton
{
    // 链式编程 继承方式
    [DDYButton customDDYBtn].btnFrame(10, 10, 60, 80)
                            .btnFont(DDYFont(12))
                            .btnTitleN(@"上图下文")
                            .btnTitleColorN([UIColor blueColor])
                            .btnImageN([UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(20, 20)])
                            .btnLayoutStyle(DDYBtnStyleImgTop)
                            .btnPadding(5)
                            .btnSuperView(self.view);
    
    // 原生编程 继承方式
    DDYButton *button = [DDYButton customDDYBtn];
    button.frame = CGRectMake(80, 10, 60, 80);
    button.titleLabel.font = DDYFont(12);
    [button setTitle:@"下图上文" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    button.btnStyle = DDYBtnStyleImgDown;
    button.padding = 5;
    [self.view addSubview:button];
    
    // 原生编程 分类方式
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(150, 10, 85, 80);
    btn.titleLabel.font = DDYFont(12);
    [btn setTitle:@"左文右图" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [btn DDYStyle:DDYStyleImgRight padding:5];
    [self.view addSubview:btn];
}

@end
