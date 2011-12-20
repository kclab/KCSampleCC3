//
//  KCSampleCC3AppDelegate.h
//  KCSampleCC3
//
//  Created by  on 11/12/20.
//  Copyright KCLAB 2011年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCNodeController.h"
#import "CC3World.h"

@interface KCSampleCC3AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow* window;
	CCNodeController* viewController;
}

@property (nonatomic, retain) UIWindow* window;

@end
