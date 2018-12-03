//
//  ViewController.m
//  WaterRippleDemo
//
//  Created by BaoBaoDaRen on 2018/12/3.
//  Copyright © 2018年 BaoBao. All rights reserved.
//

#import "ViewController.h"
#import "WaterWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *waterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:waterView];
    waterView.layer.masksToBounds = YES;
    waterView.layer.cornerRadius = 50;
    waterView.backgroundColor = [UIColor clearColor];
    waterView.center = self.view.center;
    
    WaterWaveView *rippleView = [[WaterWaveView alloc] initWithTintColor:[self colorWithHexString:@"#E5B3B3"] minRadius:6 waveCount:5 timeInterval:1 duration:4];
    [waterView addSubview:rippleView];
    rippleView.frame = waterView.bounds;
    
    [rippleView startAnimating];
}

#define DEFAULT_VOID_COLOR [UIColor whiteColor]
- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
    {
        return DEFAULT_VOID_COLOR;
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return DEFAULT_VOID_COLOR;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
