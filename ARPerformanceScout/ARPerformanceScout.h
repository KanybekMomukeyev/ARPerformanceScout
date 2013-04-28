//
//  ARPerformanceScout.h
//  FileManagerTest
//
//  Created by Claudiu-Vlad Ursache on 27.04.13.
//  Copyright (c) 2013 Claudiu-Vlad Ursache. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ARpSMeasureBlock)(void);
typedef void (^ARpSCompletionBlock)(NSTimeInterval executionTime);

@interface ARPerformanceScout : NSObject
@end

///--------------------
/// @name ARpS API
///--------------------

/**
 Starts an internal timer when called. To be used with `ARpS_stopTimerAndLog()`.
 */
extern void inline ARpS_startTimer();

/**
 Logs out the time difference from the last `ARpS_startTimer()` call.
 */
extern void inline ARpS_stopTimerAndLog();

/**
 Block the thread the function is being called on for a number of seconds.
 
 @param seconds The number of seconds to block the thread for.
 */
extern void inline ARpS_blockThread(NSTimeInterval seconds);

/**
 Measure the time taken to run a block of code.
 
 @param measureBlock The block of code to be run and measured.
 */
extern void inline ARpS_measure(ARpSMeasureBlock measureBlock);

/**
 Measure the time taken to run a block of code and run a completion block afterwards.
 
 @param measureBlock The block of code to be run and measured.
 @param completionBlock A block of code to be run after `measureBlock` is finished. It contains the time taken to run `measureBlock`.
 */
extern void inline ARpS_measureAndRunCompletionBlock(ARpSMeasureBlock measureBlock, ARpSCompletionBlock completionBlock);

#ifndef DEBUG
#warning You are including this code with a non-DEBUG configuration setup. ARPerformanceScout code should not be delivered in production.
#endif
