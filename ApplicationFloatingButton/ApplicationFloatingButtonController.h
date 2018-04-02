//
//  ApplicationFloatingButtonController.h
//  ApplicationFloatingButton
//
//  Created by Eduardo Sanches Bocato on 29/03/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationFloatingButtonWindow.h"

@interface ApplicationFloatingButtonController : UIViewController

#pragma mark - Properties
@property (strong, nonatomic) UIButton *floatingButton;

#pragma mark - Initialization
+ (ApplicationFloatingButtonController *)newInstanceWithTouchUpInsideActionBlock:(void(^)(ApplicationFloatingButtonController *controller))touchUpInsideActionBlock;

@end
