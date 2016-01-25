//
//  WBStatusCell.h
//  Pods
//
//  Created by 超杨 on 16/1/21.
//
//

#import "YCTableViewCell.h"
#import "YYKit.h"

@class YCWBStatusLayout, WBStatusCell;
@protocol WBStatusCellDelegate;

@interface WBStatusTitleView : UIView
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, weak) WBStatusCell *cell;
@end

/** 大背景 */
@interface  WBStatusView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) YCWBStatusLayout *layout;
@property (nonatomic, weak) WBStatusCell *cell;
@end


@interface WBStatusCell : YCTableViewCell
@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
@property (nonatomic, strong) WBStatusView *statusView;
- (void)setLayout:(YCWBStatusLayout *)layout;
@end

@protocol WBStatusCellDelegate <NSObject>

@optional
/** 点击Cell */


@end