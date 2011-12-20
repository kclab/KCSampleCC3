//
//  KCSampleCC3Layer.m
//  KCSampleCC3
//
//  Created by  on 11/12/20.
//  Copyright KCLAB 2011年. All rights reserved.
//

#import "KCSampleCC3Layer.h"
#import "KCSampleCC3World.h"

CGPoint startLocation;

@implementation KCSampleCC3Layer
- (void)dealloc {
    [super dealloc];
}


/**
 * Template method that is invoked automatically during initialization, regardless
 * of the actual init* method that was invoked. Subclasses can override to set up their
 * 2D controls and other initial state without having to override all of the possible
 * superclass init methods.
 *
 * The default implementation does nothing. It is not necessary to invoke the
 * superclass implementation when overriding in a subclass.
 */
-(void) initializeControls {}

 // The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 // The event dispatcher will not dispatch events for which there is no method
 // implementation. Since the touch-move events are both voluminous and seldom used,
 // the implementation of ccTouchMoved:withEvent: has been left out of the default
 // CC3Layer implementation. To receive and handle touch-move events for object
 // picking,uncomment the following method implementation. To receive touch events,
 // you must also set the isTouchEnabled property of this instance to YES.

 // Handles intermediate finger-moved touch events. 

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  //NSLog(@"ccTouchBegan");
  CGPoint location = [self convertTouchToNodeSpace: touch];
  startLocation= location;
  return YES;
}

-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
  //NSLog(@"ccTouchMoved");
	CGPoint location = [self convertTouchToNodeSpace: touch];
  
  int dy = location.y - startLocation.y;
  int dx = location.x - startLocation.x;
  if (dy > 10) {
    [(KCSampleCC3World*)cc3World moveFrontCamera];
    startLocation = location;
  } else if (dy < -10) {
    [(KCSampleCC3World*)cc3World moveBacksideCamera];
    startLocation = location;
  }
  if (dx > 10) {
    [(KCSampleCC3World*)cc3World moveLeftCamera];
    startLocation = location;
  } else if (dx < - 10){
    [(KCSampleCC3World*)cc3World moveRightCamera];
    startLocation = location;
  }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  NSLog(@"ccTouchEnded");
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
  NSLog(@"ccTouchCancelled");
}

@end
