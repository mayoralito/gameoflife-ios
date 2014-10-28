//
//  BoardGame.h
//  GameOfLife
//
//  Created by amayoral on 10/27/14.
//  Copyright (c) 2014 adrianmayoral. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoardGame : NSObject
{
    NSInteger           boardLimitSize;
    NSMutableArray*     __playerBoard;
}

@property (nonatomic) NSInteger                 boardLimitSize;
@property (nonatomic, strong) NSMutableArray*   __playerBoard;

/** init @override */
- (id)init;

/** Called each time the game is alive. */
- (void)didGameStarter:(void (^)(void))afterStartGame;

/** Create an empty generation data. */
- (NSArray *)generateEmptyBoardData;

@end
