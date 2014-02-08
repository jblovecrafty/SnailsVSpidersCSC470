//
//  CSC470_Agent.h
//  SnailsVsSpiders
//
//  Created by Joe Jones on 11/27/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSC470_Agent : UIImageView

//set up the properties here
//
@property (nonatomic) int health;
@property (nonatomic) float speed;
@property (nonatomic, weak) UIImage *imageToUse;
@property (nonatomic, weak) UIImage *expiredImageToUse;


//set up the methods here
//
-(void)autoMovement:(CGFloat)passedXValue yValue:(CGFloat) passedYValue;

-(CGRect)getFrameOfAgent;

-(void)noHeathLeft;


@end
