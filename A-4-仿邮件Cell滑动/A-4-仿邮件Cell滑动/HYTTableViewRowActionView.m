//
//  HYTTableViewRowActionView.m
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/14.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import "HYTTableViewRowActionView.h"

@implementation HYTTableViewRowActionView

+ (instancetype)rowActionViewWithTitle:(NSString *)title handler:(void (^)(HYTTableViewRowActionView *, NSIndexPath *))block {
    
    HYTTableViewRowActionView *rowActionView = [[HYTTableViewRowActionView alloc] init];
    [rowActionView setTitle:title forState:UIControlStateNormal];
    [rowActionView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rowActionView setBackgroundImage:[UIImage imageNamed:@"image1"] forState:UIControlStateNormal];
//    [rowActionView setBackgroundColor:[UIColor redColor]];
//    [rowActionView setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
//    [rowActionView sizeToFit];
    [rowActionView addTarget:rowActionView action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    return rowActionView;
}

- (void)click {
    
    NSLog(@"HYTTableViewRowActionView - click");
    
}
@end
