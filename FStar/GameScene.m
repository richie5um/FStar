//
//  GameScene.m
//  FStar
//
//  Created by RichS on 21/05/2018.
//  Copyright © 2018 RichS. All rights reserved.
//

#import "GameScene.h"
#import "UIColor+FlatColors.h"

@implementation GameScene {
    NSTimeInterval _lastUpdateTime;
    SKShapeNode *_spinnyNode;
    SKLabelNode *_label;
}

- (void)sceneDidLoad {
    // Setup your scene here
    
    // Initialize update time
    _lastUpdateTime = 0;
    
    // Get label node from scene and store it for use later
    SKNode* background = [self childNodeWithName:@"//background"];
    
    SKShapeNode* backgroundColor = [SKShapeNode shapeNodeWithRect:CGRectMake(-self.size.width/2, -self.size.height/2, self.size.width, self.size.height) cornerRadius:0]; //20];
    backgroundColor.fillColor = [UIColor flatNephritisColor];
    backgroundColor.strokeColor = [UIColor flatEmeraldColor];
    [background addChild:backgroundColor];
    
    for(int i = 1; i <= 9; ++i) {
        SKNode* tick = (SKNode *)[self childNodeWithName:[NSString stringWithFormat:@"//tick%d", i]];
        
        SKShapeNode* tickBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(50, 50) cornerRadius:10];
        tickBox.name = [NSString stringWithFormat:@"tickBox%d", i];
        tickBox.strokeColor = [SKColor whiteColor];
        tickBox.fillColor = [SKColor clearColor];
        [tick addChild:tickBox];
    }
    
    self.userInteractionEnabled = YES;
}


- (void)touchDownAtPoint:(CGPoint)pos {
    SKNode* touchNode = [self nodeAtPoint:pos];
    NSLog(@"TouchNode: %@", touchNode.name);
    
    if ([touchNode.name hasPrefix:@"tickBox"]) {
        SKNode* node = [self childNodeWithName:@"//tick"];
        [node removeFromParent];
        
//        SKShapeNode* tickBox = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(30, 30) cornerRadius:10];
//        tickBox.name = @"tick";
//        tickBox.strokeColor = [SKColor whiteColor];
//        tickBox.fillColor = [SKColor whiteColor];
//        [touchNode addChild:tickBox];
        
        SKSpriteNode* tick = [SKSpriteNode spriteNodeWithImageNamed:@"tick"];
        tick.name = @"tick";
        tick.xScale = 0.4;
        tick.yScale = 0.4;
        tick.alpha = 0;
        [touchNode addChild:tick];
        
        [tick runAction:[SKAction fadeInWithDuration:0.3]];
    } else if ([touchNode.name hasPrefix:@"share"]) {
        [self shareScreenshot];
    } else {
        SKNode* node = [self childNodeWithName:@"//tick"];
        [node removeFromParent];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        [self touchDownAtPoint:[t locationInNode:self]];
    }
}

-(void)shareScreenshot {
    SKNode* shareNode = [self childNodeWithName:@"//share"];
    shareNode.alpha = 0;
    SKTexture* tex = [self.scene.view textureFromNode:self];
    shareNode.alpha = 0.3;
    
    UIImage *image = [UIImage imageWithCGImage:tex.CGImage];
    
    NSData* imageData = UIImagePNGRepresentation(image);
    UIActivityViewController* activity = [[UIActivityViewController alloc] initWithActivityItems:@[imageData] applicationActivities:nil];
    
    UIViewController *viewController = self.view.window.rootViewController;
    [viewController presentViewController:activity animated:YES completion:nil];
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (_lastUpdateTime == 0) {
        _lastUpdateTime = currentTime;
    }
    
    // Calculate time since last update
    CGFloat dt = currentTime - _lastUpdateTime;
    
    // Update entities
    for (GKEntity *entity in self.entities) {
        [entity updateWithDeltaTime:dt];
    }
    
    _lastUpdateTime = currentTime;
}

@end
