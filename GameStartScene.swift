//
//  GameStartScene.swift
//  Star Shooter
//
//  Created by Tim Gleason on 9/28/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class GameStartScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()

    // start button
    var startButton: SKSpriteNode?
    
    // stats button
    var statsButton: SKSpriteNode?
    
    // help button
    var helpButton: SKSpriteNode?
    
    // enemies button
    var enemiesButton: SKSpriteNode?
    
    // button sound action
    let buttonSoundAction = SKAction.playSoundFileNamed("buttonBeep_1.wav", waitForCompletion: true)
    
    override func didMove(to view: SKView) {
        
        // set the start button
        startButton = childNode(withName: "start_button") as! SKSpriteNode?
        
        // set the stats button
        statsButton = childNode(withName: "stats_button") as! SKSpriteNode?
        
        // set the help button
        helpButton = childNode(withName: "help_button") as! SKSpriteNode?
        
        // set the enemies button
        enemiesButton = childNode(withName: "enemiesButton") as! SKSpriteNode?
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            
            if (startButton?.contains(location))! {
                
                if let gameOverScene = SKScene(fileNamed: "ShipSelectorScene") {
                    let sceneAction = SKAction.run {
                        gameOverScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(gameOverScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
                
                /*if let gameOverScene = SKScene(fileNamed: "GameScene") {
                    let sceneAction = SKAction.run {
                        gameOverScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(gameOverScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }*/
            }
            
            if (statsButton?.contains(location))! {
                if let gameOverScene = SKScene(fileNamed: "StatsScene") {
                    let sceneAction = SKAction.run {
                        gameOverScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(gameOverScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
            
            if (helpButton?.contains(location))! {
                if let helpScene = SKScene(fileNamed: "HelpScene") {
                    let sceneAction = SKAction.run {
                        helpScene.scaleMode = .aspectFill
                        let transistion = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(helpScene, transition: transistion)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
            
            if (enemiesButton?.contains(location))! {
                if let helpScene = SKScene(fileNamed: "EnemiesScene") {
                    let sceneAction = SKAction.run {
                        helpScene.scaleMode = .aspectFill
                        let transistion = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(helpScene, transition: transistion)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
        }
    }
}
