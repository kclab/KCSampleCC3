//
//  KCSampleCC3World.m
//  KCSampleCC3
//
//  Created by  on 11/12/20.
//  Copyright KCLAB 2011年. All rights reserved.
//

#import "KCSampleCC3World.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"

#import "CC3ParametricMeshNodes.h"

@interface KCSampleCC3World ()
@property(nonatomic, assign) CC3Camera* cam;
@end

@implementation KCSampleCC3World

@synthesize cam = cam_;

-(void) dealloc {
	[super dealloc];
}

/**
 * Constructs the 3D world.
 *
 * Adds 3D objects to the world, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model world.
 *
 * NOTE: The POD file used for the 'hello, world' message model is fairly large,
 * because converting a font to a mesh results in a LOT of triangles. When adapting
 * this template project for your own application, REMOVE the POD file 'hello-world.pod'
 * from the Resources folder of your project!!
 */
-(void) initializeWorld {

	// Create the camera, place it back a bit, and add it to the world
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 0.0, 0.0, 400.0 );
	[self addChild: cam];
  self.cam = cam;

	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the world
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( -2.0, 0.0, 0.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];
  
  for (int i = 0; i < 50; i++) {
    
    CC3PlaneNode* planeNode = [CC3PlaneNode nodeWithName:[NSString stringWithFormat:@"node%d", i]];
    [planeNode populateAsCenteredTexturedRectangleWithSize:CGSizeMake(89, 63)];
    planeNode.texture = [CC3Texture textureFromFile:@"browser.png"];
    [planeNode alignInvertedTextures];
    planeNode.material.specularColor = kCCC4FLightGray;
    
    GLfloat x = arc4random() % 800;
    GLfloat y = arc4random() % 800;
    GLfloat z = arc4random() % 1000;
    planeNode.location = cc3v(x - 400, y - 400, z - 500);
    //NSLog(@"planeNode.location => %@", NSStringFromCC3Vector(planeNode.location));
    
    planeNode.rotation = cc3v(0.0, 0.0, 0.0);
    planeNode.shouldCullBackFaces = NO;	// Show the ground from below as well.
    //planeNode.isTouchEnabled = YES;		// Allow the ground to be selected by touch events.
    [planeNode retainVertexLocations];		// Retain location data in main memory, even when it
    // is buffered to a GL VBO via releaseRedundantData,
    // so that it may be accessed for further calculations
    // when dropping objects on the ground.
    [self addChild: planeNode];
    
    GLfloat dy = arc4random() % 20;
    CC3MoveBy* moveBy = [CC3MoveBy actionWithDuration:2 moveBy:cc3v(0, dy - 10, 0)];
    CCSequence* seq = [CCSequence actions:moveBy, [moveBy reverse], nil];
    CCRepeatForever* repeatForever = [CCRepeatForever actionWithAction:seq];
    [planeNode runAction:repeatForever];
  }
  
  // This is the simplest way to load a POD resource file and add the
	// nodes to the CC3World, if no customized resource subclass is needed.
	//[self addContentFromPODResourceFile: @"hello-world.pod"];
	
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
	
	// That's it! The model world is now constructed and is good to go.
	
	// If you encounter problems displaying your models, you can uncomment one or
	// more of the following lines to help you troubleshoot. You can also use these
	// features on a single node, or a structure of nodes. See the CC3Node notes.
	
	// Displays short descriptive text for each node (including class, node name & tag).
	// The text is displayed centered on the pivot point (origin) of the node.
//	self.shouldDrawAllDescriptors = YES;
	
	// Displays bounding boxes around those nodes with local content (eg- meshes).
//	self.shouldDrawAllLocalContentWireframeBoxes = YES;
	
	// Displays bounding boxes around all nodes. The bounding box for each node
	// will encompass its child nodes.
//	self.shouldDrawAllWireframeBoxes = YES;
	
	// Moves the camera so that it will display the entire scene.
//	[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self];
	
	// If you encounter issues creating and adding nodes, or loading models from
	// files, the following line is used to log the full structure of the world.
	LogDebug(@"The structure of this world is: %@", [self structureDescription]);
	
	// ------------------------------------------

	// But to add some dynamism, we'll animate the 'hello, world' message
	// using a couple of cocos2d actions...
	
	// Fetch the 'hello, world' 3D text object that was loaded from the
	// POD file and start it rotating
  /*
	CC3MeshNode* helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Hello"];
	CCActionInterval* partialRot = [CC3RotateBy actionWithDuration: 1.0
														  rotateBy: cc3v(0.0, 30.0, 0.0)];
	[helloTxt runAction: [CCRepeatForever actionWithAction: partialRot]];
	
	// To make things a bit more appealing, set up a repeating up/down cycle to
	// change the color of the text from the original red to blue, and back again.
	GLfloat tintTime = 8.0f;
	ccColor3B startColor = helloTxt.color;
	ccColor3B endColor = { 50, 0, 200 };
	CCActionInterval* tintDown = [CCTintTo actionWithDuration: tintTime
														  red: endColor.r
														green: endColor.g
														 blue: endColor.b];
	CCActionInterval* tintUp = [CCTintTo actionWithDuration: tintTime
														red: startColor.r
													  green: startColor.g
													   blue: startColor.b];
	 CCActionInterval* tintCycle = [CCSequence actionOne: tintDown two: tintUp];
	[helloTxt runAction: [CCRepeatForever actionWithAction: tintCycle]];
   */
}

- (void)moveBacksideCamera {
  //NSLog(@"moveBacksideCamera");
  self.cam.location = cc3v(self.cam.location.x , self.cam.location.y, self.cam.location.z - 5);
}

- (void)moveFrontCamera {
  //NSLog(@"moveFrontCamera");
  self.cam.location = cc3v(self.cam.location.x , self.cam.location.y, self.cam.location.z + 5);
}

- (void)moveRightCamera {
  //NSLog(@"moveRightCamera");
  self.cam.location = cc3v(self.cam.location.x + 5 , self.cam.location.y, self.cam.location.z);
}

- (void)moveLeftCamera {
  //NSLog(@"moveLeftCamera");
  self.cam.location = cc3v(self.cam.location.x - 5 , self.cam.location.y, self.cam.location.z);  
}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides this node with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the node. The similar and complimentary
 * method updateAfterTransform: is automatically invoked after the transformMatrix has been
 * recalculated. If you need to make changes to the transform properties (location, rotation,
 * scale) of the node, or any child nodes, you should override this method to perform those
 * changes.
 *
 * The global transform properties of a node (globalLocation, globalRotation, globalScale)
 * will not have accurate values when this method is run, since they are only valid after
 * the transformMatrix has been updated. If you need to make use of the global properties
 * of a node (such as for collision detection), override the udpateAfterTransform: method
 * instead, and access those properties there.
 *
 * The specified visitor encapsulates the CC3World instance, to allow this node to interact
 * with other nodes in its world.
 *
 * The visitor also encapsulates the deltaTime, which is the interval, in seconds, since
 * the previous update. This value can be used to create realistic real-time motion that
 * is independent of specific frame or update rates. Depending on the setting of the
 * maxUpdateInterval property of the CC3World instance, the value of dt may be clamped to
 * an upper limit before being passed to this method. See the description of the CC3World
 * maxUpdateInterval property for more information about clamping the update interval.
 *
 * As described in the class documentation, in keeping with best practices, updating the
 * model state should be kept separate from frame rendering. Therefore, when overriding
 * this method in a subclass, do not perform any drawing or rending operations. This
 * method should perform model updates only.
 *
 * This method is invoked automatically at each scheduled update. Usually, the application
 * never needs to invoke this method directly.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides this node with an opportunity to perform update activities after
 * the transformMatrix of the node has been recalculated. The similar and complimentary
 * method updateBeforeTransform: is automatically invoked before the transformMatrix
 * has been recalculated.
 *
 * The global transform properties of a node (globalLocation, globalRotation, globalScale)
 * will have accurate values when this method is run, since they are only valid after the
 * transformMatrix has been updated. If you need to make use of the global properties
 * of a node (such as for collision detection), override this method.
 *
 * Since the transformMatrix has already been updated when this method is invoked, if
 * you override this method and make any changes to the transform properties (location,
 * rotation, scale) of any node, you should invoke the updateTransformMatrices method of
 * that node, to have its transformMatrix, and those of its child nodes, recalculated.
 *
 * The specified visitor encapsulates the CC3World instance, to allow this node to interact
 * with other nodes in its world.
 *
 * The visitor also encapsulates the deltaTime, which is the interval, in seconds, since
 * the previous update. This value can be used to create realistic real-time motion that
 * is independent of specific frame or update rates. Depending on the setting of the
 * maxUpdateInterval property of the CC3World instance, the value of dt may be clamped to
 * an upper limit before being passed to this method. See the description of the CC3World
 * maxUpdateInterval property for more information about clamping the update interval.
 *
 * As described in the class documentation, in keeping with best practices, updating the
 * model state should be kept separate from frame rendering. Therefore, when overriding
 * this method in a subclass, do not perform any drawing or rending operations. This
 * method should perform model updates only.
 *
 * This method is invoked automatically at each scheduled update. Usually, the application
 * never needs to invoke this method directly.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {}

@end

