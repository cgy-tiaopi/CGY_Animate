//
//  ViewController.m
//  CGY_Animate
//
//  Created by 陈刚宇 on 17/2/7.
//  Copyright © 2017年 CGY. All rights reserved.
//

#define MAS_SHORTHAND
#import "ViewController.h"
#import "Masonry.h"
#import "AnimateView.h"
#import <math.h>

@interface ViewController () <AnimationEndDelegate>
{
    UIButton        *btnStart;                  //发布按钮
    BOOL            isRoate;                    //展开动画或收回动画的判断条件
    CGPoint         startPoint;                 //动画开始的Point
    AnimateView     *animateView;               //动画发生的视图
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    if (btnStart == nil)
    {
        btnStart = [[UIButton alloc] init];
        [btnStart setBackgroundImage:[UIImage imageNamed:@"post_normal"] forState:UIControlStateNormal];
        
        [btnStart addTarget:self action:@selector(onClickButtonStart) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:btnStart];
    
    [btnStart makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(100);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
}

#pragma mark - click event
-(void)onClickButtonStart
{
    float angel = !isRoate?-M_PI_4:0.0f;
    
    if(!animateView){
        animateView = [[AnimateView alloc] init];
        animateView.delegate = self;
    }
    
    if (!isRoate) {
        [btnStart removeFromSuperview];                 //从父视图上移除btnStart
        [self.view addSubview:animateView];             //把btnStart添加到动画视图上
        [animateView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [animateView addSubview:btnStart];
        
        [btnStart updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(animateView.centerX);
            make.centerY.equalTo(animateView.centerY).offset(100);
            make.height.equalTo(@60);
            make.width.equalTo(@60);
        }];
        [self sharkButton];                     //btnStart弹性动画
        isRoate = !isRoate;
    }
    else
    {
        [UIView animateWithDuration:0.2f animations:^(){
            btnStart.transform = CGAffineTransformMakeRotation(angel);
        }];
        
        CGPoint point = btnStart.layer.position;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"animationShrink"
                                                            object:self
                                                          userInfo:@{@"position":[NSValue valueWithCGPoint:point]}];
        isRoate = !isRoate;
    }
}


- (void)sharkButton
{
    float angel = -M_PI_4;
    
    [UIView animateWithDuration:0.5f delay:0.15f usingSpringWithDamping:0.2 initialSpringVelocity:4 options:UIViewAnimationOptionLayoutSubviews animations:^(){
        btnStart.transform = CGAffineTransformMakeRotation(angel);
    }completion:nil];
    
    CGPoint point = btnStart.layer.position;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"animationExpend"
                                                        object:self
                                                      userInfo:@{@"position":[NSValue valueWithCGPoint:point]}];
}

#pragma mark - AnimationEndDelegate
- (void)animationEnd
{
    [animateView removeFromSuperview];
    
    [self.view addSubview:btnStart];
    
    [btnStart remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.centerX);
        make.centerY.equalTo(self.view.centerY).offset(100);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
}

@end

