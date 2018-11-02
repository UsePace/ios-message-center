//
//  ClientInterface.swift
//  MessageCenter
//
//  Created by iDev on 11/1/18.
//  Copyright © 2018 usepace. All rights reserved.
//

import Foundation

protocol ClientProtocol {
    func connect(connectionRequest: ConnectionRequest, connection: ConnectionaProtocol)
    func join(chatId: String)
    func disconnect(disconnectInterface: DisconnectionProtocol)
    func handleNotification(next: AnyClass,  icon: Int, title: String, remoteMessage: AnyClass, messages: NSArray)
}
