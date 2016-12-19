//
//  KNAutoLayoutPadingFix.m
//  AutoLayoutPadingFix
//
//  Created by vbn on 2016/12/19.
//  Copyright © 2016年 vbn. All rights reserved.
//

#import "KNAutoLayoutPaddingFix.h"
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
    
    if (axis & KNAutoLayoutPaddingFixAxisTop) {
        NSLayoutConstraint *topConstraint = [self findTopConstraintWithView:view];
        if (topConstraint) {
            [self setView:view constant:0 constraint:topConstraint];
        }
    }
    if (axis & KNAutoLayoutPaddingFixAxisLeft) {
        NSLayoutConstraint *leftConstraint = [self findLeftConstraintWithView:view];
        if (leftConstraint) {
            [self setView:view constant:0 constraint:leftConstraint];
        }
    }
    
    if (axis & KNAutoLayoutPaddingFixAxisRight) {
        NSLayoutConstraint *rightConstraint = [self findRightConstraintWithView:view];
        if (rightConstraint) {
            [self setView:view constant:0 constraint:rightConstraint];
        }
    }
    
    if (axis & KNAutoLayoutPaddingFixAxisBottom) {
        NSLayoutConstraint *bottomConstraint = [self findBottomConstraintWithView:view];
        if (bottomConstraint) {
            [self setView:view constant:0 constraint:bottomConstraint];
        }
    }
}

+ (void)setView:(UIView *)view constant:(CGFloat)constant constraint:(NSLayoutConstraint *)constraint {
    NSDictionary *parms = @{KNCONSTAINTKEY:constraint,KNCONSTANTKEY:@(constraint.constant)};
    [view.restoreConstaints addObject:parms];
    constraint.constant = constant;
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

+ (NSLayoutConstraint *)findView:(UIView *)view constraintAttribute:(NSLayoutAttribute)attribute {
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if ((constraint.firstItem == view && constraint.firstAttribute == attribute) ||
            (constraint.secondItem == view && constraint.secondAttribute == attribute)) {
            return constraint;
            break;
        }
    }
    return nil;
}

+ (NSLayoutConstraint *)findTopConstraintWithView:(UIView *)view {
    
    return [self findView:view constraintAttribute:NSLayoutAttributeTop];
}

+ (NSLayoutConstraint *)findLeftConstraintWithView:(UIView *)view {
    return [self findView:view constraintAttribute:NSLayoutAttributeLeading];
}

+ (NSLayoutConstraint *)findRightConstraintWithView:(UIView *)view {
    return [self findView:view constraintAttribute:NSLayoutAttributeTrailing];
}

+ (NSLayoutConstraint *)findBottomConstraintWithView:(UIView *)view {
    return [self findView:view constraintAttribute:NSLayoutAttributeBottom];
}

@end


