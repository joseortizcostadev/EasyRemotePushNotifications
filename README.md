# EasyRemotePushNotifications
<h1> Description </h1>
• A complete, free and easy service to send and schedule remote push notifications to IOS devices from your app. You will be all the time in complete control about how and when to send your IOS notifications. 
<h1> Instalation </h1>
• First of all, you need to create your own project in xCode for IOS devices using Swift. It can be an empty project just to test our services. <br>
• Then, you'll need to create your apple certificates and provisionament files for development, production or both. <br>
• Once you have all of this stuff figured out, you must go to jortizsd.com/easy_remote_services/index.php and create a new developer account. <br>
• After your account has been created, you need to register your project in your erpn account, and configure it in the configuration panel <br>
• In the configuration panel, you'll configure your project using three easy steps. <br>
• 1.First, you'll upload your development or production certificate to our server. <br> 
• Then, you'll be able to download our ERPN API or download it from this repo. You can find an example about how to use         our ERPN API in the ERPN_Setup.swift file located in this repo. <br>
• Finally, you'll have to configure the transport security in your info.plist file of your project. <br>
     
     ```xml
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
• If you have followed all this steps correctely, Then, you are ready to push remote notifications from your IOS devices to your customers using your ERPN server admin panel. <br>
• We are actually working on providing Android remote notifications support to our ERPN costumers. Please, visit jortizsd.com/easy_remote_services/ to learn more about our work.


