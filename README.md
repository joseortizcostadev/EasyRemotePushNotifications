# Easy Remote Push Notifications
<h1> Description </h1>
• A complete, free and easy service to send and schedule remote push notifications to IOS devices from your app. You will be all the time in complete control about how and when to send your IOS notifications. 
<h1> Instalation </h1>
• First of all, you need to create your own project in xCode for IOS devices using Swift. It can be an empty project just to test our services. <br>
• Then, you'll need to create your apple certificates and provisionament files for development, production or both. <br>
• Once you have all of this stuff figured out, you can go to [Easy Remote Push Notifications](https://jortizsd.com/easy_remote_services/) and create a new developer account. <br>
• After your account has been created, you need to register your project in your erpn account, and configure it in the configuration panel <br>
• In the configuration panel, you'll configure your project using three easy steps:  <br>
• First, you'll upload your development or production certificate to our server. <br> 
• Then, you'll be able to download our ERPN API or download it from this repo. You can find an example about how to use       our ERPN API in the ERPN_Setup.swift file located in this repo. <br>
• Finally, you'll have to configure the transport security in your info.plist file of your project. 
     
     ``` 
     <key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>jortizsd.com</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.1</string>
			</dict>
		</dict>
	</dict>
     ```
     

<h1> Usage </h1> 
• If you have followed all the above steps correctely, Then, you are ready to push remote notifications from your IOS devices to your customers using your ERPN server admin panel. <br>
• Every time your app is executed for the first time in any device with it installed, it must sent the device token to your ERPN service panel in order to be able to sent remote push notification. Here is an example about how to implement our API in your project's delegate class in order to send the device token to your service panel.
```Swift
//******************************************************************************************************
//  Author:      Jose Ortiz, ERPN
//  Copyright     © 2016 ERPN. All rights reserved.
//  Description: This app delegate class provides an example about how to configure your delegate 
//               file with ERPN.swift API in order to send remote push notifications from your erpn 
//               server to IOS devices which are using your app. 
//  
//  See:         ERPN API Docs       
//
//  More Info:   http://jortizsd.com/easy_remote_services/
//******************************************************************************************************

import UIKit
@UIApplicationMain
    
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let erpn = ERPN(erpnUsername: "username", erpnPassword: "password", erpnBundle: "your.project.bundle")
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)->Bool{ 
	    // Register this project to receive remote push notifications 
        erpn.registerProjectToSendRemoteNotifications(delegateAplication: application, minimumVersionTarget: 8.0)
		
	    // If true, the device token of the device using this app will be sent to your
	    // ERPN server every time this app is launched for the first time.
	    // Note: repeated tokens won't be saved in your ERPN server to avoid future device tokens conflicts.
        erpn.setSendTokenAtFirstLaunch(sendTokenAtFistAppRun: true)
        
	    // If true, every time an user install your app in his/her IOS device, you'll 
	    // receive an email confirmation with useful information about the token status for
	    // in your ERPN server for that new device.
	erpn.willSendEmailAfterNewDeviceTokenIsAdded(sendEmail: true)
        
	    // Override point for customization after application launch.
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
	    // Sends this device token to your ERPN server
        erpn.sendDeviceToken(deviceToken)
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError){
            // Returns an error notifications if the conection to your ERPN server failed, or this device token was
	        // not sent correctely.
	        // Note: Errors will be displayed in the console log of your project.
            erpn.getRegisterNotificationsError(cathError: error)
    }
}
```
• After correctely implemting ERPN API in your delegate class, run your project and check your console to see if everything went as expected. Then, go back to your ERPN service panel system and you'll see that your project is already configured.
• Now, you are ready to sent remote push notifications to all your customers using your app in just one click. 
• You can also personalize notifications, and schedule them in your ERPN service panel.

<h1> Updates </h1>
• Easy Remote Push Notifications Framework has been updated to provide support for new Swift 3.0 syntax and devices with IOS 10 installed. 
• We are actually working on providing Easy Remote Push Notifications for Android devices. Please visit http://jortizsd.com/easy_remote_services/ to learn more about us.


