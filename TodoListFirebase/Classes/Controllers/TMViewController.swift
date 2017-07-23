//
//  LoginViewController.swift
//  TodoListFirebase
//
//  Created by jasmin on 15/07/17.
//  Copyright © 2017 jazz. All rights reserved.
//

import UIKit
import Firebase

class TMViewController: UIViewController {

     lazy var button: UIButton! = {
          let btn = UIButton(type: .custom)
           btn.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
           btn.center = self.view.center
           btn.setTitle("X", for: .normal)
           btn.setTitleColor(.black, for: .normal)
          return btn
     }()

     override func viewDidLoad() {
          super.viewDidLoad()
          
          // Firebase remote config
          
          view.addSubview(button)
          
          
          setupRemoteConfig()
          
          
          RemoteConfig.remoteConfig().fetch(withExpirationDuration: 0) { [weak self](configStatus, error) in
               if error != nil {
                    debugPrint(error!.localizedDescription)
                    return
               }
               
               RemoteConfig.remoteConfig().activateFetched()
               
               self?.updateView()
          }
     }
     
     
     func updateView() {
          let buttonText = RemoteConfig.remoteConfig()[RemoteConfigConstants.buttonText].stringValue
          button.setTitle(buttonText, for: .normal)
          let buttonColor = RemoteConfig.remoteConfig()[RemoteConfigConstants.buttonColor].stringValue
          let _textColor:UIColor = (buttonColor == "red") ? .red : .purple
          button.setTitleColor(_textColor, for: .normal)
     }
     
     func setupRemoteConfig() {
          let remoteConfig = RemoteConfig.remoteConfig()
          
          let dict = [RemoteConfigConstants.buttonText: "Hello World", RemoteConfigConstants.buttonColor: "red"]
          remoteConfig.configSettings = RemoteConfigSettings(developerModeEnabled: true)!
          remoteConfig.setDefaults(dict as [String : NSObject])
          
           self.updateView()
     }
    

}
