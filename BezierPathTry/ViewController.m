//
//  ViewController.m
//  BezierPathTry
//
//  Created by SunHong on 2017/1/5.
//  Copyright © 2017年 sunhong. All rights reserved.
//

#import "ViewController.h"

#import "BottleLoading.h"

#import "WaterDropView.h"

@interface ViewController ()

//@property (nonatomic, weak) BottleLoading *bottleLoadingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self setupBottleLoadingView];
    
    [self testDrop];
}


- (void)setupBottleLoadingView
{
    CGFloat loadWidth = self.view.bounds.size.width * 0.6;
    CGFloat loadHeight = loadWidth * 1.2;
    CGRect loadFrame = CGRectMake(0, 0, loadWidth, loadHeight);
    BottleLoading *loadView = [[BottleLoading alloc] initWithFrame:loadFrame];
    loadView.center = self.view.center;
    [self.view addSubview:loadView];
//    self.bottleLoadingView = loadView;
}

- (void)testDrop
{
    CGFloat loadWidth = self.view.bounds.size.width * 0.4;
    CGFloat loadHeight = loadWidth * 1.5;
    CGRect loadFrame = CGRectMake(0, 0, loadWidth, loadHeight);
    
    WaterDropView *dropView = [[WaterDropView alloc] initWithFrame:loadFrame];
    dropView.center = self.view.center;
    [self.view addSubview:dropView];
}


@end
