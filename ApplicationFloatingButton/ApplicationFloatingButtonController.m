//
//  ApplicationFloatingButtonController
//  ApplicationFloatingButton
//
//  Created by Eduardo Sanches Bocato on 29/03/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

#import "ApplicationFloatingButtonController.h"

@interface ApplicationFloatingButtonController ()

#pragma mark - Properties
@property (strong, nonatomic) ApplicationFloatingButtonWindow *window;

#pragma mark - Action Blocks
@property (strong, nonatomic) void(^touchUpInsideActionBlock)(ApplicationFloatingButtonController *controller);

@end

@implementation ApplicationFloatingButtonController

#pragma mark - Initialization
+ (ApplicationFloatingButtonController *)newInstanceWithTouchUpInsideActionBlock:(void(^)(ApplicationFloatingButtonController *controller))touchUpInsideActionBlock {
    ApplicationFloatingButtonController *instance = [ApplicationFloatingButtonController new];
    instance.touchUpInsideActionBlock = touchUpInsideActionBlock;
    return instance;
}

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup
- (void)setup {
    self.window = [ApplicationFloatingButtonWindow new];
    self.window.windowLevel = CGFLOAT_MAX;
    self.window.hidden = NO;
    self.window.rootViewController = self;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
}

- (void)setupPanGestureRecognizers {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.floatingButton addGestureRecognizer:panGestureRecognizer];
}

- (void)setupFloatingButtonTouchUpInsideAction {
    [self.floatingButton addTarget:self action:@selector(floatingButtonDidReceiveTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Lifecycle
- (void)loadView {
    UIButton *button = [self createButton];
    UIView *view = [UIView new];
    [view addSubview:button];
    self.view = view;
    self.floatingButton = button;
    self.window.floatingButton = self.floatingButton;
    [self setupPanGestureRecognizers];
    [self setupFloatingButtonTouchUpInsideAction];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self snapButtonToBestPosition];
}

#pragma mark - Elements Factory
- (UIButton *)createButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColor.clearColor;
    button.layer.shadowColor = UIColor.blackColor.CGColor;
    button.layer.shadowRadius = 5;
    button.layer.shadowOpacity = 0.7;
    button.layer.shadowOffset = CGSizeMake(0, 5);
    [button setImage:[UIImage imageNamed:@"user-feedback-button"] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.frame = CGRectMake(0, 20, 44, 44);
    button.alpha = 0.5;
    return button;
}

#pragma mark - Selectors
- (void)keyboardDidShow {
    // This refreshes the window level and puts it back to the top most view
    self.window.windowLevel = 0;
    self.window.windowLevel = CGFLOAT_MAX;
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint gestureOffset = [panGestureRecognizer translationInView:self.view];
    [panGestureRecognizer setTranslation:CGPointZero inView:self.view];
    CGPoint newButtonCenter = self.floatingButton.center;
    newButtonCenter.x += gestureOffset.x;
    newButtonCenter.y += gestureOffset.y;
    self.floatingButton.center = newButtonCenter;
    self.floatingButton.alpha = 1.0;
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled ) {
        [UIView animateWithDuration:0.25 animations:^{
            [self snapButtonToBestPosition];
            self.floatingButton.alpha = 0.5;
        }];
    }
    
}

- (void)floatingButtonDidReceiveTouchUpInside {
    if (self.touchUpInsideActionBlock) {
        self.touchUpInsideActionBlock(self);
    }
}

#pragma mark - Elements Layout and Positioning Methods
- (NSArray *)possibleButtonPositions {
    
    CGSize buttonSize = self.floatingButton.bounds.size;
    CGRect rect = CGRectInset(self.view.frame, 4 + buttonSize.width / 2, 4 + buttonSize.height / 2);
    
    NSMutableArray *possiblePositions = [NSMutableArray new];
    [possiblePositions addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + 20)]];
    [possiblePositions addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))]];
    [possiblePositions addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + 20)]];
    [possiblePositions addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))]];
    [possiblePositions addObject:[NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))]];
    
    return possiblePositions;
}

- (void)snapButtonToBestPosition {
    CGPoint bestPositionForButton = CGPointZero;
    CGFloat distanceToBestPosition = CGFLOAT_MAX;
    CGPoint buttonCenter = self.floatingButton.center;
    for (NSValue *possibleButtonPositionAsNSValue in [self possibleButtonPositions]) {
        CGPoint possibleButtonPosition = possibleButtonPositionAsNSValue.CGPointValue;
        CGFloat distance = hypot(buttonCenter.x - possibleButtonPosition.x, buttonCenter.y - possibleButtonPosition.y);
        if (distance < distanceToBestPosition) {
            distanceToBestPosition = distance;
            bestPositionForButton = possibleButtonPosition;
        }
    }
    self.floatingButton.center = bestPositionForButton;
}

@end
