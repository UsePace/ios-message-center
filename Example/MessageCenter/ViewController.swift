//
//  ViewController.swift
//  MessageCenter
//
//  Created by jfredsoft on 11/07/2018.
//  Copyright (c) 2018 jfredsoft. All rights reserved.
//

import UIKit
import MessageCenter

class ViewController: UIViewController, ConnectionProtocol {
    
    func onMessageCenterConnected() {
        print("Connected")
    }
    
    func onMessageCenterConnectionError(code: Int, message: String) {
        print("Error occured: %d %@", code, message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let user1 = ConnectionRequest(appId: "FE3AD311-7F0F-4E7E-9E22-25FF141A37C0", userId: "rider_sony", accessToken: "4a8f3c197450b4762cd2dcf02a130816a503f4f2", client: ClientType.CLIENT_SENDBIRD, fcmToken: "")
        
        let user2 = ConnectionRequest(appId: "FE3AD311-7F0F-4E7E-9E22-25FF141A37C0", userId: "customer_hs_184890", accessToken: "8b21b79c6a07d74e95cf6c91837ec2a64e9cbc54", client: ClientType.CLIENT_SENDBIRD, fcmToken: "")
        
        MessageCenter.connect(connectionRequest: user1, connectionInterface: self)
        MessageCenter.connect(connectionRequest: user2, connectionInterface: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

