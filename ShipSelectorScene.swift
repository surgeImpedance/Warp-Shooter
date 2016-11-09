//
//  ShipSelectorScene.swift
//  Warp Shooter
//
//  Created by Tim Gleason on 10/19/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import Foundation
import SpriteKit

class ShipSelectorScene: SKScene {
    
    // default for storing the name of the selected ship
    let userDefaults = UserDefaults.standard
    
    // button sound action
    let buttonSoundAction = SKAction.playSoundFileNamed("buttonBeep_1.wav", waitForCompletion: true)
    
    // name of the ship that was selected
    var shipName: String?
    
    // button to select the alcubierre ship
    var alcubierreSelect: SKSpriteNode?
    
    // button to select the blueness ship
    var bluenessSelect: SKSpriteNode?
    
    // button to select the hammer ship
    var hammerSelect: SKSpriteNode?
    
    // button to select the sidewinder ship
    var sidewinderSelect: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        // set the alcubierreSelect button
        alcubierreSelect = childNode(withName: "alcubierreSelect") as! SKSpriteNode?
        
        // set the bluenessSelect button
        bluenessSelect = childNode(withName: "bluenessSelect") as! SKSpriteNode?
        
        // set the hammerSelect button
        hammerSelect = childNode(withName: "hammerSelect") as! SKSpriteNode?
        
        // set the sidewinderSelect button
        sidewinderSelect = childNode(withName: "sidewinderSelect") as! SKSpriteNode?
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            
            if (alcubierreSelect?.contains(location))! {
                shipName = "alcubierre"
                
                // Save the name of the ship that was selected
                userDefaults.set(shipName, forKey: "shipName")
                
                if let gameOverScene = SKScene(fileNamed: "GameScene") {
                    let sceneAction = SKAction.run {
                        gameOverScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(gameOverScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
            
            if (bluenessSelect?.contains(location))! {
                shipName = "blueness"
                
                // Save the name of the ship that was selected
                userDefaults.set(shipName, forKey: "shipName")
                
                if let gameOverScene = SKScene(fileNamed: "GameScene") {
                    let sceneAction = SKAction.run {
                        gameOverScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(gameOverScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
            
            if (hammerSelect?.contains(location))! {
                shipName = "hammer"
                
                // Save the name of the ship that was selected
                userDefaults.set(shipName, forKey: "shipName")
                
                if let gameOverScene = SKScene(fileNamed: "GameScene") {
                    let sceneAction = SKAction.run {
                        gameOverScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(gameOverScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
            
            if (sidewinderSelect?.contains(location))! {
                shipName = "sidewinder"
                
                // Save the name of the ship that was selected
                userDefaults.set(shipName, forKey: "shipName")
                
                if let gameOverScene = SKScene(fileNamed: "GameScene") {
                    let sceneAction = SKAction.run {
                        gameOverScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(gameOverScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
        }
    }
}
