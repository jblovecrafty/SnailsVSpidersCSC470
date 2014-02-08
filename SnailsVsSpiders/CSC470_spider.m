//
//  CSC470_spider.m
//  SnailsVsSpiders
//
//  Created by Joe Jones on 11/27/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "CSC470_spider.h"

@implementation CSC470_spider

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

//overide the auto movement
//
-(void)autoMovement:(CGFloat)passedXValue yValue:(CGFloat) passedYValue
{
    //run the x and y value thru the sin function and multiply by speed
    //
    passedXValue = (self.center.x - self.speed*(sinf(passedXValue)) - self.speed*passedXValue);
    passedYValue = (self.center.y + 30*(sinf(passedYValue)));
    
    self.center = CGPointMake(passedXValue, passedYValue);
}

@end
