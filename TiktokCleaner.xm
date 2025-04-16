#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        toggleButton.frame = CGRectMake(20, 100, 60, 30);
        [toggleButton setTitle:@"净化" forState:UIControlStateNormal];
        [toggleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        toggleButton.tag = 12345;
        [toggleButton addTarget:self action:@selector(toggleCleanMode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:toggleButton];
    });
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
        if (subview.tag != 12345) { // 保留 toggleButton
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
