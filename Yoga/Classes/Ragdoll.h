//
//  RagDoll.h
//  Yoga
//
//  Created by Van on 16/07/2013.
//  Copyright (c) 2013 ustwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BodyShapeNode.h"

@interface Ragdoll : NSObject
{
    BodyShapeNode*        leftHand;
    BodyShapeNode*        rightHand;
}

@property (nonatomic, strong) NSMutableArray*       draggableNodes;
@property (nonatomic, weak) SKScene*                scene;

- (void)createRagdollAtPosition:(CGPoint)position inScene:(SKScene*)scene;
- (BodyShapeNode*)findLimbAtPosition:(CGPoint)point;

@end
