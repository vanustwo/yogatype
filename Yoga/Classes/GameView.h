//
//  GameView.h
//  Yoga
//
//  Created by Van on 12/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseView.h"

@class Ragdoll;

/* Bitmask for the different entities with physics bodies. */
typedef enum : uint8_t {
    YogaColliderTypeWall             = 1,
    YogaColliderTypeBody             = 2,
    YogaColliderTypeArm              = 4,
    YogaColliderTypeLeg              = 8,
} YogaColliderType;

@interface GameView : BaseView
{
    
}

@property (nonatomic, strong) SKPhysicsJointLimit   *mouseJoint;
@property (nonatomic, strong) SKNode                *mouseNode;
@property (nonatomic, strong) NSMutableArray*       mouseJointArray;
@property (nonatomic, strong) Ragdoll*              ragdoll;

@end

