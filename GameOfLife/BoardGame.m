//
//  BoardGame.m
//  GameOfLife
//
//  Created by amayoral on 10/27/14.
//  Copyright (c) 2014 adrianmayoral. All rights reserved.
//

#import "BoardGame.h"

@implementation BoardGame
{
    
}

@synthesize boardLimitSize, __playerBoard;

- (id)init {
    if (self = [super init])
    {
        // Default values
        boardLimitSize = 25;
        __playerBoard = [[NSMutableArray alloc] initWithCapacity:boardLimitSize];
        
    }
    return self;
}

- (void)didGameStarter:(void (^)(void))afterStartGame {
    
    // Start new Generation each time game starter (into the loop)
    NSMutableArray* __newGen = (NSMutableArray *)[self generateEmptyBoardData];
    
    // Start new generation info
    [__playerBoard enumerateObjectsUsingBlock:^(id obj, NSUInteger idy, BOOL *stop) {
        __block NSInteger pos_y = idy;

        [obj enumerateObjectsUsingBlock:^(id obj_x, NSUInteger idx, BOOL *stop) {
            
            NSInteger pos_x = idx;
            NSUInteger current_state = 0;
            // Get neighbours
            NSUInteger totalNeighbours = [self allNeighboursAt:pos_y y:pos_x];
            
            if(totalNeighbours > 0 ) {
                //NSLog(@"check: [%i][%i] %i", pos_y, pos_x, [obj_x integerValue]);
            }
            
            //
            
            // If current state is DEAD
            if ([obj_x integerValue] == 0) {
                current_state = ( (totalNeighbours == 2) || (totalNeighbours == 3) ) ? 1 : 0;
                
                [[__newGen objectAtIndex:pos_y] replaceObjectAtIndex:pos_x withObject:[NSNumber numberWithInteger:current_state]];
                
            } else {
                // If is ALIVE
                current_state = (totalNeighbours == 3) ? 1 : 0;
                
                [[__newGen objectAtIndex:pos_y] replaceObjectAtIndex:pos_x withObject:[NSNumber numberWithInteger:current_state]];
            }
            
        }];
        
    }];
    
    __playerBoard = [__newGen mutableCopy];
    
    if(afterStartGame) {
        afterStartGame();
    }
    
}

- (NSArray *)generateEmptyBoardData {
    
    NSInteger x;
    NSInteger y;
    
    NSMutableArray *emptyBoard = [[NSMutableArray alloc] initWithCapacity:boardLimitSize];
    
    for(y = 0; y < boardLimitSize; y++) {
        [emptyBoard insertObject:[[NSMutableArray alloc] initWithCapacity:boardLimitSize] atIndex:y];
        NSMutableArray *innerArray = [[NSMutableArray alloc] initWithCapacity:boardLimitSize];
        for(x = 0; x < boardLimitSize; x++) {
            [innerArray insertObject:[NSNumber numberWithInt:0] atIndex:x];
        }
        [emptyBoard replaceObjectAtIndex:y withObject:innerArray];
    }
        
        
    return emptyBoard;
    
}

- (NSInteger)allNeighboursAt:(NSInteger)x y:(NSInteger)y {
    
    NSMutableArray *aliveNeighbours = [[NSMutableArray alloc] init];
    NSMutableArray *neighbours = [[NSMutableArray alloc] init];
    NSArray *position = @[
                           [NSNumber numberWithInt:x],
                           [NSNumber numberWithInt:y]
                           ];
    
    // Check aside neighbours
    neighbours = [[self addNeighbourAtPosition:-1 y:-1 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    neighbours = [[self addNeighbourAtPosition:-1 y:0 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    neighbours = [[self addNeighbourAtPosition:-1 y:1 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    
    neighbours = [[self addNeighbourAtPosition:0 y:-1 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    neighbours = [[self addNeighbourAtPosition:0 y:1 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    
    neighbours = [[self addNeighbourAtPosition:1 y:-1 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    neighbours = [[self addNeighbourAtPosition:1 y:0 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    neighbours = [[self addNeighbourAtPosition:1 y:1 withNeighboursData:neighbours currentPosition:position] mutableCopy];
    
    for (id obj in neighbours) {
        if ([obj integerValue] == 1) {
            [aliveNeighbours addObject:obj];
        }
    }
    
    
    return [aliveNeighbours count];
}

- (NSArray *)addNeighbourAtPosition:(NSInteger)x
                                  y:(NSInteger)y
                 withNeighboursData:(NSMutableArray *)neighboursData
                    currentPosition:(NSArray *)position {
    
    NSInteger neighbour = [self neighbourAtPosition:x y:y position:position];
    if(neighbour != -1) {
        // Add new element.
        [neighboursData addObject:[NSNumber numberWithInteger:neighbour]];
    }
    
    return neighboursData;
}

- (NSInteger )neighbourAtPosition:(NSInteger)x y:(NSInteger)y position:(NSArray *)position {
    
    x = (x) + [[position objectAtIndex:0] intValue];
    y = (y) + [[position objectAtIndex:1] intValue];
    
    // Validate not valid rows (in board)
    if (x < 0 || y < 0 || x >= __playerBoard.count || y >= __playerBoard.count) {
        return -1;
    }
    
    if( [__playerBoard objectAtIndex:x] ) {

        return [[[__playerBoard objectAtIndex:x] objectAtIndex:y] integerValue];
        
    }
    
    
    return -1;
}


/**
 * Test data into console
 */
- (void)testRunArray {
    // We use fast enumeration to keep track index also have more controll about our loop.
    [__playerBoard enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        __block NSInteger pos_y = idx;
        
        [obj enumerateObjectsUsingBlock:^(id obj_x, NSUInteger idx, BOOL *stop) {
            NSInteger pos_x = idx;
            NSLog(@"[%li][%li] = %i", (long)pos_y, (long)pos_x, [obj_x integerValue]);
        }];
        
        NSLog(@"\n");
        
    }];
}

@end
