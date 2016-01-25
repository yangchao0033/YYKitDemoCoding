//
//  YCTableViewCell.m
//  Pods
//
//  Created by 超杨 on 16/1/21.
//
//

#import "YCTableViewCell.h"

@implementation YCTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                /** 该属性用来决定是否延处理 touch-down 手势 */
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
@end
