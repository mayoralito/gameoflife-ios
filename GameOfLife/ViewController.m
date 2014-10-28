//
//  ViewController.m
//  GameOfLife
//
//  Created by amayoral on 10/27/14.
//  Copyright (c) 2014 adrianmayoral. All rights reserved.
//

#import "ViewController.h"
#import "BoardGame.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()
{
    BoardGame*          __newGame;
    NSMutableArray*     __localData;
    
    int                 current_x;
    int                 current_y;
    
    float temp;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __localData = [[NSMutableArray alloc] init];
    current_x   = 0;
    current_y   = 0;
    
    self.title = @"Game Of Life";
    
    // Create the table board game on the screen.
    [self createBoard];
    
    /**
     * Start data of game
     */
    __newGame = [[BoardGame alloc] init];
    
    [__newGame setBoardLimitSize:64];
    
    [self startDefaultGeneration];
    
    // Start infinite loop of app.
    [NSTimer scheduledTimerWithTimeInterval:0.5f
                                     target:self
                                   selector:@selector(willCheckTurnLive:)
                                   userInfo:nil
                                    repeats:YES];
    
    temp = 0;
}

- (void)willCheckTurnLive: (NSTimer *) timer{
    
    
    
    [__newGame didGameStarter:^{
        
        //NSLog(@"didGameStarter!");
        
        temp += timer.timeInterval;
        
        // Update local data...
        __localData = [__newGame.__playerBoard mutableCopy];
        
        // When data ready: reload data of collection
        [_collectionView reloadData];
        
        // Stop execution after 5 minutes
        if( temp >= 350.0f){
            [timer invalidate];
        }
        
    }];
    
    
}

/**
 * Initial configuration
 */
- (void)startDefaultGeneration {
    
    __localData = [NSMutableArray arrayWithCapacity:__newGame.boardLimitSize];
    
    // Start an empyt game
    
    __localData = (NSMutableArray *)[__newGame generateEmptyBoardData];
    long posIni = lroundf(__newGame.boardLimitSize/2);
    
    // Define initial positions [live]
    NSMutableArray *
    innerArray = [[__localData objectAtIndex:posIni + 0] mutableCopy];
    [innerArray replaceObjectAtIndex:(posIni + 0) withObject:[NSNumber numberWithInt:1]];
    [__localData replaceObjectAtIndex:(posIni + 0) withObject:innerArray];
    
    innerArray = [[__localData objectAtIndex:posIni + 0] mutableCopy];
    [innerArray replaceObjectAtIndex:(posIni + 1) withObject:[NSNumber numberWithInt:1]];
    [__localData replaceObjectAtIndex:(posIni + 0) withObject:innerArray];
    
    innerArray = [[__localData objectAtIndex:posIni + 1] mutableCopy];
    [innerArray replaceObjectAtIndex:(posIni - 0) withObject:[NSNumber numberWithInt:1]];
    [__localData replaceObjectAtIndex:(posIni + 1) withObject:innerArray];
    
    innerArray = [[__localData objectAtIndex:posIni + 1] mutableCopy];
    [innerArray replaceObjectAtIndex:(posIni + 1) withObject:[NSNumber numberWithInt:1]];
    [__localData replaceObjectAtIndex:(posIni + 1) withObject:innerArray];
    
    
    // Asign first generation to our main object.
    __newGame.__playerBoard = [__localData mutableCopy];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createBoard {
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Layout configuration
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0.0f;
    layout.minimumInteritemSpacing = 0.0f;
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview: _collectionView];
}


#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [__localData count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [__localData count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier"
                                                                           forIndexPath:indexPath];
    // Default cell info
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.shouldRasterize = YES;
    cell.layer.cornerRadius = 1;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    
    // Check if 'data' has 1 and turn on.
    if( [[[__localData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] intValue] == 1 ) {
        
        cell.backgroundColor = [UIColor orangeColor];
        
    }else{
        
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    long sqrtVal = __newGame.boardLimitSize; //sqrt(__newGame.boardLimitSize);
    long currentWidth = _collectionView.frame.size.width / sqrtVal;
    long currentHeight = currentWidth;
    
    return CGSizeMake(currentWidth, currentHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}



@end
