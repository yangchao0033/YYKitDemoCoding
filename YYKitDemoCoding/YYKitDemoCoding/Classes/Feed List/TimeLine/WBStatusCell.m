//
//  WBStatusCell.m
//  Pods
//
//  Created by 超杨 on 16/1/21.
//
//

#import "WBStatusCell.h"


@implementation WBStatusTitleView


@end


@implementation WBStatusProfileView



@end


@implementation WBStatusCardView


@end

@implementation WBStatusToolbarView


@end

@implementation WBStatusTagView


@end

@implementation WBStatusView


@end

@implementation WBStatusCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _statusView = [WBStatusView new];
        [self.contentView addSubview:_statusView];
    }
    return self;
}

- (void)prepareForReuse {
    
}

- (void)setLayout:(YCWBStatusLayout *)layout {
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

@end
