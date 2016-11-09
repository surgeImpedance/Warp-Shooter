//
//  StatsScene.swift
//  Star Shooter
//
//  Created by Tim Gleason on 9/28/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//
//  For displaying overall game statistics

import Foundation
import SpriteKit

class StatsScene: SKScene {
    
    // default for storing the score
    let userDefaults = UserDefaults.standard
    
    // last score
    var lastScore = 0
    
    // high score
    var highScore = 0
    
    // highest label
    var highestLevel = 1
    
    // main button
    var mainButton: SKSpriteNode?
    
    // last score label
    var lastScoreLabel: SKLabelNode?
    
    // high score label
    var highScoreLabel: SKLabelNode?
    
    // highest level label
    var highLevelLabel: SKLabelNode?
    
    // button sound action
    let buttonSoundAction = SKAction.playSoundFileNamed("buttonBeep_1.wav", waitForCompletion: true)
    
    override func didMove(to view: SKView) {
        
        lastScore = userDefaults.integer(forKey: "score")
        highScore = userDefaults.integer(forKey: "high_score")
        //highestLevel = userDefaults.integer(forKey: "highest_level")
        
        // set main button
        mainButton = childNode(withName: "main_button") as! SKSpriteNode?
        
        // set the last score label
        lastScoreLabel = childNode(withName: "lastScoreLabel") as! SKLabelNode?
        lastScoreLabel?.text = String(lastScore)
        
        // set the high score label
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode?
        if lastScore > highScore {
            highScore = lastScore
            highScoreLabel?.text = String(highScore)
        } else {
            highScoreLabel?.text = String(highScore)
        }
        
        // set the highest level label
        highLevelLabel = childNode(withName: "highLevelLabel") as! SKLabelNode?
        highLevelLabel?.text = String(highestLevel)
        
        // Save the high score
        userDefaults.set(highScore, forKey: "high_score")
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
        }
        
    }
}
