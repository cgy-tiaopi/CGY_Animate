//
//  AnimateView.h
//  CGY_Animate
//
//  Created by 陈刚宇 on 17/2/7.
//  Copyright © 2017年 CGY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimationEndDelegate <NSObject>

- (void)animationEnd;

@end

@interface AnimateView : UIView

@property (nonatomic, weak) id <AnimationEndDelegate> delegate;

@end
