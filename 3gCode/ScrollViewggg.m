//
//  ScrollViewggg.m
//  GG_Scrollview
//
//  Created by struggle3g on 16/3/21.
//  Copyright © 2016年 struggle3g. All rights reserved.
//

#import "ScrollViewggg.h"

#define  PAGEIMAGESIZE 16
#define  SCROLLWIDTH self.frame.size.width
#define  SCROLLHEIGHT self.frame.size.height



@implementation ScrollViewggg
{
    BOOL IsNetWorkImage;  //是否是网络加载图片

    UIScrollView *_scrollView;  //滚动视图
    UIPageControl *_PageControl;  //标签下标
    UIImageView *_leftImageView,*_centerImageView,*_rightImageView;  //核心思想是只有3个图片view
    NSInteger _currentindex;  //当前显示的索引数
    NSInteger _Maxindex;        //图片的总数
    NSTimer *_timer;   //定时器
    
}


/**
 *
 *
 *  @param frame         super frame
 *  @param ImageArray    image counts
 *
 *  @return              self
 */
-(instancetype)initWithFrame:(CGRect)frame WithLoadImages:(NSArray *)ImageArray{

    if(ImageArray.count<2){
        return nil;
    }
    self = [super initWithFrame:frame];
    if(self){
        NSLog(@"调用了初始化的内容");
        IsNetWorkImage = NO;
        [self createScrollView];
        [self CreateAddArray:ImageArray];
        [self SetPageScrollCount:_ImageviewGGG.count];
        _currentindex = 0;
    }

    return self;
}
/**
 *
 *
 *  @param frame      <#frame description#>
 *  @param ImageArray <#ImageArray description#>
 *
 *  @return <#return value description#>
 */
-(instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)ImageArray{
    
    self = [super initWithFrame:frame];
    if(self){
        IsNetWorkImage = YES;
    }
    
    return self;
}



#pragma  mark -- 创建的初始化的控件
/**
 *  初始化滚动视图
 */
-(void)createScrollView{

    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:self.bounds];
    scroll.contentSize = CGSizeMake(SCROLLWIDTH*3, 0);
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.backgroundColor = [UIColor grayColor];
    _scrollView = scroll;
    [self addSubview:_scrollView];
}


/**
 *   将Array赋值给初始化的self   本地的或者是网络的图片  
 *   如果网络的图片比较多的话建议不用sdimage  直接用nsdata初始化
 *
 *  @param ImageArray   要显示的images
 */

-(void)CreateAddArray:(NSArray *)ImageArray{

    if(IsNetWorkImage){
        _ImageviewGGG = [ImageArray copy];
    }else{
        NSMutableArray *loadImageArray = [[NSMutableArray alloc]initWithCapacity:ImageArray.count];
        for (NSString *imageStr in ImageArray) {
            NSString *pathStr = [[NSBundle mainBundle]pathForResource:imageStr ofType:@"jpg"];
            NSData  *imagedata = [NSData dataWithContentsOfFile:pathStr];
            [loadImageArray addObject:[UIImage imageWithData:imagedata]];
        }
        _ImageviewGGG = [loadImageArray copy];
    }

}

/**
 *    初始化scrollview中的所有的控件
 */
-(void)SetPageScrollCount:(NSInteger)count{
    
    _Maxindex = count;
    [self initWithImageView];
    [self setUpdatetime];
    [self createpageControl];
    /** 初始化图片位置*/
    [self changeImageLeft:_Maxindex-1 center:0 right:1];
    
}

/**
 *      初始化控件  left  center right
 *
 */
- (void)initWithImageView{

    _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCROLLWIDTH, SCROLLHEIGHT)];
    _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCROLLWIDTH, 0, SCROLLWIDTH, SCROLLHEIGHT)];
    _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCROLLWIDTH*2, 0, SCROLLWIDTH, SCROLLHEIGHT)];
    _centerImageView.userInteractionEnabled = YES;
    [_centerImageView addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    [_scrollView addSubview:_leftImageView];
    [_scrollView addSubview:_rightImageView];
    [_scrollView addSubview:_centerImageView];

}
/**
 *  初始化pageview的内容
 */
- (void)createpageControl{
    _PageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0,SCROLLHEIGHT - PAGEIMAGESIZE , 8)];
    _PageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _PageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    _PageControl.numberOfPages = _Maxindex;
    _PageControl.currentPage = 0;
    CGPoint point = CGPointMake(self.center.x, SCROLLHEIGHT - PAGEIMAGESIZE);
    _PageControl.center = point;
    [self addSubview:_PageControl];
}





#pragma  mark -- scrollview的delegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self setUpdatetime];

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self changeImageWithOffset:scrollView.contentOffset.x];
    
}


-(void)changeImageWithOffset:(CGFloat)offsetX{
    if (offsetX >= SCROLLWIDTH * 2)
    {
        _currentindex++;
        
        if (_currentindex == _Maxindex-1)
        {
            [self changeImageLeft:_currentindex-1 center:_currentindex right:0];
            
        }else if (_currentindex == _Maxindex)
        {
            
            _currentindex = 0;
            
            [self changeImageLeft:_Maxindex-1 center:0 right:1];
            
        }else
        {
            [self changeImageLeft:_currentindex-1 center:_currentindex right:_currentindex+1];
        }
        _PageControl.currentPage = _currentindex;
        
    }
    
    if (offsetX <= 0)
    {
        _currentindex--;
        
        if (_currentindex == 0) {
            
            [self changeImageLeft:_Maxindex-1 center:0 right:1];
            
        }else if (_currentindex == -1) {
            
            _currentindex = _Maxindex-1;
            [self changeImageLeft:_currentindex-1 center:_currentindex right:0];
            
        }else {
            [self changeImageLeft:_currentindex-1 center:_currentindex right:_currentindex+1];
        }
        
        _PageControl.currentPage = _currentindex;
    }
    

}

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    if (IsNetWorkImage)
    {
        
//        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[LeftIndex]] placeholderImage:_placeholderImage];
//        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[centerIndex]] placeholderImage:_placeholderImage];
//        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[rightIndex]] placeholderImage:_placeholderImage];
        
    }else
    {
        _leftImageView.image = _ImageviewGGG[LeftIndex];
        _centerImageView.image = _ImageviewGGG[centerIndex];
        _rightImageView.image = _ImageviewGGG[rightIndex];
    }
    
    [_scrollView setContentOffset:CGPointMake(SCROLLWIDTH, 0)];
}



#pragma  mark -- metch
/**
 *  图片的点击事件
 */
- (void)imageViewDidTap{
    NSLog(@"点击了图片的内容");
}



//设置定时器
-(void)setUpdatetime{

    _timer  = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(ScrollFrame) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];

}


//定时器的方法
-(void)ScrollFrame{

    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + SCROLLWIDTH, 0) animated:YES];

}

//杀掉定时器
- (void)removeTimer{
    [_timer invalidate];
    _timer = nil;
}



#pragma  mark -- 可以设置间隔的时间
- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay{
    _AutoScrollDelay = AutoScrollDelay;
    [self removeTimer];
    [self setUpdatetime];
}

- (void)dealloc {

    [self removeTimer];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
*/

@end
