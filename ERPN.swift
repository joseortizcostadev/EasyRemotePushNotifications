//
//  Author:          Jose Ortiz Costa
//  Email:           jose@jortizsd.com
//  File:            ERPN.swift
//  Original Date:   08/21/2015
//  Modified:        03/06/2016
//  Copyright (c)    2016 Easy Remote Push Notifications.
//                   Powered by Easy Remote Services. All rights reserved.
//  Description:     This class provides useful methods to configure your project for registering
//                   and recieving remote notifications for IOS devices. It also provides internal configuration
//                   to send device tokens to ERPN servers. Those tokens will be used as a identificator
//                   to determine which devices will recieve the push notification. Before configuring this project,
//                   you'll need to create an Easy Remote Services free account, and a new project in Easy Remote Push Notifications with the
//                   same bundle and name as your original project. Also, you'll need your APNS SSL Certificates, as well as your provisioment
//                   files,in order to be able to configure your project. Otherwise, tokens won't we send to the server.
//  
//  ERPN Policy:     This API cannot be modified, or distributed for comertial uses under any concept. 
//                   Any internal modification of this API could cause fatal errors in your code, and
//                   therefore, failures to push ans receive remote notifications. To learn more
//                   about our ERPN policies, please visit jortizsd.com/easy_remote_services.
//
//

import Foundation
import UIKit

class ERPN
{
    /***** 
	     
          DO NOT MODIFY ERPN_SERVER UNDER ANY CONCEPT
		  MODIFICATIONS OF THIS CLASS COULD PROVOKE FATAL 
		  ERRORS IN YOUR CODE, AS WELL AS, FAILURE TO PUSH AND
		  RECEIVE REMOTE NOTIFICATIONS
	
	******/
    private let ERPN_SERVER: NSURL! = NSURL (string: "http://jortizsd.com/easy_remote_services/easy_remote_push_notifications/tokens_manager.php")
    private let ERPN_DEVICE_TOKEN_STATUS: NSURL! = NSURL (string: "http://jortizsd.com/easy_remote_services/easy_remote_push_notifications/ntf_feedback.php")
    // Modify the value of KEY_FIRST_APP_RUN key if it creates conflicts with any other key set in this project
    private let KEY_FIRST_APP_RUN = "FistTimeLunch"
    private let DEVICE_TOKEN_KEY = "devicetoken"
    private var urlRequest : NSMutableURLRequest!
    private var statusRequest : NSMutableURLRequest!
    // Credentials instances variables
    private var erpnUsr: String!
    private var erpnPassw: String!
    private var erpnProjectBundle: String!
    private var sendEmail: Bool!
    
    // This instance variable is recomended to be set to true all the time to avoid tokens' conflicts and duplicates
    private var sendTokenFirstAppExecution: Bool!
    
    /*
    Main Constructor
    */
    init ()
    {
        self.urlRequest = NSMutableURLRequest(URL: ERPN_SERVER)
        self.statusRequest = NSMutableURLRequest(URL: ERPN_DEVICE_TOKEN_STATUS)
        setSendTokenAtFirstLaunch(sendTokenAtFistAppRun: true)
        willSendEmailAfterNewDeviceTokenIsAdded(sendEmail: false)
    }
    
    /*
    Alternative Contructor ( Recomended )
    */
    convenience init (erpnUsername usr: String, erpnPassword password : String, erpnBundle bundle : String)
    {
        
        self.init()
        self.urlRequest = NSMutableURLRequest(URL: ERPN_SERVER)
        self.statusRequest = NSMutableURLRequest(URL: ERPN_DEVICE_TOKEN_STATUS)
        setERPNUsername(erpnUsr: usr)
        setERPNPassword(erpnPassw: password)
        setERPNProjectBundle(erpnProjectBundle: bundle)
        setSendTokenAtFirstLaunch(sendTokenAtFistAppRun: true)
        willSendEmailAfterNewDeviceTokenIsAdded(sendEmail: false)
    }
    
    /*
    Setters
    */
    
    // Sets ERPN username
    func setERPNUsername (erpnUsr username : String )
    {
        self.erpnUsr = username
    }
    
    // Sets ERPN password
    func setERPNPassword (erpnPassw password : String)
    {
        self.erpnPassw = password
    }
    
    // Sets this project bundle
    func setERPNProjectBundle (erpnProjectBundle bundle : String)
    {
        self.erpnProjectBundle = bundle
    }
    
    // Sets if the token will be sent only at the first launch ( set to true recomended )
    func setSendTokenAtFirstLaunch (sendTokenAtFistAppRun activate : Bool )
    {
        self.sendTokenFirstAppExecution = activate
    }
    
    // Sets if your project is in test Mode ( Just for testing configuration )
    func willSendEmailAfterNewDeviceTokenIsAdded (sendEmail sendEmail : Bool)
    {
        self.sendEmail = sendEmail
    }
    
    /*
    Getters
    */
    
    // Gets ERPN uername
    func getERPNUsername () -> String
    {
        return self.erpnUsr
    }
    
    // Gets this project bundle
    func getERPNProjectBundle () -> String
    {
        return self.erpnProjectBundle
    }
    
    // Gets if the device token will be send only at first launch
    func isTokenSetToBeSentAtFirstAppRun () -> Bool
    {
        return self.sendTokenFirstAppExecution
    }
    
    // Converts the binary device token to string, and return it in String format
    func deviceTokenToString (deviceToken : NSData) -> String
    {
        /*  Uncomment if you need to remove special tokens but not needed in this version */
        //var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString ) as String
        return deviceTokenString
    }
    
    // Register project to recieve remote notifications, for all IOS versions
    func registerProjectToSendRemoteNotifications (delegateAplication application : UIApplication, minimumVersionTarget iosTarget : Double)
    {
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:")
        {
            
            let types:UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        else
        {
            // Ios is less than 8.0
        }
    }
    
    // Prepare Device token to be send
    private func prepareDeviceToken (deviceToken token : String, activateStatusErrorsInConsole isErrorActive : Bool)
    {
        /***** DO NOT MODIFY THIS METHOD *******/
        let deviceToken = "usr=\(self.erpnUsr)&passw=\(self.erpnPassw)&bundle=\(erpnProjectBundle)&token=\(token)&testMode=\(self.sendEmail)"
        self.urlRequest.HTTPMethod = "POST" // Post request
        self.urlRequest.HTTPBody = deviceToken.dataUsingEncoding(NSUTF8StringEncoding); // encripts device token
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) // Send device token
            {
                (response, data, error) in
                if let HTTPResponse = response as? NSHTTPURLResponse
                {
                    let statusCode = HTTPResponse.statusCode
                    
                    if statusCode == 200
                    {
                        // Device token succesfully send, if testMode is set to true, you'll recieve an email
                        // informing you about the state of your project.
                        print("The device token \(token) has been successfully sent to ERPN server")
                    }
                    else
                    {
                        // Error check log console. If you are in testMode, you'll recieve an email with detailed info about this error
                        print("The device token \(token) couldn't be sent to ERPN server due to a internal error with web status \(statusCode). Please, try later again")
                    }
                }
        }
        
    }
    
    // Send device token
    func sendDeviceToken (token : NSData)
    {
        let tokenToString = deviceTokenToString(token) // Convert the device token from NSData to String format
        
        // if the device token is set to be sent only the first time this app run
        if self.isTokenSetToBeSentAtFirstAppRun()
        {
            
            if !NSUserDefaults.standardUserDefaults().boolForKey(KEY_FIRST_APP_RUN)
            {
                // device token and credentials sent to server to be processed
                prepareDeviceToken(deviceToken: tokenToString, activateStatusErrorsInConsole: true)
                // Tells the app that the device token won't be sent anymore to avoid conflicts and duplicates
                NSUserDefaults.standardUserDefaults().setBool(self.isTokenSetToBeSentAtFirstAppRun(), forKey: KEY_FIRST_APP_RUN)
                NSUserDefaults.standardUserDefaults().setObject(tokenToString, forKey: DEVICE_TOKEN_KEY)
            }
        }
        else
        {
            
            // Send device token to the server all the time the app runs ( Not Recomended )
            prepareDeviceToken(deviceToken: tokenToString, activateStatusErrorsInConsole: true)
            
        }
        
    }
    
    // Gets any internal error if notifications registration is rejected
    func getRegisterNotificationsError ( cathError error : NSError)
    {
        print("Failed to register notifications with the following error: \(error)")
    }
    
    // Sends feedback to your erpn server about the status of a notification after being send from
    // your admin panel. If the notification was succesfully recieved, then a status message will be
    // send to your admin panel. This method is very useful to determine which devices has desistalled
    // your app or which of them are disabled.
    func sendDeviceStatus ()
    {
        /***** DO NOT MODIFY THIS METHOD *******/
        let deviceToken: String! = NSUserDefaults.standardUserDefaults().objectForKey(DEVICE_TOKEN_KEY) as! String;
        let status = "true"
        let deviceStatus = "usr=\(self.erpnUsr)&passw=\(self.erpnPassw)&bundle=\(erpnProjectBundle)&token=\(deviceToken)&status=\(status)"
        self.statusRequest.HTTPMethod = "POST" // Post request
        self.statusRequest.HTTPBody = deviceStatus.dataUsingEncoding(NSUTF8StringEncoding); // encripts device token
        print("Device token \(deviceToken)")
        NSURLConnection.sendAsynchronousRequest(self.statusRequest, queue: NSOperationQueue.mainQueue()) // Send device token
            {
                (response, data, error) in
                if let HTTPResponse = response as? NSHTTPURLResponse
                {
                    let statusCode = HTTPResponse.statusCode
                    
                    if statusCode == 200
                    {
                        // Device token succesfully send, if testMode is set to true, you'll recieve an email
                        // informing you about the state of your project.
                        print("Device status has been successfully sent to ERPN server")
                    }
                    else
                    {
                        // Error check log console. If you are in testMode, you'll recieve an email with detailed info about this error
                        print("The device status couldn't be sent to ERPN server due to a internal error with web status \(statusCode). Please, try later again")
                    }
                }
        }
    }
    
}