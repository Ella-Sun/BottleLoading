//
//  BottleLoading.m
//  BezierPathTry
//
//  Created by SunHong on 2017/1/5.
//  Copyright © 2017年 sunhong. All rights reserved.
//

#import "BottleLoading.h"

//#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

//发大倍数
static CGFloat bigScale = 1;
//线宽
static CGFloat bottleWidth = 5.f;

static CGFloat marginSpace = 10.f;
//花瓶宽度
static CGFloat loadWidth = 200.f;
//花瓶高度
static CGFloat loadHeight = 220.f;

//瓶颈高度
#define neckHeight (loadHeight - 2*marginSpace) * 0.4
//瓶身高度
#define bodyHeight (loadHeight - 2*marginSpace) * 0.5
//瓶底宽度
#define bottomWidth (loadWidth * 0.5)
//瓶口宽度
#define topWidth (loadWidth * 0.3)
//花瓶颜色
#define BotttleColor [UIColor blackColor]
//水的颜色
#define WaterColor [UIColor greenColor]
//水与水瓶之间的颜色
#define SpaceColor [UIColor clearColor]

@interface BottleLoading ()

//绘制瓶子的view
@property (nonatomic, weak) UIView *loadingView;

//瓶口
@property (nonatomic, weak) CAShapeLayer *topLayer;
//瓶身
@property (nonatomic, weak) CAShapeLayer *bodyLayer;

//右侧
//瓶身
@property (nonatomic, weak) CAShapeLayer *otherBodyLayer;

//瓶底
@property (nonatomic, weak) CAShapeLayer *bottomLayer;

@end

@implementation BottleLoading

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //绘制瓶子
        [self setupBottleView];
        //绘制水
        [self setupWaterView];
    }
    return self;
}

/**
 绘制瓶子
 */
- (void)setupBottleView
{
    CGRect showFrame = CGRectMake(0, 0, loadWidth, loadHeight);
    UIView *loadingView = [[UIView alloc] initWithFrame:showFrame];
    loadingView.center = self.center;
    loadingView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:loadingView];
    
    self.loadingView = loadingView;
    
    //瓶口
    [self drawBottleTopLayer];
    //瓶颈 瓶身
    [self drawBottleBodyLayer];
    
    //翻转得到对面一半
    [self summaryRotateLayers];
    //瓶底
    [self drawBottleBottomLayer];
}

/**
 绘制水
 */
- (void)setupWaterView
{
    //绘制靠近底部的静态的水
    [self drawStaticWaterLayer];
    //绘制水波
    [self drawWaterWaveLayer];
    //绘制水滴
    [self drawWaterDropLayer];
}

/**
 绘制瓶口
 */
- (void)drawBottleTopLayer
{
    //瓶口 左边点
    CGFloat topLeftX = (loadWidth - topWidth) * 0.5;
    //左侧瓶边中心
    CGFloat leftMidX = topLeftX;
    
    //创建path
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    /**<  绘制瓶口&&瓶颈  >**/
    
    CGFloat offsetLeftX = 2.f *bigScale;
    //瓶嘴外侧
    // 添加外圆到path
    CGFloat outRadius = 5.f *bigScale;
    CGPoint outArcCenter = CGPointMake(leftMidX-offsetLeftX, outRadius+marginSpace);
    CGFloat outStartAngle = M_PI_2;
    CGFloat outEndAngle = -M_PI_2;
    [path addArcWithCenter:outArcCenter
                    radius:outRadius
                startAngle:outStartAngle
                  endAngle:outEndAngle
                 clockwise:YES];
    
    //瓶嘴内侧 180°角
    CGFloat inRadius = 2.f *bigScale;
    CGPoint inArcCenter = CGPointMake(leftMidX-offsetLeftX, inRadius+marginSpace);
    CGFloat inStartAngle = -M_PI_2;
    CGFloat inEndAngle = M_PI_2;
    // 添加内圆到path
    [path addArcWithCenter:inArcCenter
                    radius:inRadius
                startAngle:inStartAngle
                  endAngle:inEndAngle
                 clockwise:YES];
    
    //缺口
    CGFloat lineRightX = leftMidX + bottleWidth*0.5;
    CGPoint lineRightTopPoint = CGPointMake(lineRightX, marginSpace+1.7*outRadius);
    
    //使拐角圆滑
    CGFloat lineRightTopY = outRadius + marginSpace;
    CGPoint controlPoint = CGPointMake(lineRightX, lineRightTopY);
    [path addQuadCurveToPoint:lineRightTopPoint controlPoint:controlPoint];
    
    [path closePath];
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = path.CGPath;
    circleLayer.lineWidth = 5;
    circleLayer.fillColor = BotttleColor.CGColor;
    circleLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.loadingView.layer addSublayer:circleLayer];
    
    self.topLayer = circleLayer;
}

/**
 瓶颈 && 瓶身
 */
- (void)drawBottleBodyLayer
{
    //左侧瓶边中心
    CGFloat leftMidX = (loadWidth - topWidth) * 0.5;
    
    //创建path
    UIBezierPath *bodyPath = [UIBezierPath bezierPath];
    bodyPath.lineWidth = bottleWidth;
    // 终点处理：设置结束点曲线
    bodyPath.lineCapStyle = kCGLineCapRound;
    // 拐角处理：设置两个连接点曲线
    bodyPath.lineJoinStyle = kCGLineJoinRound;
    
    /**<  瓶颈  >**/
    CGFloat outRadius = 5.f *bigScale;
    CGFloat lineHeight = neckHeight;
    CGFloat lineRightTopY = marginSpace + 1.7*outRadius;
    CGFloat lineX = leftMidX;
    
    CGPoint lineTopPoint = CGPointMake(lineX, lineRightTopY);
    CGPoint lineBottomPoint = CGPointMake(lineX, (lineRightTopY+lineHeight));
    
    /**<  绘制瓶颈  >**/
    [bodyPath moveToPoint:lineTopPoint];
    [bodyPath addLineToPoint:lineBottomPoint];
    
    /**<  绘制瓶身  >**/
    CGFloat bodyMinY = 64.f;
    //瓶底左侧点 曲线结束点
    CGFloat bottomY = loadHeight - 10;
    CGFloat leftBottomX = (loadWidth - bottomWidth) * 0.5 + 5;
    CGPoint endPoint = CGPointMake(leftBottomX, bottomY);
    
    //二次贝塞尔曲线 一个控制点 一个终点
    CGPoint control1Point = CGPointMake(0, bodyMinY+bodyHeight*0.9);
    
    /**<  绘制瓶身  >**/
    [bodyPath addQuadCurveToPoint:endPoint controlPoint:control1Point];
    
    CAShapeLayer *bodyLayer = [CAShapeLayer layer];
    bodyLayer.path = bodyPath.CGPath;
    bodyLayer.lineWidth = bottleWidth;
    bodyLayer.fillColor = [UIColor clearColor].CGColor;
    bodyLayer.strokeColor = BotttleColor.CGColor;
    [self.loadingView.layer addSublayer:bodyLayer];
    
    self.bodyLayer = bodyLayer;
}

/**
 翻转之前创建的layer 得到瓶子另一半
 */
- (void)summaryRotateLayers
{
    CGFloat tx = loadWidth;
    CGAffineTransform trans = CGAffineTransformMake(-1, 0, 0, 1, tx, 0);
    
    //瓶口
    CAShapeLayer *otherTopLayer = [CAShapeLayer layer];
    otherTopLayer.path = self.topLayer.path;
    otherTopLayer.affineTransform = trans;
    otherTopLayer.lineWidth = bottleWidth;
    otherTopLayer.fillColor = BotttleColor.CGColor;
    otherTopLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.loadingView.layer addSublayer:otherTopLayer];
    
    //瓶身
    CAShapeLayer *otherBodyLayer = [CAShapeLayer layer];
    otherBodyLayer.path = self.bodyLayer.path;
    otherBodyLayer.affineTransform = trans;
    otherBodyLayer.lineWidth = bottleWidth;
    otherBodyLayer.fillColor = [UIColor clearColor].CGColor;
    otherBodyLayer.strokeColor = BotttleColor.CGColor;
    [self.loadingView.layer addSublayer:otherBodyLayer];
    self.otherBodyLayer = otherBodyLayer;
}

/**
 绘制瓶底
 */
- (void)drawBottleBottomLayer
{
    //创建path
    UIBezierPath *bottomPath = [UIBezierPath bezierPath];
    bottomPath.lineWidth = bottleWidth;
    // 终点处理：设置结束点曲线
    bottomPath.lineCapStyle = kCGLineCapRound;
    // 拐角处理：设置两个连接点曲线
    bottomPath.lineJoinStyle = kCGLineJoinRound;
    
    //瓶底左侧点 曲线结束点
    CGFloat bottomY = loadHeight - marginSpace;
    CGFloat leftBottomX = (loadWidth - bottomWidth) * 0.5 + 4;
    CGFloat rightBottomX = leftBottomX + bottomWidth - 8;
    CGPoint leftBeginPoint = CGPointMake(leftBottomX, bottomY);
    CGPoint rightEndPoint = CGPointMake(rightBottomX, bottomY);
    
    /**<  绘制瓶底  >**/
    [bottomPath moveToPoint:leftBeginPoint];
    [bottomPath addLineToPoint:rightEndPoint];
    
    CAShapeLayer *bottomLayer = [CAShapeLayer layer];
    bottomLayer.path = bottomPath.CGPath;
    bottomLayer.lineWidth = bottleWidth;
    bottomLayer.fillColor = [UIColor clearColor].CGColor;
    bottomLayer.strokeColor = BotttleColor.CGColor;
    [self.loadingView.layer addSublayer:bottomLayer];
}


/**
 绘制靠近底部的静态的水
 */
- (void)drawStaticWaterLayer
{
    CGFloat lineWidth = 1.f;
    //静态水面高度
    CGFloat staticHeight = bodyHeight * 0.5;
    CGFloat staticWidth = bottomWidth * 1.27;
    
    //起始点
    CGFloat leftStartX = (loadWidth - staticWidth) * 0.5;
    CGFloat leftStartY = loadHeight - marginSpace - bottleWidth - staticHeight;
    CGPoint leftStartPoint = CGPointMake(leftStartX, leftStartY);
    
    //结束点
    CGFloat leftEndX = loadWidth * 0.5;
    CGFloat leftEndY = loadHeight - marginSpace - bottleWidth;
    CGPoint leftEndPoint = CGPointMake(leftEndX, leftEndY);
    
    //中间补全
    UIBezierPath *bMidPath = [UIBezierPath bezierPath];
    bMidPath.lineWidth = 0.1;
    // 终点处理：设置结束点曲线
    bMidPath.lineCapStyle = kCGLineCapRound;
    // 拐角处理：设置两个连接点曲线
    bMidPath.lineJoinStyle = kCGLineJoinRound;
    
    CGPoint rightStartPoint = CGPointMake(loadWidth-leftStartX, leftStartY);
    [bMidPath moveToPoint:leftStartPoint];
    [bMidPath addLineToPoint:leftEndPoint];
    [bMidPath addLineToPoint:rightStartPoint];
    [bMidPath closePath];
    
    CAShapeLayer *bMidWaterLayer = [CAShapeLayer layer];
    bMidWaterLayer.path = bMidPath.CGPath;
    bMidWaterLayer.lineWidth = 0.1;
    bMidWaterLayer.fillColor = WaterColor.CGColor;
    bMidWaterLayer.strokeColor = [UIColor clearColor].CGColor;
    [self.loadingView.layer addSublayer:bMidWaterLayer];
    
    //左侧弧线
    UIBezierPath *bLeftPath = [UIBezierPath bezierPath];
    //控制点
    CGFloat controlX = (loadWidth - bottomWidth) * 0.5 - bottleWidth*2.1;
    CGFloat controlY = loadHeight - marginSpace - bodyHeight*0.2;
    CGPoint control1Point = CGPointMake(controlX, controlY);
    
    CGFloat controlX1 = (loadWidth - bottomWidth) * 0.5;
    CGFloat controlY1 = loadHeight - marginSpace;
    CGPoint control2Point = CGPointMake(controlX1, controlY1);
    [bLeftPath moveToPoint:leftStartPoint];
    [bLeftPath addCurveToPoint:leftEndPoint
                 controlPoint1:control1Point
                 controlPoint2:control2Point];
    
    
    //左侧
    CAShapeLayer *bLeftWaterLayer = [CAShapeLayer layer];
    bLeftWaterLayer.path = bLeftPath.CGPath;
    bLeftWaterLayer.lineWidth = lineWidth;
    bLeftWaterLayer.fillColor = WaterColor.CGColor;
    bLeftWaterLayer.strokeColor = SpaceColor.CGColor;
    [self.loadingView.layer addSublayer:bLeftWaterLayer];
    
    //右侧
    CGFloat tx = loadWidth;
    CGAffineTransform trans = CGAffineTransformMake(-1, 0, 0, 1, tx, 0);
    CAShapeLayer *bRightLayer = [CAShapeLayer layer];
    bRightLayer.path = bLeftWaterLayer.path;
    bRightLayer.affineTransform = trans;
    bRightLayer.lineWidth = lineWidth;
    bRightLayer.fillColor = WaterColor.CGColor;
    bRightLayer.strokeColor = SpaceColor.CGColor;
    [self.loadingView.layer addSublayer:bRightLayer];
    
    
}

/**
 绘制水波
 */
- (void)drawWaterWaveLayer
{
    
}

/**
 绘制水滴
 */
- (void)drawWaterDropLayer
{
    
}

@end
