//
//  ViewController.m
//  无线滚动
//
//  Created by I Smile going on 15/8/15.
//  Copyright (c) 2015年 iOS_小董. All rights reserved.
//

#import "ViewController.h"

#define WIDTH self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define COUNT 5 //一共几张图片
#define TIME 120 //几秒自动轮播默认2秒
#define TIMEUPDATE YES //是否需要自动轮播默认YES

static long count = 0; //记录时钟动画调用次数

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
//上一张图片
@property (nonatomic, strong) UIImageView* preImageView;
//下一张图片
@property (nonatomic, strong) UIImageView* nextImageView;
//当前图片
@property (nonatomic, strong) UIImageView* currentImageView;
//当前图片的索引
@property (nonatomic, assign) NSInteger index;
//计时器
@property (nonatomic, strong) CADisplayLink* timer;
//是否在滚动
@property(nonatomic,assign)BOOL isDraging;
//page页码
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];

    scrollView.contentSize = CGSizeMake(3 * WIDTH, 0);

    scrollView.pagingEnabled = YES;

    scrollView.showsHorizontalScrollIndicator = NO;

    scrollView.showsVerticalScrollIndicator = NO;

    scrollView.contentOffset = CGPointMake(WIDTH, 0);

    scrollView.delegate = self;

    scrollView.bounces = NO;

    self.scrollView = scrollView;

    [self.view addSubview:scrollView];

    self.index = 1;

    [self addImageView];
    
    [self addTimeUpDate];
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    pageControl.pageIndicatorTintColor = [UIColor purpleColor];
    
    pageControl.numberOfPages = COUNT;
    
    pageControl.frame = CGRectMake(0, HEIGHT - 35, WIDTH, 35);
    
    self.pageControl = pageControl;
    
    [self.view addSubview:pageControl];
    
}

- (void)addTimeUpDate
{
    if (TIMEUPDATE) {
        
        self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
        //加入runlop
        [self.timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }else{
        return;
    }
}

- (void)update:(CADisplayLink*)timer
{
    count++;
    
    if (count % TIME != 0 || self.isDraging) {
        
        return;
    }else
    {
        [self.scrollView setContentOffset:CGPointMake(2 * WIDTH, 0) animated:YES];
    }
    NSLog(@"%ld",count);
}

//添加图片控件

- (void)addImageView
{
    //上一张

    UIImageView* preImageView = [[UIImageView alloc] init];

    self.preImageView = preImageView;

    preImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);

    [self.scrollView addSubview:preImageView];

    //下一张
    UIImageView* nextImageView = [[UIImageView alloc] init];

    self.nextImageView = nextImageView;

    nextImageView.frame = CGRectMake(2 * WIDTH, 0, WIDTH, HEIGHT);

    [self.scrollView addSubview:nextImageView];


    //当前

    UIImageView* currentImageView = [[UIImageView alloc] init];

    self.currentImageView = currentImageView;

    currentImageView.frame = CGRectMake(WIDTH, 0, WIDTH, HEIGHT);

    currentImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"无线滚动图片_0%zd", self.index]];

    //    currentImageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.scrollView addSubview:currentImageView];

}

//开始

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDraging = YES;
    
}

//结束

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isDraging = NO;
    
    count = 0;
}
//滚动代理

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    if (self.preImageView.image == nil || self.nextImageView.image == nil) {

        self.preImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"无线滚动图片_0%zd", self.index == 1 ? COUNT : self.index - 1]];

        self.nextImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"无线滚动图片_0%zd", self.index == COUNT ? 1 : self.index + 1]];
    }

    //判断是向左还是向右

    if (scrollView.contentOffset.x == 2 * WIDTH) {
        //向右

        if (self.index == COUNT) {

            self.index = 1;
        }
        else {
            self.index += 1;
        }

        self.currentImageView.image = self.nextImageView.image;

        self.nextImageView.image = nil;

        scrollView.contentOffset = CGPointMake(WIDTH, 0);
    }

    if (scrollView.contentOffset.x == 0) {

        //向左

        if (self.index == 1) {

            self.index = COUNT;
        }
        else {
            self.index -= 1;
        }

        self.currentImageView.image = self.preImageView.image;

        self.preImageView.image = nil;

        scrollView.contentOffset = CGPointMake(WIDTH, 0);
    }
    
    self.pageControl.currentPage = self.index - 1;

//    NSLog(@"%zd", self.index);
}



@end
