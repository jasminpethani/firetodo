//
//  AppDelegate.swift
//  TodoListFirebase
//
//  Created by jasmin on 13/07/17.
//  Copyright © 2017 jazz. All rights reserved.
//

import UIKit


import Firebase
import FirebaseDatabase
import FBSDKLoginKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?


     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
          
          
          
          #if DEBUG
               debugPrint("DEBUG mode")
               UITabBar.appearance().tintColor = UIColor(red:0.11, green:0.11, blue:0.14, alpha:1.00)
          #elseif RELEASE
               print("RELEASE mode")
          #endif
          
          
          // Facebook
          
          FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
          
          
          // Firebase
          
          FirebaseApp.configure()
          Database.database().isPersistenceEnabled = true
          
          return true
     }

}

