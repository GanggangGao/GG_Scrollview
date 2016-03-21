//
//  ViewController.m
//  GG_Scrollview
//
//  Created by struggle3g on 16/3/21.
//  Copyright © 2016年 struggle3g. All rights reserved.
//

#import "ViewController.h"
#import "ScrollViewggg.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i =1 ; i<11; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    ScrollViewggg *scrollView = [[ScrollViewggg alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) WithLoadImages:array];
    scrollView.AutoScrollDelay = 3;
    scrollView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
