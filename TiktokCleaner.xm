%hook UIViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toggleButton.frame = CGRectMake(20, 100, 80, 40);
        [toggleButton setTitle:@"净化" forState:UIControlStateNormal];
        [toggleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        toggleButton.tag = 12345;
        [toggleButton addTarget:self action:@selector(toggleCleanMode) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:toggleButton];
    });
}

%new
- (void)toggleCleanMode {
    static BOOL isClean = NO;
    isClean = !isClean;

    UIButton *btn = [self.view viewWithTag:12345];
    if (isClean) {
        [btn setTitle:@"恢复" forState:UIControlStateNormal];
        [self applyCleanMode];
    } else {
        [btn setTitle:@"净化" forState:UIControlStateNormal];
        [self disableCleanMode];
    }
}

%new
- (void)applyCleanMode {
    for (UIView *subview in self.view.subviews) {
        if (![subview isKindOfClass:[UIButton class]]) {
            subview.hidden = YES;
        }
    }
}

%new
- (void)disableCleanMode {
    for (UIView *subview in self.view.subviews) {
        subview.hidden = NO;
    }
}

%end