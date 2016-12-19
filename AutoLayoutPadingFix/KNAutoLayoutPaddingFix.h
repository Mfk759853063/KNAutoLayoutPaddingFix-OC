//
//  KNAutoLayoutPadingFix.h
//  AutoLayoutPadingFix
//
//  Created by vbn on 2016/12/19.
//  Copyright © 2016年 vbn. All rights reserved.
//

// AutoLayout 调整/还原间距
// 使用场景：当一个view需要hidden时，调用fixView:axis 方法会将view的上/左间距自动置为0，当不需要hidden时，调用restoreView: 还原间距

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS (NSInteger, KNAutoLayoutPaddingFixAxis) {
    KNAutoLayoutPaddingFixAxisLeft = 1 << 0,
    KNAutoLayoutPaddingFixAxisRight = 1 << 1,
    KNAutoLayoutPaddingFixAxisTop = 1 << 2,
    KNAutoLayoutPaddingFixAxisBottom = 1 << 3,
};

@interface KNAutoLayoutPaddingFix : NSObject

+ (void)fixViews:(NSArray<UIView *> *)views axis:(KNAutoLayoutPaddingFixAxis)axis;

+ (void)fixView:(UIView *)view axis:(KNAutoLayoutPaddingFixAxis)axis;

+ (void)restoreViews:(NSArray<UIView *> *)views;

+ (void)restoreView:(UIView *)view;

@end
