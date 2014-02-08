//
//  CSC470_Hero.m
//  SnailsVsSpiders
//
//  Created by Joe Jones on 11/27/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "CSC470_Hero.h"

@implementation CSC470_Hero

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

-(void)autoMovement:(CGFloat)passedXValue yValue:(CGFloat) passedYValue
{
    //only look at the x and y value
    //
    self.center = CGPointMake((self.center.x - (self.speed*passedXValue)), (self.center.y - (self.speed*passedYValue)));
}

@end
