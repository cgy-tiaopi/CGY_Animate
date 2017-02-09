//
//  BackView.m
//  CGY_MutableTabBar
//
//  Created by chengangyu on 16/12/16.
//  Copyright © 2016年 tiaopi.cgy. All rights reserved.
//

#define MAS_SHORTHAND
#import "AnimateView.h"
#import "Masonry.h"
#import <math.h>

@interface AnimateView () <CAAnimationDelegate>
{
    UIImageView *CustomViewPhoto;
    UIImageView *CustomViewAlbum;
    UIImageView *CustomViewOneKey;
    
    UILabel     *labPhoto;
    UILabel     *labAlbum;
    UILabel     *labOneKey;
    
    UIButton    *btnPhoto;
    UIButton    *btnAlbum;
    UIButton    *btnOneKey;
}

@end

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width;
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height;

static CGFloat changeX = 120.0f;
static CGFloat changeY = 120.0f;

@implementation AnimateView

- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.2];
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationExpend:) name:@"animationExpend" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationShrink:) name:@"animationShrink" object:nil];
    }
    
    return self;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
}

- (void)createUI
{
    if (nil == CustomViewPhoto)
    {
        CustomViewPhoto = [[UIImageView alloc] init];
        CustomViewPhoto.backgroundColor = [UIColor clearColor];
        CustomViewPhoto.image = [UIImage imageNamed:@"photo"];
        CustomViewPhoto.tag = 1;
        
    }
    if (nil == CustomViewAlbum)
    {
        CustomViewAlbum = [[UIImageView alloc] init];
        CustomViewAlbum.backgroundColor = [UIColor clearColor];
        CustomViewAlbum.image = [UIImage imageNamed:@"album"];
        CustomViewAlbum.tag = 2;
    }
    if (nil == CustomViewOneKey)
    {
        CustomViewOneKey = [[UIImageView alloc] init];
        CustomViewOneKey.backgroundColor = [UIColor clearColor];
        CustomViewOneKey.image = [UIImage imageNamed:@"onekey"];
        CustomViewOneKey.tag = 3;
    }
    if (nil == labPhoto)
    {
        labPhoto = [[UILabel alloc] init];
        labPhoto.text = @"拍照";
        labPhoto.font = [UIFont systemFontOfSize:13.0f];
    }
    if (nil == labAlbum)
    {
        labAlbum = [[UILabel alloc] init];
        labAlbum.text = @"相册";
        labAlbum.font = [UIFont systemFontOfSize:13.0f];
    }
    if (nil == labOneKey)
    {
        labOneKey = [[UILabel alloc] init];
        labOneKey.text = @"一键转卖";
        labOneKey.font = [UIFont systemFontOfSize:13.0f];
    }
    if (nil == btnPhoto)
    {
        btnPhoto = [[UIButton alloc] init];
        [btnPhoto setBackgroundImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    }
    if (nil == btnAlbum)
    {
        btnAlbum = [[UIButton alloc] init];
        [btnAlbum setBackgroundImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    }
    if (nil == btnOneKey)
    {
        btnOneKey = [[UIButton alloc] init];
        [btnOneKey setBackgroundImage:[UIImage imageNamed:@"onekey"] forState:UIControlStateNormal];
    }
    
    [self addSubview:CustomViewPhoto];
    [self addSubview:CustomViewAlbum];
    [self addSubview:CustomViewOneKey];
    
    [self makeConstraints];
}

- (void)makeConstraints
{
    [CustomViewPhoto makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY).offset(100);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    [CustomViewAlbum makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY).offset(100);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    [CustomViewOneKey makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY).offset(100);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
}

- (void)animationExpend:(NSNotification *)notification
{
    NSValue *value = [[notification userInfo] objectForKey:@"position"];
    CGPoint startPosition = [value CGPointValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint photoEndPosition = CGPointMake(startPosition.x-changeX, startPosition.y-changeY);
        [self expendAnimationWithStartPosition:startPosition EndPosition:photoEndPosition View:CustomViewPhoto];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint albumEndPosition = CGPointMake(startPosition.x, startPosition.y-changeY);
        [self expendAnimationWithStartPosition:startPosition EndPosition:albumEndPosition View:CustomViewAlbum];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint oneKeyEndPosition = CGPointMake(startPosition.x+changeX, startPosition.y-changeY);
        [self expendAnimationWithStartPosition:startPosition EndPosition:oneKeyEndPosition View:CustomViewOneKey];
    });
}


- (void)expendAnimationWithStartPosition:(CGPoint)startPosition EndPosition:(CGPoint)endPosition View:(UIView *)customView
{
    CGPoint farPosition;
    CGPoint nearPosition;
    if (customView.tag == 1)
    {
        farPosition = CGPointMake(endPosition.x-8, endPosition.y-15);
        nearPosition =  CGPointMake(endPosition.x+3, endPosition.y+8);
    }
    else if (customView.tag ==2)
    {
        farPosition = CGPointMake(endPosition.x, endPosition.y-8);
        nearPosition =  CGPointMake(endPosition.x, endPosition.y+3);
    }
    else
    {
        farPosition = CGPointMake(endPosition.x+8, endPosition.y-15);
        nearPosition =  CGPointMake(endPosition.x-3, endPosition.y+8);
    }
    
    
    CAKeyframeAnimation *animationPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animationPosition.values = [NSArray arrayWithObjects:
                                [NSValue valueWithCGPoint:CGPointMake(startPosition.x, startPosition.y)],
                                [NSValue valueWithCGPoint:CGPointMake(farPosition.x, farPosition.y)],
                                [NSValue valueWithCGPoint:CGPointMake(nearPosition.x, nearPosition.y)],
                                [NSValue valueWithCGPoint:CGPointMake(endPosition.x, endPosition.y)],nil];
    animationPosition.keyTimes = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.0f],
                                  [NSNumber numberWithFloat:0.3f],
                                  [NSNumber numberWithFloat:0.6f],
                                  [NSNumber numberWithFloat:1.0f],nil];
    animationPosition.duration = 0.5f;
    animationPosition.beginTime = 0.0f;
    animationPosition.removedOnCompletion = NO;
    animationPosition.fillMode = kCAFillModeForwards;
    
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position"];
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(startPosition.x, startPosition.y)];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(endPosition.x, endPosition.y)];
    springAnimation.damping = 50;
    springAnimation.initialVelocity = 20;
    springAnimation.duration = springAnimation.settlingDuration;
    
    
    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.fromValue = [NSNumber numberWithFloat:1.0f];
    animationScale.toValue = [NSNumber numberWithFloat:1.4f];
    animationScale.duration = 0.15f;
    animationScale.beginTime = 0.0f;
    animationScale.removedOnCompletion = NO;
    animationScale.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    [rotateAnimation setCalculationMode:kCAAnimationLinear];
    rotateAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:M_PI_2],
                              [NSNumber numberWithFloat:-0.7f],
                              [NSNumber numberWithFloat:0.5f],
                              [NSNumber numberWithFloat:-0.1f],
                              [NSNumber numberWithFloat:0.0f],
                              nil];
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:0.0],
                                [NSNumber numberWithFloat:0.3],
                                [NSNumber numberWithFloat:0.7],
                                [NSNumber numberWithFloat:0.9],
                                [NSNumber numberWithFloat:1],nil];
    rotateAnimation.autoreverses = YES;
    rotateAnimation.beginTime = 0.0f;
    rotateAnimation.duration = 0.5f;
    
    
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animationPosition,animationScale,rotateAnimation];
    group.duration = 0.5f;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    customView.center = endPosition;
    
    [customView.layer addAnimation:group forKey:@"animationExpend"];
}

- (void)animationShrink:(NSNotification *)notification
{
    NSValue *value = [[notification userInfo] objectForKey:@"position"];
    CGPoint endPosition = [value CGPointValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint oneKeyStartPosition = CGPointMake(endPosition.x+changeX, endPosition.y-changeY);
        [self shrinkAnimationWithStartPosition:oneKeyStartPosition EndPosition:endPosition View:CustomViewOneKey];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint albumStartPosition = CGPointMake(endPosition.x, endPosition.y-changeY);
        [self shrinkAnimationWithStartPosition:albumStartPosition EndPosition:endPosition View:CustomViewAlbum];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint photoStartPosition = CGPointMake(endPosition.x-changeX, endPosition.y-changeY);
        [self shrinkAnimationWithStartPosition:photoStartPosition EndPosition:endPosition View:CustomViewPhoto];
    });
}

- (void)shrinkAnimationWithStartPosition:(CGPoint)startPosition EndPosition:(CGPoint)endPosition View:(UIImageView *)customView
{
    CAKeyframeAnimation *animationPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPosition.x, startPosition.y);
    CGPathAddLineToPoint(path, NULL, endPosition.x, endPosition.y);
    animationPosition.path = path;
    CGPathRelease(path);
    
    CABasicAnimation *animationScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.fromValue = [NSNumber numberWithFloat:1.4f];
    animationScale.toValue = [NSNumber numberWithFloat:1.0f];
    animationScale.duration = 0.15f;
    animationScale.beginTime = 0.0f;
    animationScale.removedOnCompletion = NO;
    animationScale.fillMode = kCAFillModeForwards;
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI_2],nil];
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:1.0f], nil];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animationPosition,animationScale,rotateAnimation];
    group.fillMode = kCAFillModeForwards;
    group.duration = 0.15f;
    group.removedOnCompletion = NO;
    customView.center = endPosition;
    if (customView.tag == 3)
    {
        group.delegate = self;
        [group setValue:@"EndAnimation" forKey:@"EndAnimation"];
    }
    [customView.layer addAnimation:group forKey:@"animationShrink"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"EndAnimation"] isEqualToString:@"EndAnimation"])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(animationEnd)])
        {
            [self.delegate animationEnd];
        }
    }
}
@end
