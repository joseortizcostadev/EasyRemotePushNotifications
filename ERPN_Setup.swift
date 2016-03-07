//*************************************************************************************************
//  Author:      Jose Ortiz, ERPN
//  Copyright     © 2016 ERPN. All rights reserved.
//  Description: This app is used as a guide about how to configure your
//               delegate file with ERPN.swift API in order to send 
//               remote push notifications from your erpn server with IOS
//               devices. After building your own IOS project, and 
//               in order to send push notifications from your project 
//               using the ERPN, you must go to jortizsd.com/easy_remote_services/index.php
//               and create a new account. Then you must register your project,
//               follow the instructions detailed there, and set your delegate up 
//               like in this example.
//               Note: Your delegate file may look diferent from this one. However, you
//               should be able to set it up without any problem. Also, the following methods
//               didRegisterForRemoteNotificationsWithDeviceToken() and 
//               didFailToRegisterForRemoteNotificationsWithDeviceToken()
//               will not appear as default methods when you create a project. You need to import
//               or type them manually.
//  
//  See:         ERPN API Docs       
//
//
//*************************************************************************************************

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let erpn = ERPN(erpnUsername: "newest", erpnPassword: "newtest", erpnBundle: "erpn.newtest")
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
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

