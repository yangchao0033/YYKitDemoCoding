//
//  YCFPSLabel.m
//  Pods
//
//  Created by 超杨 on 16/1/19.
//
//

#import "YCFPSLabel.h"
#import "YYKit.h"

#define kSize CGSizeMake(150, 20)

@implementation YCFPSLabel{
    /** 计时器 */
    CADisplayLink *_link;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    UIFont *_font;
    UIFont *_subFont;
    
    NSTimeInterval _llll;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size = kSize;
    }
    self = [super initWithFrame:frame];
    
    /** 圆角 */
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    /** 使用css创建lable的字体 */
    _font = [UIFont fontWithName:@"Menlo" size:14];
    if (_font) {
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
    } else {
        _font = [UIFont fontWithName:@"Courier" size:14];
        _subFont = [UIFont fontWithName:@"Courier" size:14];
    }
    
    /** 使用若代理设置并启动计时器 */
    _link = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}

- (void)dealloc {
    [_link invalidate];
}
/** 复写此方法用来确定view的尺寸不受sizeToFit影响 */
- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}


- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        /** timestamp 当前帧播放的时间戳 */
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    /** 每次播放一帧都会调用该方法，并记录上次与这次帧的时间差 */
    NSTimeInterval delta = link.timestamp - _lastTime;
    /** 如果小于一秒，则继续，每次走一帧来这一次，此时 count 不停累加， */
    if (delta < 1) {
        return;
    }
    /** 当时间刚够一秒时（因为跑完够一秒的最后一帧可能会长），计算跑了多少帧 */
    _lastTime = link.timestamp;
    /** 计算平均每秒跑了多少帧 */
    float fps = _count / delta;
    /** 每计算完一个fps，就将跑过的帧数置为零 */
    _count = 0;
    
//    NSLog(@"FPS == %f", fps);
    
    /** 占最大fps的百分比 */
    CGFloat prograss = fps / 60.0;
    /** 通过指定的透明度和HSB 颜色空间结构创建一个 color 对象 
      * 安利一下：
     色相（H,hue）：在0~360°的标准色轮上，色相是按位置度量的。在通常的使用中，色相是由颜色名称标识的，比如红、绿或橙色。黑色和白色无色相。
     饱和度（S,saturation）：表示色彩的纯度，为0时为灰色。白、黑和其他灰色色彩都没有饱和度的。在最大饱和度时，每一色相具有最纯的色光。取值范围0～100%。
     亮度（B,brightness或V,value）：是色彩的明亮度。为0时即为黑色。最大亮度是色彩最鲜明的状态。取值范围0～100%。
     但是在iOS中，这三个值都是出于0.0到1.0之间
     */
    UIColor *color = [UIColor colorWithHue:0.27 * (prograss - 0.2) saturation:1 brightness:0.9 alpha:1];
    /** 创建属性字符串 */
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS", (int)round(fps)]];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%f FPS", fps]];
    [text setColor:color range:NSMakeRange(0, text.length - 3)];
    [text setColor:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    text.font = _font;
    [text setFont:_subFont range:NSMakeRange(text.length - 4, 1)];
    self.attributedText = text;
    
}
@end
