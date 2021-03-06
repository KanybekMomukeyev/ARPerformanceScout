<p align="center" >
  <img src="https://raw.github.com/ursachec/ARPerformanceScout/master/ARPerformanceScout.png" alt="ARPerfomanceScout" title="ARPerfomanceScout">
</p>

**⊛ ARPerformanceScout ⊛** is a slim tool for discovering Objective-C performance bottlenecks.

- Determine if a piece of code is blocking the UI.
- Test performance when code execution jumps from one thread to another.
- Experiment with multi-threaded programming.

## Warning

This tool is in the very early stages of the development, so things will break and do random crazy stuff. Still trying to get the API right and then push it in a single direction. If you have any ideas, opinions or rants [I'd love to hear them](https://github.com/ursachec/ARPerformanceScout#contact)!

## How to get started

- [Download ARPerfomanceScout](https://github.com/ursachec/ARPerformanceScout/archive/0.0.1.zip) and try out the examples
- Read this documentation


## Usage

### ﹆ Measure running time

In the source code:

```
/* Measures the time taken to run a piece of code on the current thread */

ARpS_measure(^{
        [self writeSomethingToAFile_blocksTheUI];
    });
```

The resulting log message:
 
```
≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
⊛ ARPerformanceScout ⊛

✔ Measured: 2.512919s
≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
```
 


### ﹆ Blocking a thread

When in doubt if a method is blocking the UI or not, calling `ARpS_blockThread()` makes it obvious very quickly.
 
 ```
 /* blocks the current thread for 3 seconds */
 ARpS_blockThread(3);
 ```

### ﹆ Timing events

When two pieces of code from very different parts of the app need to be timed, `ARpS_startTimer()` and `ARpS_stopTimerAndLog()` can help.

Calling the two functions:

```
/* FirstSourceFile.m */

- (void)firstDummyMethod {
        ...
        ARpS_startTimer();
}

```

```
/* SecondSourceFile.m */

- (void)secondDummyMethod {
        ...
        ARpS_stopTimerAndLog();
}

```

Results in a log:
```
≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
⊛ ARPerformanceScout ⊛

✔ Timed: 15.291372s
≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌≌
```

## Caveats

- `ARpS` uses a block-based API so one should be careful about retain-cycles (the [weakSelf code-snippet](https://github.com/mattt/Xcode-Snippets/blob/master/weakself.m) is a good friend to have.)
- `ARpS_measure()` will only take into account work being done on the thread it's called
- `ARpS_startTimer()` and `ARpS_stopTimerAndLog()` don't work well (YET) when called on separate threads
- `XCode's Time Profiler` is a more precise tool for performance bottleneck discovery. `ARPerformanceScout` is intended to be used with very short iteration cycles and as a guide only


## Contact

Claudiu-Vlad Ursache

- https://github.com/ursachec
- https://twitter.com/ursachec
- http://cvursache.com

Artsy

- https://github.com/artsy
- https://twitter.com/Artsy
- http://artsy.net


## License
ARPerformanceScout is available under the MIT license. See the LICENSE file for more info. 
