//
//  WBStatusCell.m
//  Pods
//
//  Created by 超杨 on 16/1/21.
//
//

#import "WBStatusCell.h"
#import "YYKit.h"
#import "YCWBStatusLayout.h"

@implementation WBStatusTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = kWBCellTitleHeight;
    }
    if (self = [super initWithFrame:frame]) {
        _titleLabel = [YYLabel new];
        _titleLabel.size = CGSizeMake(kScreenWidth - 100, self.height);
        _titleLabel.left = kWBCellPadding;
        _titleLabel.displaysAsynchronously = YES;
        _titleLabel.fadeOnHighlight = NO;
        
    }
}
@end

@implementation WBStatusView

@end

@implementation WBStatusCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _statusView = [[WBStatusView alloc] init];
        [self.contentView addSubview:_statusView];
    }
    return self;
}

- (void)prepareForReuse {
    /** 不知奥 */
}

- (void)setLayout:(YCWBStatusLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

@end
