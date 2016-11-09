//
//  HelpScene.swift
//  Warp Shooter
//
//  Created by Tim Gleason on 10/11/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import Foundation
import SpriteKit
import MessageUI

class HelpScene: SKScene, MFMailComposeViewControllerDelegate {
    
    // main button
    var mainButton: SKSpriteNode?
    
    // email button
    var emailButton: SKSpriteNode?
    
    // button sound action
    let buttonSoundAction = SKAction.playSoundFileNamed("buttonBeep_1.wav", waitForCompletion: true)
    
    override func didMove(to view: SKView) {
        // set the main button
        mainButton = childNode(withName: "main_button") as! SKSpriteNode?
        
        // set the email button
        emailButton = childNode(withName: "emailBtn") as! SKSpriteNode?
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            
            if (mainButton?.contains(location))! {
                let startScene = SKScene(fileNamed: "StartScene")
                let sceneAction = SKAction.run {
                    startScene?.scaleMode = .aspectFill
                    let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                    self.scene?.view?.presentScene(startScene!, transition: transition)
                }
                
                run(SKAction.sequence([buttonSoundAction, sceneAction]))
            }
            
            if (emailButton?.contains(location))! {
                run(buttonSoundAction)
                sendEmail()
            }
        }
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["khd0507@gmail.com"])
            mail.setMessageBody("<p>Message About Warp Shooter!<p>", isHTML: true)
            
            self.view?.window?.rootViewController?.present(mail, animated: true)
        } else {
            let alert = UIAlertController(title: "Email Error",
                                          message: "Email not set up",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Done",
                                       style: .default, handler: nil)
            alert.addAction(action)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
