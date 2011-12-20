//
//  KCSampleCC3World.h
//  KCSampleCC3
//
//  Created by  on 11/12/20.
//  Copyright KCLAB 2011年. All rights reserved.
//


#import "CC3World.h"
#import "CC3MeshNode.h"

/** A sample application-specific CC3World subclass.*/
@interface KCSampleCC3World : CC3World {}
- (void)moveBacksideCamera;
- (void)moveFrontCamera;
- (void)moveRightCamera;
- (void)moveLeftCamera;
@end
