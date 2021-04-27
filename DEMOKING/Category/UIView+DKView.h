//
//  UIView+DKView.h
//  DEMOKING
//
//  Created by 王亚振 on 2021/4/25.
//

#import <UIKit/UIKit.h>
typedef void (^DKTapBlock)(void);

@interface UIView (DKView)

/// 调用tapBlock简单的单击事件回调
@property (copy, nonatomic) DKTapBlock tapBlock;

@end

