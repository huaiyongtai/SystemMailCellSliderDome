//
//  HYTTableViewCell.h
//  A-4-仿邮件Cell滑动
//
//  Created by HelloWorld on 15/10/9.
//  Copyright (c) 2015年 无法修盖. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTTableViewCell;

@protocol  HYTTableViewCellDelegate<NSObject>

@optional
- (NSArray *)tableViewCell:(HYTTableViewCell *)tableViewCell;

@end



@interface HYTTableViewCell : UITableViewCell

@property (nonatomic, weak) id <HYTTableViewCellDelegate> delegate;



@end
