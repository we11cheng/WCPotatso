/*
 *    HelpshiftCore.h
 *    SDK Version 5.6.1
 *
 *    Get the documentation at http://www.helpshift.com/docs
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HsApiProvider <NSObject>
- (void) _installForApiKey:(NSString *)apiKey domainName:(NSString *)domainName appID:(NSString *)appID;
- (void) _installForApiKey:(NSString *)apiKey domainName:(NSString *)domainName appID:(NSString *)appID withOptions:(NSDictionary *)optionsDictionary;

- (BOOL) _loginWithIdentifier:(NSString *)identifier withName:(NSString *)name andEmail:(NSString *)email;
- (BOOL) _logout;
- (void) _setName:(NSString *)name andEmail:(NSString *)email;
- (void) _registerDeviceToken:(NSData *)deviceToken;
- (BOOL) _handleRemoteNotification:(NSDictionary *)notification withController:(UIViewController *)viewController;
- (BOOL) _handleLocalNotification:(UILocalNotification *)notification withController:(UIViewController *)viewController;
- (BOOL) _handleInteractiveRemoteNotification:(NSDictionary *)notification forAction:(NSString *)actionIdentifier completionHandler:(void (^)())completionHandler;
- (BOOL) _handleInteractiveLocalNotification:(UILocalNotification *)notification forAction:(NSString *)actionIdentifier completionHandler:(void (^)())completionHandler;
- (BOOL) _handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler;
- (BOOL) _setSDKLanguage:(NSString *)langCode;

@end

@interface HelpshiftCore : NSObject
/**
 *  Initialize the HelpshiftCore class with an instance of the Helpshift service which you want to use.
 *
 *  @param apiProvider An implementation of the HsApiProvider protocol. Current implementors of this service are the HelpshiftCampaigns, HelpshiftSupport and HelpshiftAll classes.
 */
+ (void) initializeWithProvider:(id <HsApiProvider>)apiProvider;

/** Initialize helpshift support
 *
 * When initializing Helpshift you must pass these three tokens. You initialize Helpshift by adding the following lines in the implementation file for your app delegate, ideally at the top of application:didFinishLaunchingWithOptions.
 *
 *  @param apiKey This is your developer API Key
 *  @param domainName This is your domain name without any http:// or forward slashes
 *  @param appID This is the unique ID assigned to your app
 *
 *  @available Available in SDK version 5.0.0 or later
 */
+ (void) installForApiKey:(NSString *)apiKey domainName:(NSString *)domainName appID:(NSString *)appID;

/** Initialize helpshift support
 *
 * When initializing Helpshift you must pass these three tokens. You initialize Helpshift by adding the following lines in the implementation file for your app delegate, ideally at the top of application:didFinishLaunchingWithOptions
 *
 * @param apiKey This is your developer API Key
 * @param domainName This is your domain name without any http:// or forward slashes
 * @param appID This is the unique ID assigned to your app
 * @param withOptions This is the dictionary which contains additional configuration options for the HelpshiftSDK.
 *
 * @available Available in SDK version 5.0.0 or later
 */

+ (void) installForApiKey:(NSString *)apiKey domainName:(NSString *)domainName appID:(NSString *)appID withOptions:(NSDictionary *)optionsDictionary;

/** Login a user with a given identifier
 *
 * The identifier uniquely identifies the user. Name and email are optional.
 *
 * @param name The name of the user
 * @param email The email of the user
 *
 * @available Available in SDK version 5.0.0 or later
 *
 */
+ (void) loginWithIdentifier:(NSString *)identifier withName:(NSString *)name andEmail:(NSString *)email;

/** Logout the currently logged in user
 *
 * After logout, Helpshift falls back to the default device login.
 *
 * @available Available in SDK version 5.0.0 or later
 *
 */
+ (void) logout;

/** Set the name and email of the application user.
 *
 *
 *   @param name The name of the user.
 *   @param email The email address of the user.
 *
 *   @available Available in SDK version 5.0.0 or later
 */

+ (void) setName:(NSString *)name andEmail:(NSString *)email;

/** Register the deviceToken to enable push notifications
 *
 *
 * To enable push notifications in the Helpshift iOS SDK, set the Push Notifications’ deviceToken using this method inside your application:didRegisterForRemoteNotificationsWithDeviceToken application delegate.
 *
 *  @param deviceToken The deviceToken received from the push notification servers.
 *
 *  @available Available in SDK version 5.0.0 or later
 *
 */
+ (void) registerDeviceToken:(NSData *)deviceToken;

/**
 *  Pass along a notification to the Helpshift SDK to handle
 *
 *  @param notification   Notification dictionary
 *  @param viewController The viewController on which you want the Helpshift SDK stack to be shown
 *
 *  @return BOOL value indicating whether Helpshift handled this push notification.
 */
+ (BOOL) handleRemoteNotification:(NSDictionary *)notification withController:(UIViewController *)viewController;

/**
 *  Pass along a local notification to the Helpshift SDK
 *
 *  @param notification   notification object received in the Application's delegate method
 *  @param viewController The viewController on which you want the Helpshift SDK stack to be shown
 *
 *  @return BOOL value indicating whether Helpshift handled this push notification.
 */
+ (BOOL) handleLocalNotification:(UILocalNotification *)notification withController:(UIViewController *)viewController;

/**
 *  Pass along an interactive notification to the Helpshift SDK
 *
 *  @param notification      notification object received in the Application's delegate
 *  @param actionIdentifier  identifier of the action which was executed in the notification
 *  @param completionHandler completion handler
 *
 *  @return BOOL value indicating whether Helpshift handled this push notification.
 */
+ (BOOL) handleInteractiveRemoteNotification:(NSDictionary *)notification forAction:(NSString *)actionIdentifier completionHandler:(void (^)())completionHandler;

/**
 *  Pass along an interactive local notification to the Helpshift SDK
 *
 *  @param notification      notification object received in the Application's delegate
 *  @param actionIdentifier  identifier of the action which was executed in the notification
 *  @param completionHandler completion handler
 *
 *  @return BOOL value indicating whether Helpshift handled this push notification.
 */
+ (BOOL) handleInteractiveLocalNotification:(UILocalNotification *)notification forAction:(NSString *)actionIdentifier completionHandler:(void (^)())completionHandler;

/**
 *  If an app is woken up in the background in response to a background session being completed, call this API from the
 *  Application's delegate method. Helpshift SDK extensively uses background NSURLSessions for data syncing.
 *
 *  @param identifier        identifier of the background session
 *  @param completionHandler completion handler
 *
 *  @return BOOL value indicating whether Helpshift handled this push notification.
 */
+ (BOOL) handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler;

/** Change the SDK language. By default, the device's prefered language is used.
 *  If a Helpshift session is already active at the time of invocation, this call will fail and will return false.
 *
 * @param languageCode the string representing the language code. For example, use 'fr' for French.
 *
 * @return BOOL indicating wether the specified language was applied. In case the language code is incorrect or
 * the corresponding localization file was not found, bool value of false is returned and the default language is used.
 *
 * @available Available in SDK version 5.5.0 or later
 */

+ (BOOL) setSDKLanguage:(NSString *)languageCode;

@end
