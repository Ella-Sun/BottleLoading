//
//  WaterDropView.m
//  BezierPathTry
//
//  Created by SunHong on 2017/1/9.
//  Copyright © 2017年 sunhong. All rights reserved.
//

#import "WaterDropView.h"

#define ViewHeight self.bounds.size.height
#define ViewWidth self.bounds.size.width
#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
//水珠升起的角度
#define UpAngle DEGREES_TO_RADIANS(30)
//动态水面最低处的Y值
#define WaterLowY (ViewHeight - 30)
//动态水面最高点处的Y值
#define WaterHighY WaterLowY*0.75
@interface WaterDropView ()

//计时器——>水滴的运动
@property (nonatomic, weak) CADisplayLink *displayLink;
//水面
@property (nonatomic, weak) CAShapeLayer *waterLayer;
//单个水滴
@property (nonatomic, weak) CAShapeLayer *circleLayer;
//第一个水滴的路径
@property (nonatomic, weak) UIBezierPath *circlePath;
//第一个水滴X坐标
@property (nonatomic, assign) CGFloat firstXpixel;

@end

@implementation WaterDropView

//参考 波浪的形成
//http://blog.csdn.net/u010731949/article/details/53069218

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.firstXpixel = 40.f;
        
        //绘制界面
        [self drawDynamicWater];
        [self drawFirstWaterDropLayer];
        
        //跳动
//        [self setupTimeLink];
    }
    return self;
}

- (void)setupTimeLink
{
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(allMoveUp:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;
}

/**
 绘制动态的水面——>先绘制静态的
 */
- (void)drawDynamicWater
{
    CGFloat startY = WaterLowY;
    CGFloat endY = WaterHighY;
    //倾斜的水面
    CGPoint startPoint = CGPointMake(0, startY);
    CGPoint leftTurn = CGPointMake(0, ViewHeight);
    CGPoint rightTurn = CGPointMake(ViewWidth, ViewHeight);
    CGPoint endPoint = CGPointMake(ViewWidth, endY);
    
    UIBezierPath *waterPath = [UIBezierPath bezierPath];
    [waterPath moveToPoint:startPoint];
    [waterPath addLineToPoint:leftTurn];
    [waterPath addLineToPoint:rightTurn];
    [waterPath addLineToPoint:endPoint];
    [waterPath closePath];
    
    CAShapeLayer *waterLayer = [CAShapeLayer layer];
    waterLayer.path = waterPath.CGPath;
    waterLayer.fillColor = [UIColor greenColor].CGColor;
    waterLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:waterLayer];
    self.waterLayer = waterLayer;
}

/**
 第一滴水
 */
- (void)drawFirstWaterDropLayer
{
    //应该是静态水面的值
    CGFloat firstMinY = WaterLowY;
    
    CGFloat circleRadius = 20.f;
    CGFloat circleMinX = 50.f;
    CGRect circleFrame = CGRectMake(circleMinX, firstMinY, circleRadius*2, circleRadius*2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:circleFrame];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = path.CGPath;
    circleLayer.fillColor = [UIColor grayColor].CGColor;
    circleLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:circleLayer];
    
    
    //运用UIBezierPath实现由快到慢的过程
    //(0.390, 0.575, 0.565, 1.000)
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    self.circlePath = circlePath;
    
    /**
     *  我们不能直接通过 self.sideHelperView.layer 和 self.centerHelperView.layer 获
        取两个辅助视图动画过程中的变化的坐标，得到的是一个恒定的终点状态的坐标。要想获得动画过程
        中的每个状态的坐标，我们需要使用layer的 presentationLayer ，并且通
        过 valueForKeyPath:@"position"的方式实时获取动态坐标。
     
        最后千万别忘了调用 [self.jellyView setNeedsDisplay]; ,否则
        - (void)drawRect:(CGRect)rect不会called.
     */
    
    /**
     *  问题是：
     1. 水珠初始位置在哪儿？——>静态水面以下
     2.✨ 如何判断水珠到达水面，以及逐渐脱离水面——>和水面的波动有关，计算每个水面的位置，根据X轴坐标，判断是否到达水面？
     3. 贝塞尔曲线的点如何取？（距离如何计算）以及点的位置是如何移动的
     */
    
    /**
     *  开始动画
     */
    
}

/**
 动起来
 */
- (void)allMoveUp:(CADisplayLink *)displayLink
{
    //水滴
    [self moveFirstWaterDropLayer];
    
    [self setNeedsDisplay];
}

/**
 *  先做一个水珠升起、下降的过程
 */
- (void)moveFirstWaterDropLayer
{
    // 清空上一次的所有点，也就是擦除上一次的水滴
    [self.circlePath removeAllPoints];
    
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint control1Point = CGPointMake(0.39, 0.575);
    CGPoint control2Point = CGPointMake(0.565, 1.0);
    CGPoint endPoint = CGPointMake(1.0, 1.0);
    [self.circlePath moveToPoint:startPoint];
    [self.circlePath addCurveToPoint:endPoint
                  controlPoint1:control1Point
                  controlPoint2:control2Point];
    [self.circlePath addLineToPoint:CGPointMake(1.0, 0)];

}


/**
 动画完成
 */
- (void)completeAnimation
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}


@end
