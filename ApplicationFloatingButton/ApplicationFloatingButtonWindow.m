//
//  ApplicationFloatingButtonWindow.m
//  ApplicationFloatingButton
//
//  Created by Eduardo Sanches Bocato on 29/03/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

#import "ApplicationFloatingButtonWindow.h"
#import "ApplicationFloatingButtonController.h"

@interface ApplicationFloatingButtonWindow()

#pragma mark - Properties
@property (strong, nonatomic) UIButton *floatingButton;
@property (strong, nonatomic) ApplicationFloatingButtonController *floatingButtonViewController;

@end

@implementation ApplicationFloatingButtonWindow

#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = nil; // make background transparent
    }
    return self;
}

#pragma mark - Gesture Handling
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(self.floatingButton) {
        CGPoint floatingButtonPoint = [self convertPoint:point toView:self.floatingButton];
        return [self.floatingButton pointInside:floatingButtonPoint withEvent:event];
    }
    return [super pointInside:point withEvent:event];
}

@end
