//
//  GameView.m
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "GameView.h"

@implementation GameView


#pragma mark Init

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Yoga!";
        myLabel.fontSize = 20;
        myLabel.position = [self screenCenterPoint];
        [self addChild:myLabel];
        
        [self initPhysicsWorld];
       // [self buildRagdoll];
        
        [self createRagdollAtPosition:[self screenCenterPoint]];
        
        self.mouseJoint = nil;
    }
    return self;
}


- (void)initPhysicsWorld
{
    NSLog(@"initPhysicsWorld");
    [self.physicsWorld setGravity:CGPointMake(0, -9.8f)];
    self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    //self.physicsBody.categoryBitMask = YogaColliderTypeWall;
    self.physicsBody.dynamic = NO;
}


#pragma mark - Ragdoll builder

- (void)createRagdollAtPosition:(CGPoint)position
{
    
    //head
    
    CGFloat headRadius = 12.0f;
    
    SKShapeNode* head = [self addBallShapeNodeWithRadius:headRadius withPhysicBody:YES];
    head.physicsBody.categoryBitMask = YogaColliderTypeBody;
    head.physicsBody.collisionBitMask = YogaColliderTypeWall;
    head.physicsBody.contactTestBitMask = YogaColliderTypeWall;
   // head.physicsBody.dynamic = NO;
    head.name = @"head";
    head.position = position;
    [self addChild:head];
    
    
    CGSize torsoSize = CGSizeMake(35, 15);
    
    
    //torso 1
    SKShapeNode* torso1 = [self addBoxShapeNodeWithSize:torsoSize withPhysicBody:YES];
    torso1.position = CGPointMake(head.position.x, head.position.y-(headRadius/2 + torsoSize.height));
    torso1.physicsBody.dynamic = YES;
    torso1.name = @"torso1";
    [self addChild:torso1];
    
    
    //torso 2
    SKShapeNode* torso2 = [self addBoxShapeNodeWithSize:torsoSize withPhysicBody:YES];
    torso2.physicsBody.categoryBitMask = YogaColliderTypeBody;
    torso2.physicsBody.collisionBitMask = YogaColliderTypeWall;
    torso2.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    torso2.position = CGPointMake(torso1.position.x, torso1.position.y-torsoSize.height);
    torso2.physicsBody.dynamic = YES;
    torso2.name = @"torso2";
    [self addChild:torso2];

    
    //torso 3
    SKShapeNode* torso3 = [self addBoxShapeNodeWithSize:torsoSize withPhysicBody:YES];
    torso3.physicsBody.categoryBitMask = YogaColliderTypeBody;
    torso3.physicsBody.collisionBitMask = YogaColliderTypeWall;
    torso3.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    torso3.position = CGPointMake(torso2.position.x, torso2.position.y-torsoSize.height);
    torso3.physicsBody.dynamic = YES;
    torso3.name = @"torso3";
    [self addChild:torso3];
    
    
    //left arm
    
    CGSize armSize = CGSizeMake(10, 20);
    
    //upper arm
    SKShapeNode* upperLeftArm = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperLeftArm.name = @"leftShoulder";
    upperLeftArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    upperLeftArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperLeftArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //upperLeftArm.physicsBody.dynamic = NO;
    upperLeftArm.position = CGPointMake(torso1.position.x - ((torsoSize.width/2)), (torso1.position.y + torsoSize.height/2) - armSize.height/2  );
    [self addChild:upperLeftArm];
    
    
    //lower arm
    SKShapeNode* lowerLeftArm = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerLeftArm.name = @"lowerLeftArm";
    lowerLeftArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    lowerLeftArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerLeftArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    lowerLeftArm.physicsBody.dynamic = YES;
    lowerLeftArm.position = CGPointMake(upperLeftArm.position.x, upperLeftArm.position.y - armSize.height  );
    [self addChild:lowerLeftArm];
    
    
    //right arm
    SKShapeNode* upperRightArm = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperRightArm.name = @"rightShoulder";
    upperRightArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    upperRightArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperRightArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    upperRightArm.position = CGPointMake(torso1.position.x + ((torsoSize.width/2)), (torso1.position.y + torsoSize.height/2) - armSize.height/2  );
    [self addChild:upperRightArm];
    
    //lower right arm
    SKShapeNode* lowerRightArm = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerRightArm.name = @"lowerRightArm";
    lowerRightArm.physicsBody.categoryBitMask = YogaColliderTypeArm;
    lowerRightArm.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerRightArm.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    lowerRightArm.physicsBody.dynamic = YES;
    lowerRightArm.position = CGPointMake(upperRightArm.position.x, upperRightArm.position.y - armSize.height  );
    [self addChild:lowerRightArm];
    
    
    //legs
    //left leg
    CGSize legSize = CGSizeMake(10, 20);
    
    SKShapeNode* upperLeftLeg = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperLeftLeg.name = @"upperLeftLeg";
    upperLeftLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    upperLeftLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperLeftLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //upperLeftLeg.physicsBody.dynamic = NO;
    upperLeftLeg.position = CGPointMake(torso3.position.x - ((torsoSize.width*0.3f)), (torso3.position.y - torsoSize.height/2) - legSize.height/2  );
    [self addChild:upperLeftLeg];

    
    SKShapeNode* lowerLeftLeg = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerLeftLeg.name = @"lowerLeftLeg";
    lowerLeftLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    lowerLeftLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerLeftLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //lowerLeftLeg.physicsBody.dynamic = NO;
    lowerLeftLeg.position = CGPointMake(upperLeftLeg.position.x, upperLeftLeg.position.y - legSize.height  );
    [self addChild:lowerLeftLeg];
    
    //right leg
    
    SKShapeNode* upperRightLeg = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    upperRightLeg.name = @"upperRightLeg";
    upperRightLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    upperRightLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    upperRightLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //upperRightLeg.physicsBody.dynamic = NO;
    upperRightLeg.position = CGPointMake(torso3.position.x + ((torsoSize.width*0.3f)), (torso3.position.y - torsoSize.height/2) - legSize.height/2  );
    [self addChild:upperRightLeg];

    SKShapeNode* lowerRightLeg = [self addBoxShapeNodeWithSize:armSize withPhysicBody:YES];
    lowerRightLeg.name = @"lowerRightLeg";
    lowerRightLeg.physicsBody.categoryBitMask = YogaColliderTypeLeg;
    lowerRightLeg.physicsBody.collisionBitMask = YogaColliderTypeWall;
    lowerRightLeg.physicsBody.contactTestBitMask = YogaColliderTypeWall;
    //lowerRightLeg.physicsBody.dynamic = NO;
    lowerRightLeg.position = CGPointMake(upperRightLeg.position.x, upperRightLeg.position.y - legSize.height  );
    [self addChild:lowerRightLeg];
    
    
    //joints
    
    //pin head to background
    SKPhysicsJointPin* pinJoint = [SKPhysicsJointPin jointWithBodyA:self.physicsBody bodyB:head.physicsBody anchor:head.position];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.frictionTorque = 0.2f;
    pinJoint.lowerAngleLimit = -40.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 40.0f / (180.0f / M_PI);
   // [self.physicsWorld addJoint:pinJoint];
    
    //head to torso 1
    pinJoint = [SKPhysicsJointPin jointWithBodyA:head.physicsBody bodyB:torso1.physicsBody anchor:CGPointMake(torso1.position.x, torso1.position.y+(torsoSize.height/2))];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -40.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    pinJoint.upperAngleLimit = 40.0f / (180.0f / M_PI);
    [self.physicsWorld addJoint:pinJoint];
    
    //torso 1 -> torso 2
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso1.physicsBody bodyB:torso2.physicsBody anchor:CGPointMake(torso1.position.x, torso1.position.y-(torsoSize.height/2))];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -15.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 15.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    

    
    //torso 2 -> torso 3
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso2.physicsBody bodyB:torso3.physicsBody anchor:CGPointMake(torso2.position.x, torso2.position.y-(torsoSize.height/2))];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -15.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 15.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    

    //torso 1 to left arm
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso1.physicsBody bodyB:upperLeftArm.physicsBody anchor:CGPointMake(torso1.position.x - ((torsoSize.width/2)), torso1.position.y + torsoSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
  
    [self.physicsWorld addJoint:pinJoint];
    
    //upper arm to lower arm
    
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperLeftArm.physicsBody bodyB:lowerLeftArm.physicsBody anchor:CGPointMake(lowerLeftArm.position.x, lowerLeftArm.position.y+armSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    
    
    //torso 1 to right arm
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso1.physicsBody bodyB:upperRightArm.physicsBody anchor:CGPointMake(torso1.position.x + ((torsoSize.width/2)), torso1.position.y + torsoSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
    [self.physicsWorld addJoint:pinJoint];
    
    //upper right to lower arm
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperRightArm.physicsBody bodyB:lowerRightArm.physicsBody anchor:CGPointMake(lowerRightArm.position.x, lowerRightArm.position.y+armSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -85.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 130.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    

    //left leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso3.physicsBody bodyB:upperLeftLeg.physicsBody anchor:CGPointMake(upperLeftLeg.position.x, upperLeftLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 45.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    
   
    //lower left leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperLeftLeg.physicsBody bodyB:lowerLeftLeg.physicsBody anchor:CGPointMake(lowerLeftLeg.position.x, lowerLeftLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 115.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    
    //right leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:torso3.physicsBody bodyB:upperRightLeg.physicsBody anchor:CGPointMake(upperRightLeg.position.x, upperRightLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 45.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    
    
    //lower right leg
    pinJoint = [SKPhysicsJointPin jointWithBodyA:upperRightLeg.physicsBody bodyB:lowerRightLeg.physicsBody anchor:CGPointMake(upperRightLeg.position.x, upperRightLeg.position.y+legSize.height/2 )];
    pinJoint.shouldEnableLimits = YES;
    pinJoint.lowerAngleLimit = -25.0f / (180.0f / M_PI);
    pinJoint.upperAngleLimit = 115.0f / (180.0f / M_PI);
    pinJoint.frictionTorque = 0.2f;
    [self.physicsWorld addJoint:pinJoint];
    
    //[upperLeftLeg.physicsBody applyAngularImpulse:0.11f];


}

- (SKShapeNode*)addBallShapeNodeWithRadius:(CGFloat)radius withPhysicBody:(BOOL)usePhysics
{
    SKShapeNode *shape = [[SKShapeNode alloc] init];
    
    CGMutablePathRef path = CGPathCreateMutable();

    CGPathAddArc(path, NULL, 0,0, radius, 0, M_PI*2, YES);
    shape.path = path;
    shape.fillColor = [SKColor blueColor];
    shape.strokeColor = [SKColor redColor];
    shape.antialiased = YES;
    shape.lineWidth = 1.0f;
    
    CGPathRelease(path);
    
    if( usePhysics )
    {
        shape.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    }
    
    return shape;
}

- (SKShapeNode*)addBoxShapeNodeWithSize:(CGSize)size withPhysicBody:(BOOL)usePhysics
{
    SKShapeNode *shape = [[SKShapeNode alloc] init];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(-size.width/2, -size.height/2, size.width, size.height));
    shape.path = path;
    shape.fillColor = [SKColor blueColor];
    shape.strokeColor = [SKColor redColor];
    shape.lineWidth = 0.4f;
    shape.antialiased = YES;

    CGPathRelease(path);
    
    
    //SKSpriteNode* shape = [SKSpriteNode spriteNodeWithColor:[SKColor blueColor] size:size];
    
    if( usePhysics )
    {
        shape.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
        shape.physicsBody.density = 3.0f;
    }
    
    return shape;
}

#pragma mark - Touch Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKPhysicsBody *body = [self.physicsWorld bodyAtPoint:location];
        
        if( body && !self.mouseJoint )
        {
            
            SKNode *node = body.node;
            
            NSLog(@"touch body %@", node.name);
            
            [self destroyMouseNode];
            [self createMouseNodeAtPoint:location withNode:node];
            
        }
        
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInNode:self];
    
    if( self.mouseJoint )
    {
       self.mouseNode.position = point;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self destroyMouseNode];
}

#pragma mark - Mouse Joint

- (void)createMouseNodeAtPoint:(CGPoint)point withNode:(SKNode *)node
{
    float width = 10;
    self.mouseNode = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(width, width)];
    self.mouseNode.position = point;
    [self addChild:self.mouseNode];
    
    SKPhysicsBody *mouseBody = [SKPhysicsBody bodyWithCircleOfRadius:width*2];
    [mouseBody setDynamic:NO];
    [self.mouseNode setPhysicsBody:mouseBody];

    self.mouseJoint = [SKPhysicsJointLimit jointWithBodyA:node.physicsBody bodyB:self.mouseNode.physicsBody anchorA:node.position anchorB:point];
    self.mouseJoint.maxLength = 5;
    [self.physicsWorld addJoint:self.mouseJoint];
    
}

- (void)destroyMouseNode
{
    
    if (self.mouseNode) {
        [self.mouseNode removeFromParent];
        self.mouseNode = nil;
    }
    
    if (self.mouseJoint) {
        [self.physicsWorld removeJoint:self.mouseJoint];
        self.mouseJoint = nil;
    }
    
}

#pragma mark - Update

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
    
    //NSLog(@"Time passed %f", self.timeSinceLast);
    
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //NSLog(@"didBeginContact");
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
   // NSLog(@"didEndContact");
}


@end
