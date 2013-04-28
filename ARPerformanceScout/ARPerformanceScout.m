//
//  ARPerformanceScout.m
//  FileManagerTest
//
//  Created by Claudiu-Vlad Ursache on 27.04.13.
//  Copyright (c) 2013 Claudiu-Vlad Ursache. All rights reserved.
//

#import "ARPerformanceScout.h"

static NSDate *_timerStartDate = nil;
static BOOL _timerStarted = NO;

@interface ARPerformanceScout()
+ (void)startTimer;
+ (void)stopTimerAndLog;
+ (void)measure:(ARpSMeasureBlock)block;
+ (void)measure:(ARpSMeasureBlock)block completion:(ARpSCompletionBlock)completion;
+ (void)blockCurrentThreadForNumberOfSeconds:(NSTimeInterval)seconds;
@end

@implementation ARPerformanceScout

#pragma mark - Blocking

+ (void)blockCurrentThreadForNumberOfSeconds:(NSTimeInterval)seconds {
    [NSThread sleepForTimeInterval:seconds];
}

#pragma mark - Execution time measurements

+ (void)measure:(ARpSMeasureBlock)block {
    [ARPerformanceScout measure:block completion:^(NSTimeInterval executionTime) {
        [ARPerformanceScout logMeasureExecutionTimeResult:executionTime];
    }];
}

+ (void)measure:(ARpSMeasureBlock)block completion:(ARpSCompletionBlock)completion {
    NSDate *startDate = [NSDate date];
    block();
    NSDate *finishDate = [NSDate date];
    NSTimeInterval executionTime = [finishDate timeIntervalSinceDate:startDate];
    completion(executionTime);
}

#pragma mark - Time profiling methods

+ (void)startTimer {
    if (_timerStarted) {
        return;
    }
    _timerStarted = YES;
    _timerStartDate = [NSDate date];
}

+ (void)stopTimerAndLog {
    if (NO == _timerStarted) {
        return;
    }
    
    NSTimeInterval runningTime = [[NSDate date] timeIntervalSinceDate:_timerStartDate];
    [ARPerformanceScout logStopTimerResult:runningTime];
    _timerStarted = NO;
}

#pragma mark - Logging methods

+ (void)logStopTimerResult:(NSTimeInterval)runningTimeInterval {
    printf("\n≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌\n⊛ ARPerformanceScout ⊛\n\n✔ Timed: %fs\n≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌\n",runningTimeInterval);
}

+ (void)logMeasureExecutionTimeResult:(NSTimeInterval)executionTime {    
    printf("\n≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌\n⊛ ARPerformanceScout ⊛\n\n✔ Measured: %fs\n≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌\n",executionTime);
}

#pragma mark - Inline C functions API

void inline ARpS_startTimer() {
    [ARPerformanceScout startTimer];
}

void inline ARpS_stopTimerAndLog() {
    [ARPerformanceScout stopTimerAndLog];
}

void inline ARpS_blockThread(NSTimeInterval seconds) {
    [ARPerformanceScout blockCurrentThreadForNumberOfSeconds:seconds];
}

void inline ARpS_measure(ARpSMeasureBlock measureBlock) {
    [ARPerformanceScout measure:measureBlock];
}

void inline ARpS_measureAndRunCompletionBlock(ARpSMeasureBlock measureBlock, ARpSCompletionBlock completionBlock) {
    [ARPerformanceScout measure:measureBlock completion:completionBlock];
}

@end
