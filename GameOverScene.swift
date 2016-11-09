//
//  GameOverScene.swift
//  Star Shooter
//
//  Created by Tim Gleason on 9/18/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import Foundation
import SpriteKit


class GameOverScene: SKScene {
    
    var startNewGame: SKSpriteNode?
    
    // player's highest level
    var highestLevel = 1
    
    // stats button
    var statsButton: SKSpriteNode?
    
    // score label
    var scoreLabel: SKLabelNode?
    
    // high level label
    var highestLevelLabel: SKLabelNode?
    
    // default for retrieving the score
    let userDefaults = UserDefaults.standard
    
    // score from the previous game
    var gameScore = 0
    
    // button sound action
    let buttonSoundAction = SKAction.playSoundFileNamed("buttonBeep_1.wav", waitForCompletion: true)
    
    // button sound action 2
    let buttonSoundAction2 = SKAction.playSoundFileNamed("beep_a.wav", waitForCompletion: true)
    
    override func didMove(to view: SKView) {
        startNewGame = childNode(withName: "startOverText") as! SKSpriteNode?
        
        // set the stats button, and start off witht he button hidden
        statsButton = self.childNode(withName: "statsButton") as! SKSpriteNode?
        statsButton?.zPosition = 3
        
        //retrieve the score
        gameScore = userDefaults.integer(forKey: "score")
        
        // retrieve the highlest level
        highestLevel = userDefaults.integer(forKey: "highest_level")
        
        
        // set the score label
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode?
        scoreLabel?.text = String(gameScore)
        
        // set the highes level label
        highestLevelLabel = childNode(withName: "levelLabel") as! SKLabelNode?
        highestLevelLabel?.text = String(highestLevel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            
            if (startNewGame?.contains(location))!{
                if let newGameScene = SKScene(fileNamed: "GameScene") {
                    let sceneAction = SKAction.run {
                        newGameScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(newGameScene, transition: transition)
                    }
                    run(SKAction.sequence([buttonSoundAction2, sceneAction]))
                }
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
        }
    }
}
