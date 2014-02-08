//
//  CSC470ViewController.m
//  SnailsVsSpiders
//
//  Created by Joe Jones on 11/27/13.
//  Copyright (c) 2013 Joe Jones. All rights reserved.
//

#import "CSC470ViewController.h"
#import "CSC470_Hero.h"
#import "CSC470_spider.h"
#import "CSC470_rocketAnt.h"

@interface CSC470ViewController ()

@end

@implementation CSC470ViewController

///////////////////////////////////
//Hero Stats
///////////////////////////////////
#define HERO_MAIN_IMAGE @"Snail.png"
#define HERO_DEAD_IMAGE @"SnailDead.png"
#define HERO_HEALTH 3
#define HERO_SPEED 2
#define HERO_MOVE_INCREMENT 3
#define HERO_WIDTH 107
#define HERO_HEIGHT 101

///////////////////////////////////
//Spider Stats
///////////////////////////////////
#define SPIDER_MAIN_IMAGE @"Spider.png"
#define SPIDER_DEAD_IMAGE @"SpiderDead.png"
#define SPIDER_HEALTH 1
#define SPIDER_SPEED 0.05
#define SPIDER_WIDTH 79
#define SPIDER_HEIGHT 77

///////////////////////////////////
//Ant Rocket Stats
///////////////////////////////////
#define ANT_ROCKET_MAIN_IMAGE @"AntRocket.png"
#define ANT_ROCKET_DEAD_IMAGE @"AntRocketDead.png"
#define ANT_ROCKET_HEALTH 1
#define ANT_ROCKET_SPEED 0.05
#define ANT_ROCKET_WIDTH 117
#define ANT_ROCKET_HEIGHT 66

///////////////////////////////////
//Level 1 Stats
///////////////////////////////////
#define LEVEL1_BACKGROUND_IMAGE @"SpiderAndSnailBackGround.png"
#define LEVEL1_ENEMY_TYPE @"Spider"
#define LEVEL1_ENEMY_NUMBER 5

///////////////////////////////////
//Level 2 Stats
///////////////////////////////////
#define LEVEL2_BACKGROUND_IMAGE @"background.png"
#define LEVEL2_ENEMY_TYPE @"AntRocket"
#define LEVEL2_ENEMY_NUMBER 5

///////////////////////////////////
//General Constants
///////////////////////////////////
#define ENEMY_OFFSET_1 20
#define ENEMY_OFFSET_2 50
#define END_GAME_SCREEN @"endScreen.png"
#define EXPLOSION_SOUND @"explosion"
#define ROCKET_SOUND @"rocketThrust"

//set up vars
//
@synthesize screenWidth = _screenWidth;
@synthesize screenHeight = _screenHeight;
@synthesize agentArray      = _agentArray;
@synthesize heroObj = _heroObj;

int score = 0;
int level = 0;
int finalScore = 0;
bool gameStop = FALSE;

//start values for move
//
int enemyXValue = 0;
int enemyYValue = 0;

int heroUpMove = 0;
int heroRightMove = 0;

//booleans for move
//
bool upArrowMove = FALSE;
bool downArrowMove = FALSE;
bool rightArrowMove = FALSE;
bool leftArrowMove = FALSE;
 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //set up sounds here
    //
    NSString *rocketSoundIDPath = [[NSBundle mainBundle] pathForResource:ROCKET_SOUND ofType:@"mp3"];
    NSString *enemyExplosionIDPath = [[NSBundle mainBundle] pathForResource:EXPLOSION_SOUND ofType:@"mp3"];
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:rocketSoundIDPath],&rocketSoundID);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) [NSURL fileURLWithPath:enemyExplosionIDPath],&enemyExplosionID);
    
    
    //set up bounds
    //
    self.screenWidth = [[UIScreen mainScreen]applicationFrame].size.width;
    self.screenHeight = [[UIScreen mainScreen]applicationFrame].size.height;
    
    //set up timer
    //
    [self initializeGameTimer];

    
    //create hero here
    //
    self.heroObj = [[CSC470_Hero alloc] initWithFrame: CGRectMake(0.0, 0.0, 101.0, 107.0)];
    self.heroObj.image = [UIImage imageNamed:HERO_MAIN_IMAGE];
    [self.mainContextView addSubview:self.heroObj];
    [self restartGame];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//start game method clear any levels reset back to zero
//
-(void)restartGame
{
    //clean up screen, reset vars and then push score to reciever
    //
    level = 0;
    score = 0;
    
    //start values for move
    //
    enemyXValue = 0;
    enemyYValue = 0;
    heroUpMove = 0;
    heroRightMove = 0;
    
    self.heroObj.center = CGPointMake(0, 0);
    self.heroObj.hidden = FALSE;
    self.heroObj.health = HERO_HEALTH;
    
    self.upButtonOutlet.hidden = FALSE;
    self.downButtonOutlet.hidden = FALSE;
    self.rightButtonOutlet.hidden = FALSE;
    self.leftButtonOutlet.hidden = FALSE;
    self.scoreLabel.hidden = FALSE;
    self.scoreLabelHeader.hidden = FALSE;
    self.healthLabelHeader.hidden = FALSE;
    self.lifeTotal.hidden = FALSE;
    
    [self clearLevel];
    
    self.restartGameButton.hidden = TRUE;
    
    self.mainContextView.image = [UIImage imageNamed:LEVEL1_BACKGROUND_IMAGE];
    
    gameStop = FALSE;
}

//end game method segue to end screen
//
-(void)endGame
{
    gameStop = TRUE;
    
    //clean up screen, reset vars and then push score to reciever
    //
    level = 0;
    
    //start values for move
    //
    enemyXValue = 0;
    enemyYValue = 0;
    heroUpMove = 0;
    heroRightMove = 0;
    
    //hide hero and buttons
    //
    self.heroObj.center = CGPointMake(0, 0);
    self.heroObj.hidden = TRUE;
    
    self.upButtonOutlet.hidden = TRUE;
    self.downButtonOutlet.hidden = TRUE;
    self.rightButtonOutlet.hidden = TRUE;
    self.leftButtonOutlet.hidden = TRUE;
    self.scoreLabel.hidden = TRUE;
    self.scoreLabelHeader.hidden = TRUE;
    self.healthLabelHeader.hidden = TRUE;
    self.lifeTotal.hidden = TRUE;
    
    
    [self clearLevel];
    
    self.agentArray = nil;
    
    self.restartGameButton.hidden = FALSE;
    
    self.mainContextView.image = [UIImage imageNamed:END_GAME_SCREEN];
    
}


//handle creature creation and then build an NSMutable array
//
- (void)buildEnemies:(AgentType)passedAgentType
                       numberOf:(int)passedNumberOfEnemies
                    enemyHealth:(int)passedEnemyHealth
                     enemySpeed:(float)passedEnemySpeed
                     enemyImage:(UIImage*)passedEnemyImage
              enemyExpiredImage:(UIImage*)passedExpiredEnemyImage
    isHorizontalRandomPlacement:(bool)passedIsHorizontalPlacement
                levelToBePlaced:(UIImageView*)passedLevel
                     enemyFrame:(CGRect)passedCGRect
{
    NSMutableArray *arrayOfEnemies = [[NSMutableArray alloc] init];
    
    CGFloat randomX = 0;
    CGFloat randomY = 0;
    CGPoint enemyPostion;
    
    for(int i = 0; i < passedNumberOfEnemies; i++)
    {
        //set up random location here
        //
        if(passedIsHorizontalPlacement)
        {
            randomX = (CGFloat) (arc4random() % ((int) self.screenHeight-ENEMY_OFFSET_1));
            randomY = self.screenWidth-ENEMY_OFFSET_2;
        }
        else
        {
            randomX = self.screenHeight-ENEMY_OFFSET_2;
            randomY = (CGFloat) (arc4random() % ((int) self.screenWidth-ENEMY_OFFSET_1));
            
        }
        
        //build them creatures
        //
        if(passedAgentType == ROCKET_ANT)
        {
            CSC470_rocketAnt *enemy = [[CSC470_rocketAnt alloc] initWithFrame:passedCGRect];
            
            enemy.health = passedEnemyHealth;
            enemy.speed = passedEnemySpeed;
            enemy.imageToUse = passedEnemyImage;
            enemy.image = passedEnemyImage;
            enemy.expiredImageToUse = passedExpiredEnemyImage;
            
            //set location of the enemy
            //
            enemyPostion = CGPointMake(randomX, randomY);
            enemy.center = enemyPostion;
            
            //now add them to the level layer
            //
            [passedLevel addSubview:enemy];
            
            //now add them
            //
            [arrayOfEnemies addObject:enemy];
            
            
        }
        else
        {
            CSC470_spider *enemy = [[CSC470_spider alloc] initWithFrame:passedCGRect];
            
            enemy.health = passedEnemyHealth;
            enemy.speed = passedEnemySpeed;
            enemy.imageToUse = passedEnemyImage;
            enemy.image = passedEnemyImage;
            enemy.expiredImageToUse = passedExpiredEnemyImage;
            
            //set location of the enemy
            //
            enemyPostion = CGPointMake(randomX, randomY);
            enemy.center = enemyPostion;
            
            //now add them to the level layer
            //
            [passedLevel addSubview:enemy];
            
            //now add them
            //
            [arrayOfEnemies addObject:enemy];
        }

        
    }
    
     self.agentArray =  arrayOfEnemies;
}


//This method automoves the enemy
//
- (void) enemyAutoMove:(int)passedLevel
                xValue:(int)passedXValue
                yValue:(int)passedYValue
{
    for(CSC470_Agent *agent in self.agentArray)
    {
        if(passedLevel == 1)
        {
            [(CSC470_spider *)agent autoMovement:passedXValue yValue:passedYValue];
        }
        else
        {
            [(CSC470_rocketAnt *)agent autoMovement:passedXValue yValue:passedYValue];
        }
    }
}

//handle level creation
//
- (void) levelManager:(int)passedLevel
{
    if(passedLevel == 1)
    {
        //ok the starting level so lets build it
        //
        self.agentArray = nil;
        enemyXValue = 0;
        enemyYValue = 0;
        
        
        [self buildEnemies:SPIDER numberOf:3 enemyHealth:SPIDER_HEALTH enemySpeed:SPIDER_SPEED enemyImage:[UIImage imageNamed:SPIDER_MAIN_IMAGE] enemyExpiredImage:[UIImage imageNamed:SPIDER_DEAD_IMAGE] isHorizontalRandomPlacement:NO levelToBePlaced:self.mainContextView enemyFrame:CGRectMake(0.0, 0.0, SPIDER_WIDTH, SPIDER_HEIGHT)];
        
        self.mainContextView.image = [UIImage imageNamed:LEVEL1_BACKGROUND_IMAGE];
        
    }
    else if (passedLevel == 2)
    {
        
        //clear level first
        //
        [self clearLevel];
        
        self.agentArray = nil;
        enemyXValue = 0;
        enemyYValue = 0;
        
        [self buildEnemies:ROCKET_ANT numberOf:4 enemyHealth:ANT_ROCKET_HEALTH enemySpeed:ANT_ROCKET_SPEED enemyImage:[UIImage imageNamed:ANT_ROCKET_MAIN_IMAGE] enemyExpiredImage:[UIImage imageNamed:ANT_ROCKET_DEAD_IMAGE] isHorizontalRandomPlacement:NO levelToBePlaced:self.mainContextView enemyFrame:CGRectMake(0.0, 0.0, ANT_ROCKET_WIDTH, ANT_ROCKET_HEIGHT)];
        
        self.mainContextView.image = [UIImage imageNamed:LEVEL2_BACKGROUND_IMAGE];

    }
    
}



//this is a utility method to remove enemies from level view
//
-(void) clearLevel
{
    for(CSC470_Agent *agent in self.agentArray)
    {
        [agent removeFromSuperview];
    }
}

//check to see if the enemy has gone off screen
//
-(void) enemyOffScreenCheck
{
    for(CSC470_Agent *agent in self.agentArray)
    {
      if(agent.center.x < -200)
      {
          agent.health = 0;
      }
    }
    
}

//check to see if the enemies are all dead
//
-(BOOL) enemiesAllDeadCheck
{
    BOOL allDead = TRUE;
    
    for(CSC470_Agent *agent in self.agentArray)
    {
        if(agent.health > 0)
        {
            allDead = FALSE;
        }
        else
        {
            [agent noHeathLeft];
        }
    }
    
    return allDead;
}

//check if any enemy has collided with the hero
//
- (BOOL) hasCollisionOccured
{
    BOOL collision = FALSE;
    
    for(CSC470_Agent *agent in self.agentArray)
    {
        //only check if the enemy has more that zero health
        //
        if(agent.health > 0)
        {
            if(CGRectIntersectsRect([self.heroObj getFrameOfAgent], [agent getFrameOfAgent]))
            {
                //ok first decrement enemy health
                //
                agent.health = agent.health-1;
                AudioServicesPlaySystemSound(enemyExplosionID);
                self.heroObj.health = self.heroObj.health-1;
                collision = TRUE;
                NSLog(@"Collision");
            }
        }
    }
    
    return collision;
}


//handle game state and turn
//
//Create the game timer to keep us on track
//
- (void) initializeGameTimer
{
    if(gameTimer == nil)
    {
        gameTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameTurnLogic:)];
    }
    
    gameTimer.frameInterval = 3;
    
    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    
}

//handle the game logic
//
- (void) gameTurnLogic:(CADisplayLink *)gameTimer
{
    if(!gameStop)
    {
    //update the score
    //
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score++];
    
    //move the enemies
    //
    enemyXValue++;
    enemyYValue++;
    
    //move the enemies
    //
    [self enemyAutoMove:level xValue:enemyXValue yValue:enemyYValue];
    
    //check if enemies are off screen
    //
    [self enemyOffScreenCheck];
    
    //check if collision has occured
    //
    [self hasCollisionOccured];
    
    //update health of hero
    //
    self.lifeTotal.text = [NSString stringWithFormat:@"%d", self.heroObj.health];
    
    //hero movement logic
    // 
    if((self.heroObj.center.x > self.screenHeight))
    {
        self.heroObj.center =  CGPointMake(self.screenHeight,self.heroObj.center.y);
        heroRightMove = 0;
    }
    else if(self.heroObj.center.y > self.screenWidth)
    {
        self.heroObj.center =  CGPointMake(self.heroObj.center.x,self.screenWidth);
        heroUpMove = 0;
    }
    else if(self.heroObj.center.x < 0)
    {
        self.heroObj.center =  CGPointMake(0,self.heroObj.center.y);
        heroRightMove = 0;
    }
    else if(self.heroObj.center.y < 0)
    {
        self.heroObj.center =  CGPointMake(self.heroObj.center.x,0);
        heroUpMove = 0;
    }
    
    //vertical movement logic
    //
    if((upArrowMove || downArrowMove))
    {
        heroUpMove = +HERO_MOVE_INCREMENT;
        
        if(upArrowMove)
        {
            heroUpMove = heroUpMove * -1;
        }
        
        //ok move vertically
        //
        self.heroObj.center =  CGPointMake(self.heroObj.center.x,(self.heroObj.center.y + heroUpMove));        
    }

    
    //horizontal movement logic for the hero
    //
    if((rightArrowMove || leftArrowMove))
    {
        heroRightMove = +HERO_MOVE_INCREMENT;
        
        if(leftArrowMove)
        {
            heroRightMove = heroRightMove * -1;
        }


        self.heroObj.center =  CGPointMake(self.heroObj.center.x + heroRightMove,self.heroObj.center.y);
    }
    
    
    //if enemies are all dead then update the level or end the game
    //if there are no more levels
    //
    if([self enemiesAllDeadCheck])
    {
        //update level
        //
        if(level < 2)
        {
            level++;
            [self levelManager:level];
        }
        else
        {
            [self endGame];
        }
    }
    
    //if hero is dead end the game
    //
    if(self.heroObj.health <= 0)
    {
        [self endGame];
    }
    }
}

//handle button inputs
//
- (IBAction)restartGameAction:(id)sender
{
    [self restartGame];
}

- (IBAction)upArrow:(id)sender
{
    upArrowMove = FALSE;
    NSLog(@"Snail Y %f", self.heroObj.center.y);
}

- (IBAction)downArrow:(id)sender
{
    downArrowMove = FALSE;    
    NSLog(@"Snail Y %f", self.heroObj.center.y);
}

- (IBAction)rightArrow:(id)sender
{
    rightArrowMove = FALSE;    
    NSLog(@"Snail X %f", self.heroObj.center.x);
}

- (IBAction)leftArrow:(id)sender
{
    leftArrowMove = FALSE;
    NSLog(@"Snail X %f", self.heroObj.center.x);
}

- (IBAction)upArrowMove:(id)sender
{
    upArrowMove = TRUE;
    AudioServicesPlaySystemSound(rocketSoundID);
}

- (IBAction)downArrowMove:(id)sender
{
    downArrowMove = TRUE;
    AudioServicesPlaySystemSound(rocketSoundID);
}

- (IBAction)rightArrowMove:(id)sender
{
    rightArrowMove = TRUE;
    AudioServicesPlaySystemSound(rocketSoundID);
}

- (IBAction)leftArrowMove:(id)sender
{
    leftArrowMove = TRUE;
    AudioServicesPlaySystemSound(rocketSoundID);
}
@end
