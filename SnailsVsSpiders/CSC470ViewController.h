//
//  CSC470ViewController.h
//  SnailsVsSpiders
//
//  Created by Joe Jones on 11/27/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "QuartzCore/CADisplayLink.h"
#import "CSC470_Hero.h"


//set up agent enums here
//
typedef enum AgentType : NSUInteger
{
    SPIDER,
    HERO,
    ROCKET_ANT
} AgentType;


@interface CSC470ViewController : UIViewController
{
    CADisplayLink *gameTimer;
    SystemSoundID enemyExplosionID;
    SystemSoundID rocketSoundID;
}

@property(nonatomic) CGFloat screenWidth;
@property(nonatomic) CGFloat screenHeight;
@property (nonatomic, strong) NSMutableArray *agentArray;
@property (nonatomic, strong) CSC470_Hero *heroObj;

@property (weak, nonatomic) IBOutlet UIButton *restartGameButton;
@property (weak, nonatomic) IBOutlet UILabel *healthLabelHeader;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabelHeader;

@property (weak, nonatomic) IBOutlet UILabel *lifeTotal;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIButton *upButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *downButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *rightButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *leftButtonOutlet;


//Actions
//
- (IBAction)restartGameAction:(id)sender;

- (IBAction)upArrow:(id)sender;
- (IBAction)downArrow:(id)sender;
- (IBAction)rightArrow:(id)sender;
- (IBAction)leftArrow:(id)sender;


- (IBAction)upArrowMove:(id)sender;
- (IBAction)downArrowMove:(id)sender;
- (IBAction)rightArrowMove:(id)sender;
- (IBAction)leftArrowMove:(id)sender;

//hold the image view for the action
//
@property (weak, nonatomic) IBOutlet UIImageView *mainContextView;
@end
