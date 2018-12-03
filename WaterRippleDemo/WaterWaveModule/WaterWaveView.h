//
//  WaterWaveView.h
//  WristSample
//
//  Created by BaoBaoDaRen on 17/3/24.
//  Copyright © 2017年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterWaveView : UIView

- (instancetype)initWithTintColor:(UIColor *)tintColor minRadius:(CGFloat)minRadius waveCount:(NSInteger)waveCount timeInterval:(NSTimeInterval)timeInterval duration:(NSTimeInterval)duration;

- (void)startAnimating;

- (void)stopAnimating;

@end

