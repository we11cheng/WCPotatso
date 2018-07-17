# LogglyLogger-CocoaLumberjack

LogglyLogger-CocoaLumberjack is a custom logger for [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) that logs to [Loggly](https://www.loggly.com/).

##Requirements

  - A Loggly account. (Note, they charge for higher volumes of logging)
  - CocoaLumberjack >= 2.0
  
(From 2.3.0 of LogglyLogger-CocoaLumberjack, AFNetworking is no longer a dependency)

LogglyLogger-CocoaLumberjack uses ARC. If your project doesn't use ARC, you can enable it per file using the `-fobjc-arc` compiler flag under "Build Phases" and "Compile Sources" on your project's target in Xcode.

##Installation

Using [CocoaPods](http://www.cocoapods.org) :

    pod "LogglyLogger-CocoaLumberjack", "~> 2.0"

##Usage

First, make sure that you have created an API key in your Loggly account (they call this Customer Token, and can be created
in the Loggly Web UI under the tab "Source setup").

In your App Delegate:

    #import "LogglyLogger.h"
    #import "LogglyFormatter.h"
    static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

In didFinishLaunchingWithOptions

```objc
LogglyLogger *logglyLogger = [[LogglyLogger alloc] init];
[logglyLogger setLogFormatter:[[LogglyFormatter alloc] init]];
logglyLogger.logglyKey = @"your-loggly-api-key";

// Set posting interval every 15 seconds, just for testing this out, but the default value of 600 seconds is better in apps
// that normally don't access the network very often. When the user suspends the app, the logs will always be posted.
logglyLogger.saveInterval = 15;

[DDLog addLogger:logglyLogger];

// Do some logging
DDLogVerbose(@"{\"myJsonKey\":\"some verbose json value\"}");
```

This is all there is to it. The log posts will include all the json fields that you put in the log message plus some standard fields that the logger adds automatically:

  - **loglevel** - CocoaLumberjack Log level
  - **timestamp** - Timestamp in iso8601 format (required by Loggly)
  - **file** - The name of the source file that logged the message
  - **fileandlinenumber** - Source file and line number in that file (nice for doing facet searches in Loggly)
  - **appname** - The Display name of your app
  - **appversion** - The version of your app. You can override by setting your own appversion in the LogglyFields object.
  - **devicemodel** - The device model
  - **devicename** - The device name
  - **lang** - The primary lang the app user has selected in Settings on the device
  - **osversion** - the iOS version
  - **rawlogmessage** - The log message that you sent, unparsed. This is also where simple non-JSON log messages will show up.
  - **sessionid** - A generated random id, to let you search in loggly for log statements from the same session. You can override this random value by setting your own sessionid in the LogglyFields object.
  - **userid** - A userid string. Note, you must set this userid yourself in the LogglyFields object. No default value.

Note that you don't have to log statements in json format, but it is much easier to do facet searches in Loggly if you do use JSON.
Word of warning, don't use too many json keys. It will mess up the Loggly UI. Figure out smart json keys that you can reuse
in many of your log statements.

##Advanced Usage

###Loggly tags

LogglyLogger will use the bundle id of your app as a Loggly tag. You can create a "source group" in Loggly
that contains all log statements that has a specific tag. This way, you can easily use the same Loggly
account for many apps. If you don't want to use the bundle id as the tag or if you want to
use multiple tags, you can set the property logglyTags in the LogglyLogger.
(comma-separated list of tags, no whitespace in or between tags)

###LogglyLogger settings

There are some settings you can set on the LogglyLogger. Most of them are inherited from the abstract class and
they all have reasonable default values.

  - **saveInterval** - Number of seconds between posting log statements to Loggly. Default = 600. Note that the logs are always posted when the app is suspended. Setting this to a low value may turn your app into a battery hog.
  - **saveThreshold** - Number of log messages before forcing a post, regardless of how long time it has been since the last post. Default 1000.

By default, the logmessage will always be logged in the Loggly field "rawlogmessage", even though the log message was successfully parsed and logged as
 individual JSON fields. To prevent logging of rawlogmessage in this situation, set the LogglyFormatter property **alwaysIncludeRawMessage** to NO

 ```objc
    LogglyFormatter *logglyFormatter = [[LogglyFormatter alloc] init];
    logglyFormatter.alwaysIncludeRawMessage = NO;

    LogglyLogger *logglyLogger = [[LogglyLogger alloc] init];
    [logglyLogger setLogFormatter:logglyFormatter];
```

###Tracking sessions and users

To track a specific user you can set the userid property on the LogglyFields object. The username
will then be included in every log statement until the app is terminated by iOS.

Similarily you can set a custom session id. If you don't, the session id will be a random string.
Let's say that a user complains about having problems in your app. You can then have some input view
in your app where the user can enter a string, which you set as the sessionid. At the same time
you can set the CocoaLumberjack log level to a finer level for this user. Now you can follow
the detailed logs in Loggly for this particular user, by filtering out all but this particular session.
Pretty nice, huh?

###Roll your own LogglyFieldsDelegate

If you're not happy with the standard fields that are logged with every request, you can implement your own LogglyFieldsDelegate
You only need to implement one method:

```objc
@protocol LogglyFieldsDelegate
- (NSDictionary *)logglyFieldsToIncludeInEveryLogStatement;
@end
```

Use your custom delegate by using this init method when creating the LogglyFormatter:
```objc
LogglyFormatter *logglyFormatter = [[LogglyFormatter alloc] initWithLogglyFieldsDelegate:yourCustomDelegate];
```

##Feedback and Contribution

All feedback and contribution is very appreciated. Please send pull requests, create issues
or just send an email to [mats.melke@gmail.com](mailto:mats.melke@gmail.com).

##Copyrights

* Copyright (c) 2014- Mats Melke. Please see LICENSE.txt for details.
