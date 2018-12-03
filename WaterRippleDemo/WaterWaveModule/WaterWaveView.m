//
//  WaterWaveView.m
//  WristSample
//
//  Created by BaoBaoDaRen on 17/3/24.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import "WaterWaveView.h"

@interface WaterWaveView ()

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSInteger waveCount;
@property (nonatomic, assign) CGFloat minRadius;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *shapeLayers;

@end

@implementation WaterWaveView

- (instancetype)initWithTintColor:(UIColor *)tintColor minRadius:(CGFloat)minRadius waveCount:(NSInteger)waveCount timeInterval:(NSTimeInterval)timeInterval duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self)
    {
        self.tintColor = tintColor;
        self.minRadius = minRadius;
        self.waveCount = waveCount;
        self.timeInterval = timeInterval;
        self.duration = duration;
        self.shapeLayers = [NSMutableArray array];
    }
    return self;
}

- (void)startAnimating
{
    [self stopAnimating];
    
    self.animating = YES;
    
    [[self shapeLayers] enumerateObjectsUsingBlock:^(CAShapeLayer * shapeLayer, NSUInteger index, BOOL *stop) {
        CAAnimation *animation = [self newWaveAnimation];
        [self performSelector:@selector(_appendAnimationParameters:) withObject:@[shapeLayer, animation] afterDelay:index * [self timeInterval]];
    }];
}

- (void)stopAnimating{
    self.animating = NO;
    
    for (CAShapeLayer *shapeLayer in [self shapeLayers]) {
        [shapeLayer removeAllAnimations];
    }
}

#pragma mark - accessor
- (CAShapeLayer *)newShapeLayer{
    
    CGPoint center = CGPointMake(CGRectGetWidth([self bounds]) / 2., CGRectGetHeight([self bounds]) / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, [self minRadius] * 2, [self minRadius] * 2) cornerRadius:[self minRadius]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(center.x - [self minRadius], center.y - [self minRadius], [self minRadius] * 2, [self minRadius] * 2);
    shapeLayer.opacity = 0;
    shapeLayer.lineWidth = 0.f;
    shapeLayer.position = center;
    shapeLayer.path = [path CGPath];
    shapeLayer.anchorPoint =  CGPointMake(0.5, 0.5);
    shapeLayer.fillColor = [[self tintColor] CGColor];
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    
    return shapeLayer;
}

- (CAAnimation *)newWaveAnimation{
    
    CGFloat maxRadius = MAX([self minRadius] * 3, MIN(CGRectGetWidth([self bounds]) / 2, CGRectGetHeight([self bounds]) / 2.));
    CGFloat scale = maxRadius / [self minRadius];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, alphaAnimation];
    animationGroup.duration = [self duration];
    animationGroup.repeatCount = NSIntegerMax;
    animationGroup.removedOnCompletion = YES;
    
    return animationGroup;
}

#pragma mark - private
- (void)reloadShapeLayers{
    
    for (CAShapeLayer *shapeLayer in [self shapeLayers]) {
        [shapeLayer removeAllAnimations];
        [shapeLayer removeFromSuperlayer];
    }
    
    [[self shapeLayers] removeAllObjects];
    
    for (NSInteger index = 0; index < [self waveCount]; index++) {
        
        CAShapeLayer *shapeLayer = [self newShapeLayer];
        [[self layer] addSublayer:shapeLayer];
        [[self shapeLayers] addObject:shapeLayer];
    }
    
    if ([self animating]) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

- (void)_appendAnimationParameters:(NSArray *)parameters {
    
    CALayer *layer = [parameters firstObject];
    CAAnimation *animation = [parameters lastObject];
    
    if ([self animating]) {
        [layer addAnimation:animation forKey:nil];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self reloadShapeLayers];
}

@end
