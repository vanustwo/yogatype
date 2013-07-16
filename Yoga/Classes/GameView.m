//
//  GameView.m
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "GameView.h"
#import "Ragdoll.h"

#define MAX_TOUCHES             2

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
        [self initMouseJoints];
        
        self.ragdoll = [[Ragdoll alloc] init];
        [self.ragdoll createRagdollAtPosition:[self screenCenterPoint] inScene:self];
        
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

- (void)initMouseJoints
{
    
    self.mouseJointArray = [NSMutableArray arrayWithCapacity:MAX_TOUCHES];

    //create 2 empty mouse joint
    for( int i=0;i<MAX_TOUCHES;i++ )
    {
        MouseJoint* mj = [[MouseJoint alloc] init];
       [self.mouseJointArray addObject:mj];
    }
    
}

#pragma mark - Touch Handler

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSLog(@"location %f %f", location.x, location.y);

        for( MouseJoint* joint in self.mouseJointArray )
        {
            
            if( !joint.touch && !joint.mouseJoint )
            {
                BodyShapeNode *node = [self.ragdoll findLimbAtPosition:location];
                
                BOOL touchedLimb = false;
                
                CGFloat distance = ccpDistance(location, node.position);
                if( distance<node.radius )
                {
                    NSLog(@"touch inside %@", node.name);
                    touchedLimb = true;
                }
            
                if( touchedLimb )
                {
                    [joint createMouseNodeAtPoint:location withNode:node inScene:self withTouch:touch];
                    break;
                }
                
            
            }
        }
        
       
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
    
        
        for( MouseJoint* joint in self.mouseJointArray )
        {
            
            if( joint.touch && joint.touch==touch  )
            {
                if( joint.mouseJoint )
                {
                    joint.mouseNode.position = location;
                }
                break;
                
            }
            
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {

        for( MouseJoint* joint in self.mouseJointArray )
        {
            if( joint.touch && joint.touch==touch  )
            {
                [joint destroyMouseJoint];
            }
        }
        
        
    }
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
