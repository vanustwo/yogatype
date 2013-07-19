//
//  GameView.m
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import "GameView.h"
#import "Ragdoll.h"
#import "PhysicShapeBuilder.h"
#import "PosePoint.h"

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
        
        [self initYogaPoses];
        
        gameState = GameState_Start;
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

- (void)initYogaPoses
{
    testPoint = CGPointMake(48, 63);
    
    if( !_posePointArray )
    {
        _posePointArray = [NSMutableArray arrayWithCapacity:2];
    }
    
    PosePoint* posePoint = [[PosePoint alloc] initWithPoint:testPoint inScene:self toNode:(ShapeNode*)[self childNodeWithName:@"rightHand"]];
    posePoint.ragdollCentre = _ragdoll.centreNode;
    [_posePointArray addObject:posePoint];
    
    CGPoint nodePosition = ccpAdd(posePoint.ragdollCentre.position, posePoint.offsetPoint);
    ShapeNode* node= [PhysicShapeBuilder addBallShapeNodeWithRadius:10.0f withPhysicBody:NO];
    node.position = nodePosition;
    posePoint.shapeNode = node;
    [self addChild:node];
    
    
    
    
    
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
                ShapeNode *node = [self.ragdoll findLimbAtPosition:location];
                
                BOOL touchedLimb = false;
                
                CGFloat distance = ccpDistance(location, node.position);
                if( distance<node.radius )
                {
                    NSLog(@"touch inside %@", node.name);
                    touchedLimb = true;
                }
                
                if( touchedLimb )
                {
                    [joint destroyMouseJoint];
                    [joint createMouseNodeAtPoint:location withNode:node inScene:self withTouch:touch];
                    joint.currentPosition = location;
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
                    joint.currentPosition = location;
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

#pragma mark - Update

-(void)update:(CFTimeInterval)currentTime {
    [super update:currentTime];
    
    //NSLog(@"Time passed %f", self.timeSinceLast);
    
    switch (gameState) {
        case GameState_Start:
        {
         
            for( MouseJoint* joint in self.mouseJointArray )
            {
                
                if( joint.touch )
                {
                    if( joint.mouseJoint )
                    {
                        joint.mouseNode.position = joint.currentPosition;
                         
                         //CGPoint point = [self.ragdoll distanceBetweenCentreFromNode:joint.dragNode];
                        // NSLog(@"node %@ %f %f", joint.dragNode.name, point.x, point.y);
                        //joint.currentPosition = location;
                        
                        //[self.ragdoll isDraggableNodeInPosition:testPoint withNode:joint.dragNode];

                        
                        
                    }
                    break;
                    
                }
                
            }
            
            
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //NSLog(@"didBeginContact");
}

- (void)didEndContact:(SKPhysicsContact *)contact
{
   // NSLog(@"didEndContact");
}

- (BOOL)isLimbInPosePoint:(PosePoint*)posePoint
{
    CGPoint targetNodePosition = ccpAdd(posePoint.offsetPoint, posePoint.ragdollCentre.position);
    
    CGFloat distance = ccpDistance(targetNodePosition, posePoint.limbNode.position);
    if( distance<10.0f )
    {
        return YES;
    }
    
    
    return NO;
}

@end
