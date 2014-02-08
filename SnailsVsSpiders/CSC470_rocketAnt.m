//
//  CSC470_rocketAnt.m
//  SnailsVsSpiders
//
//  Created by Joe Jones on 11/27/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "CSC470_rocketAnt.h"

@implementation CSC470_rocketAnt

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//rocket ant moves in straight line
//
-(void)autoMovement:(CGFloat)passedXValue yValue:(CGFloat) passedYValue
{
    //only look at the x value
    //
    self.center = CGPointMake((self.center.x - (self.speed*passedXValue)), self.center.y);
}

@end
 