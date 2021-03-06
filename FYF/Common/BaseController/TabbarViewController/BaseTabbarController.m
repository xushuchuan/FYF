//
//  BaseTabbarController.m
//  barrister
//
//  Created by 徐书传 on 16/3/21.
//  Copyright © 2016年 Xu. All rights reserved.
//

#import "BaseTabbarController.h"
#import "HomePageViewController.h"

#import "PersonCenterViewController.h"
#import "BaseNavigaitonController.h"


#define     ImageWidth        25


#define ItemWidth SCREENWIDTH/4.0

@interface BaseTabbarController ()


@property (nonatomic,strong) NSMutableArray * tabBarImageNames;
@property (nonatomic,strong) NSMutableArray * tabBarSelectedImageNames;
@property (nonatomic,strong) NSMutableArray * tabBarTitleNames;

- (void)loadViewControllers;
- (void)loadCustomTabBarView;

@end

@implementation BaseTabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏系统TabBar
        self.tabBar.hidden = YES;
        self.newsMsgLabelArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //加载视图控制器
    [self loadViewControllers];
    
    //加载自定义TabBar
    [self loadCustomTabBarView];
}

#pragma mark-
#pragma mark-加载
- (void)loadViewControllers
{
    self.titleArray = [NSMutableArray arrayWithObjects:@"首页",@"个人中心", nil];
    
    
    self.btnArray = [NSMutableArray arrayWithCapacity:10];
    
    
    HomePageViewController *c1 = [[HomePageViewController alloc] init];
    c1.title = [self.titleArray objectAtIndex:0];
    BaseNavigaitonController *ctl1 = [[BaseNavigaitonController alloc] initWithRootViewController:c1];
    
    
    
    PersonCenterViewController *c2 = [[PersonCenterViewController alloc] init];
    c2.title = [self.titleArray objectAtIndex:1];
    BaseNavigaitonController *ctl2 = [[BaseNavigaitonController alloc] initWithRootViewController:c2];
    
    
    // 将视图控制器添加至数组中
    NSArray *viewControllers = @[ctl1,ctl2];
    
    [self setViewControllers:viewControllers animated:YES];
    
}

- (void)loadCustomTabBarView
{
    [self initDatas];
    
    // 初始化自定义TabBar背景
    
    _tabBarBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-TABBAR_HEIGHT, SCREENWIDTH, TABBAR_HEIGHT)];
    _tabBarBG.userInteractionEnabled = YES; //关键
    _tabBarBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabBarBG];
    
    for (int i = 0; i < 2; i++) {
        NSString *imageName = [self.tabBarImageNames objectAtIndex:i];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((ItemWidth - ImageWidth)/2, 5, ImageWidth, ImageWidth)];
        imageView.tag = 900;
        imageView.image = [UIImage imageNamed:imageName];
        
        UIButton * tabbarItem = [UIButton buttonWithType:UIButtonTypeCustom];
        tabbarItem.backgroundColor = [UIColor clearColor];
        [self.btnArray addObject:tabbarItem];
        tabbarItem.titleLabel.font = SystemFont(12.0f);
        tabbarItem.titleLabel.textAlignment = NSTextAlignmentCenter;
        tabbarItem.frame = CGRectMake(i*ItemWidth, 0, ItemWidth, TABBAR_HEIGHT);
        tabbarItem.tag = i;
        [tabbarItem addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarItem addSubview:imageView];
        [_tabBarBG addSubview:tabbarItem];
        
        UILabel *labelT = [[UILabel alloc] initWithFrame:CGRectMake(0, TABBAR_HEIGHT - 15, ItemWidth, 12)];
        labelT.font = SystemFont(12.0f);
        labelT.textAlignment = NSTextAlignmentCenter;
        labelT.textColor = RGBCOLOR(119, 119, 119 );
        labelT.backgroundColor = [UIColor clearColor];
        labelT.text = [self.titleArray objectAtIndex:i];
        [tabbarItem addSubview:labelT];
        
        
        //默认第一个
        if (i == self.selectedIndex) {
            [self changeViewController:tabbarItem];
        }
    }

}

#pragma mark-
#pragma mark-显示/隐藏
- (void)showTabBar
{
    self.tabBar.hidden = YES;//这里一定要有，否则不兼容ios7
    [UIView beginAnimations:nil context:NULL];
    if (IS_IOS7) {
        [UIView setAnimationDuration:0.05];
    }
    else
        [UIView setAnimationDuration:0.34];
    
    _tabBarBG.frame = CGRectMake(0, SCREENHEIGHT-TABBAR_HEIGHT, SCREENWIDTH, TABBAR_HEIGHT);
    [UIView commitAnimations];
}

- (void)hiddenTabBar
{
    [UIView beginAnimations:nil context:NULL];
    if (IS_IOS7) {
        [UIView setAnimationDuration:0.05];
    }
    else
        [UIView setAnimationDuration:0.36];
    
    _tabBarBG.frame = CGRectMake(-SCREENWIDTH, SCREENHEIGHT-TABBAR_HEIGHT, SCREENWIDTH, TABBAR_HEIGHT);
    [UIView commitAnimations];
}

#pragma mark-
#pragma mark-初始化数据
- (void)initDatas{
    
    self.tabBarImageNames = [[NSMutableArray alloc]initWithObjects:
                              @"Tab01Normal.png",
                              @"Tab02Normal.png",
                              @"Tab03Normal.png",
                              @"Tab04Normal.png",

                              nil];
    
    self.tabBarSelectedImageNames = [[NSMutableArray alloc]initWithObjects:
                                      @"Tab01Highlighted.png",
                                      @"Tab02Highlighted.png",
                                      @"Tab03Highlighted.png",
                                      @"Tab04Highlighted.png",
                                      nil];
    
}

#pragma mark-
#pragma mark-其他
- (void)changeViewController:(UIButton *)button
{
    
    UIButton *lastbtn = (UIButton *)[self.btnArray objectAtIndex:self.selectedIndex];
    for (UIImageView *imageView in lastbtn.subviews) {
        if (imageView.tag == 900) {
            NSString *lastImageName = [self.tabBarImageNames objectAtIndex:self.selectedIndex];
            [imageView setImage:[UIImage imageNamed:lastImageName]];
        }
    }
    
    for (UIButton *btn in self.btnArray) {
        if (btn == button) {
            [btn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
            for (UIImageView *imageView in btn.subviews) {
                if (imageView.tag == 900) {
                    NSString *seleteImage = [self.tabBarSelectedImageNames objectAtIndex:button.tag];
                    [imageView setImage:[UIImage imageNamed:seleteImage]];
                }
            }
        }
        else
        {
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    
    //转到相应的视图
    self.selectedIndex = button.tag;

}

#pragma mark- 设置tabbar 角标



-(void)setNewMsgTipWithIndex:(int)index
{
    if (index == 1) {
        return;
    }
    UILabel *labelTemp = [self.newsMsgLabelArray objectAtIndex:index];
    [_tabBarBG addSubview:labelTemp];
    labelTemp.hidden = NO;
    
}

-(void)hideNewMsgTipWithIndex:(int)index
{
    UILabel *labelTemp = [self.newsMsgLabelArray objectAtIndex:index];
    labelTemp.hidden = YES;
    [labelTemp removeFromSuperview];
    
}


@end
