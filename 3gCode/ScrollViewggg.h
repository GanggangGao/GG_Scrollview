//
//  ScrollViewggg.h
//  GG_Scrollview
//
//  Created by struggle3g on 16/3/21.
//  Copyright © 2016年 struggle3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollViewGGGDelegate <NSObject>

- (void)DidSelectImageAction:(NSInteger)index;

@end


@interface ScrollViewggg : UIView<UIScrollViewDelegate>
@property(nonatomic,strong)UIImage *DefalutImage;

/**
 *  滚动的时间，可以设置
 */
@property(nonatomic,assign)NSTimeInterval AutoScrollDelay;
@property(nonatomic,copy)NSArray *ImageviewGGG;

-(instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)ImageArray;

-(instancetype)initWithFrame:(CGRect)frame WithLoadImages:(NSArray *)ImageArray;




@end
