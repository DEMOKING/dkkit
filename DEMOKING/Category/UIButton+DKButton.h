//
//  UIButton+DKButton.h
//  DEMOKING
//
//  Created by 王亚振 on 2021/4/25.
//

#import <UIKit/UIKit.h>

typedef void (^DKTouchBlock)(void);

@interface UIButton (DKButton)

/// 调用tapBlock简单的单击事件回调
@property (copy, nonatomic) DKTouchBlock touchBlock;

@end

