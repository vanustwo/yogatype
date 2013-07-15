//
//  GameView.h
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseView.h"

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    YogaColliderTypeWall             = 1,
    YogaColliderTypeBody             = 2,
    YogaColliderTypeArm              = 4,
    APAColliderTypeWall              = 8,
    APAColliderTypeCave              = 16
} YogaColliderType;


@interface GameView : BaseView
{

}

@property (nonatomic, strong) SKPhysicsJointLimit *mouseJoint;
@property (nonatomic, strong) SKNode *mouseNode;

- (SKShapeNode*)addBallShapeNodeWithRadius:(CGFloat)radius withPhysicBody:(BOOL)usePhysics;
- (SKShapeNode*)addBoxShapeNodeWithSize:(CGSize)size withPhysicBody:(BOOL)usePhysics;


@end

