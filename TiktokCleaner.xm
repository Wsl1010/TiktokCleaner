#import <UIKit/UIKit.h>

@interface DouyinViewController : UIViewController
- (void)applyCleanMode;
- (void)disableCleanMode;
@end

%hook DouyinViewController

- (void)viewDidLoad {
    %orig;

    // 添加净化按钮
    UIButton *cleanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cleanButton.frame = CGRectMake(100, 100, 80, 40);
    [cleanButton setTitle:@"净化" forState:UIControlStateNormal];
    cleanButton.tag = 12345; // 防止被隐藏
    [cleanButton addTarget:self action:@selector(toggleCleanMode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cleanButton];
}

// 添加按钮点击事件
%new
- (void)toggleCleanMode:(UIButton *)sender {
    static BOOL isClean = NO;
    isClean = !isClean;
    if (isClean) {
        [self applyCleanMode];
        [sender setTitle:@"还原" forState:UIControlStateNormal];
    } else {
        [self disableCleanMode];
        [sender setTitle:@"净化" forState:UIControlStateNormal];
    }
}

// 进入净化模式：隐藏除按钮以外所有内容
%new
- (void)applyCleanMode {
    for (UIView *subview in self.view.subviews) {
        if (subview.tag != 12345) {
            subview.hidden = YES;
        }
    }
}

// 关闭净化模式：恢复所有内容显示
%new
- (void)disableCleanMode {
    for (UIView *subview in self.view.subviews) {
        subview.hidden = NO;
    }
}

%end
