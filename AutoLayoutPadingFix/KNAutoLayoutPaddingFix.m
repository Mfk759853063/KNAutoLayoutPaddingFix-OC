//
//  KNAutoLayoutPadingFix.m
//  AutoLayoutPadingFix
//
//  Created by vbn on 2016/12/19.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import "KNAutoLayoutPadingFix.h"
#import "objc/runtime.h"

@interface UIView (KNAutoLayoutPaddingFix)

@property (strong, nonatomic) NSMutableArray<NSDictionary *> *restoreConstaints;

@end

@implementation UIView (KNAutoLayoutPaddingFix)

- (NSMutableArray<NSDictionary *> *)restoreConstaints {
    return objc_getAssociatedObject(self, @selector(restoreConstaints));
}

- (void)setRestoreConstaints:(NSMutableArray<NSDictionary *> *)restoreConstaints {
    objc_setAssociatedObject(self, @selector(restoreConstaints), restoreConstaints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

@implementation KNAutoLayoutPaddingFix

static const NSString *KNCONSTAINTKEY = @"constaint";
static const NSString *KNCONSTANTKEY = @"constant";

+ (void)fixViews:(NSArray<UIView *> *)views axis:(KNAutoLayoutPaddingFixAxis)axis {
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self fixView:obj axis:axis];
    }];
}

+ (void)fixView:(UIView *)view axis:(KNAutoLayoutPaddingFixAxis)axis {
    if (!view.restoreConstaints) {
        view.restoreConstaints = @[].mutableCopy;
    }
    [view.restoreConstaints removeAllObjects];
    
    if (axis & KNAutoLayoutPaddingFixAxisVertical) {
        NSLayoutConstraint *topConstraint = [self findTopConstraintWithView:view];
        if (topConstraint) {
            NSDictionary *parms = @{KNCONSTAINTKEY:topConstraint,KNCONSTANTKEY:@(topConstraint.constant)};
            [view.restoreConstaints addObject:parms];
            topConstraint.constant = 0;
        }
    }
    if (axis & KNAutoLayoutPaddingFixAxisHorizontal) {
        NSLayoutConstraint *leftConstraint = [self findLeftConstraintWithView:view];
        if (leftConstraint) {
            NSDictionary *parms = @{KNCONSTAINTKEY:leftConstraint,KNCONSTANTKEY:@(leftConstraint.constant)};
            [view.restoreConstaints addObject:parms];
            leftConstraint.constant = 0;
        }
    }
}

+ (void)restoreViews:(NSArray<UIView *> *)views {
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self restoreView:obj];
    }];
}

+ (void)restoreView:(UIView *)view{
    [view.restoreConstaints enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *constraint = obj[KNCONSTAINTKEY];
        NSNumber *constant = obj[KNCONSTANTKEY];
        constraint.constant = constant.floatValue;
    }];
    [view.restoreConstaints removeAllObjects];
}



#pragma mark - find Constraint

+ (NSLayoutConstraint *)findTopConstraintWithView:(UIView *)view {
    
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if ((constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeTop) ||
            (constraint.secondItem == view && constraint.secondAttribute == NSLayoutAttributeTop)) {
            return constraint;
            break;
        }
    }
    return nil;
}

+ (NSLayoutConstraint *)findLeftConstraintWithView:(UIView *)view {
    
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if ((constraint.firstItem == view && constraint.firstAttribute == NSLayoutAttributeLeading) ||
            (constraint.secondItem == view && constraint.secondAttribute == NSLayoutAttributeLeading)) {
            return constraint;
            break;
        }
    }
    return nil;
}

@end


