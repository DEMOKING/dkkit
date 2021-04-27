//
//  UIButton+DKButton.m
//  DEMOKING
//
//  Created by 王亚振 on 2021/4/25.
//

#import "UIButton+DKButton.h"
#import <objc/runtime.h>

static char kDKTouchBlock;

@implementation UIButton (DKButton)

/// runtime构建属性
/// @param touchBlock 点击回调
- (void)setTouchBlock:(DKTouchBlock)touchBlock {
    objc_setAssociatedObject(self, &kDKTouchBlock, touchBlock, OBJC_ASSOCIATION_COPY);
    [self addTarget:self
             action:@selector(touchMethod)
   forControlEvents:UIControlEventTouchUpInside];
}
- (DKTouchBlock)touchBlock {
    return objc_getAssociatedObject(self, &kDKTouchBlock);
}
- (void)touchMethod {
    if (self.touchBlock) {
        self.touchBlock();
    }
}

@end
