#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LogglyFields.h"
#import "LogglyFormatter.h"
#import "LogglyLogger.h"

FOUNDATION_EXPORT double LogglyLogger_CocoaLumberjackVersionNumber;
FOUNDATION_EXPORT const unsigned char LogglyLogger_CocoaLumberjackVersionString[];

