//
//  UIView+DKView.m
//  DEMOKING
//
//  Created by 王亚振 on 2021/4/25.
//

#import "UIView+DKView.h"
#import <objc/runtime.h>

static char kDKTapBlock;

@implementation UIView (DKView)

/// runtime构建属性
/// @param tapBlock 点击回调
- (void)setTapBlock:(DKTapBlock)tapBlock {
    objc_setAssociatedObject(self, &kDKTapBlock, tapBlock, OBJC_ASSOCIATION_COPY);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMethod:)];
    [self addGestureRecognizer:tap];
}
- (DKTapBlock)tapBlock {
    return objc_getAssociatedObject(self, &kDKTapBlock);
}
- (void)tapMethod:(UIGestureRecognizer *)tap {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
