//
//  EnemiesScene.swift
//  Warp Shooter
//
//  Created by Tim Gleason on 10/31/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import Foundation
import SpriteKit

class EnemiesScene: SKScene {
    
    // button sound action
    let buttonSoundAction = SKAction.playSoundFileNamed("buttonBeep_1.wav", waitForCompletion: true)
    
    // button sound action for the forward and reverse buttons
    let buttonSoundAction2 = SKAction.playSoundFileNamed("beep_a.wav", waitForCompletion: true)
    
    // back button
    var backButton: SKSpriteNode?
    
    // forward button
    var forwardButton: SKSpriteNode?
    
    // reverse button
    var reverseButton: SKSpriteNode?
    
    // enemy description label
    var enemyDescription: SKLabelNode?
    
    // enemy sprite
    var enemySprite: SKSpriteNode?
    
    // enemy sprite description
    var enemySpriteDescription: SKSpriteNode?
    
    // comet trail emitter
    var cometTrail = SKEmitterNode(fileNamed: "CometTrail_1")
    
    // stellar core emitter
    var coreEffect = SKEmitterNode(fileNamed: "CoreFragEffect1")
    
    // the current enemy displayed
    var currentEnemy = ""
    
    // current location in the enemy list array
    var currentArrayPos = 0
    
    // list of all possible enemies
    var enemyList = ["Asteroid", "UFO", "Comet", "SpaceMine", "StellarCore", "SpaceVirus", "MicroBlackHole"]
    
    override func didMove(to view: SKView) {
        
        // set the back button
        backButton = childNode(withName: "backButton") as! SKSpriteNode?
        
        // set the forward button
        forwardButton = childNode(withName: "forwardButton") as! SKSpriteNode?
        
        // set the reverse button
        reverseButton = childNode(withName: "reverseButton") as! SKSpriteNode?
        
        // set the enemy description label
        enemyDescription = childNode(withName: "enemyDescription") as! SKLabelNode?
        
        // set the enemy sprite, defaults to the asteroid
        enemySprite = childNode(withName: "enemySprite") as! SKSpriteNode?
        cometTrail?.zPosition = -1.0
        cometTrail?.isHidden = true
        enemySprite?.addChild(cometTrail!)
        
        coreEffect?.isHidden = true
        enemySprite?.addChild(coreEffect!)
        
        // set the enemy sprite description, defaults to the asteroid description
        enemySpriteDescription = childNode(withName: "enemyDescriptionText") as! SKSpriteNode?
        
        // set the enemy description, defaults to the first enemy in the list
        currentEnemy = enemyList[0]
        
        // set enemy sprite, enemy description
        if currentEnemy == "Asteroid" {
            enemySprite?.texture = SKTexture(imageNamed: "crater12")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theAsteroidText_1")
            enemyDescription?.text = "A big chunk of space rock that can do a lot of damage."
        } else if currentEnemy == "UFO" {
            enemySprite?.texture = SKTexture(imageNamed: "Ufo_1")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theUFOText_1")
            enemyDescription?.text = "An angry UFO.  They hate humans."
        } else if currentEnemy == "Comet" {
            enemySprite?.texture = SKTexture(imageNamed: "comet_1")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theCometText_1")
            enemyDescription?.text = "A large, angry, and deadly ice cube."
        }
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            
            if (backButton?.contains(location))! {
                if let startScene = SKScene(fileNamed: "StartScene") {
                    let sceneAction = SKAction.run {
                        startScene.scaleMode = .aspectFill
                        let transition  = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.scene?.view?.presentScene(startScene, transition: transition)
                    }
                    
                    run(SKAction.sequence([buttonSoundAction, sceneAction]))
                }
            }
            
            if (forwardButton?.contains(location))! {
                run(buttonSoundAction2)
                if currentArrayPos < (enemyList.count - 1) {
                    currentArrayPos += 1
                } else {
                    currentArrayPos = 0
                }
            }
            
            if (reverseButton?.contains(location))! {
                run(buttonSoundAction2)
                if currentArrayPos != 0 {
                    currentArrayPos -= 1
                }
            }
        }
        
        updateEnemySpriteInfo()
        
        print(currentArrayPos)
        print(currentEnemy)
    }
    
    // update the enemy sprite info
    func updateEnemySpriteInfo() {
        currentEnemy = enemyList[currentArrayPos]
        
        if currentEnemy == "Asteroid" {
            cometTrail?.isHidden = true
            coreEffect?.isHidden = true
            enemySprite?.texture = SKTexture(imageNamed: "crater12")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theAsteroidText_1")
            enemyDescription?.text = "A big chunk of space rock that can do a lot of damage."
        } else if currentEnemy == "UFO" {
            cometTrail?.isHidden = true
            coreEffect?.isHidden = true
            enemySprite?.texture = SKTexture(imageNamed: "Ufo_1")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theUFOText_1")
            enemyDescription?.text = "An angry UFO.  They hate humans."
        } else if currentEnemy == "Comet" {
            coreEffect?.isHidden = true
            enemySprite?.texture = SKTexture(imageNamed: "comet_1")
            cometTrail?.zPosition = 5.0
            cometTrail?.isHidden = false
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theCometText_1")
            enemyDescription?.text = "A large, angry, and deadly ice cube."
        }  else if currentEnemy == "SpaceMine" {
            coreEffect?.isHidden = true
            cometTrail?.isHidden = true
            enemySprite?.texture = SKTexture(imageNamed: "SpaceMine_1")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theSpaceMineText_1")
            enemyDescription?.text = "A Space Mine.  Very explosive personality."
        } else if currentEnemy == "StellarCore" {
            coreEffect?.isHidden = false
            cometTrail?.isHidden = true
            enemySprite?.texture = SKTexture(imageNamed: "StellarCoreFragment_1")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theStellarCoreText_1")
            enemyDescription?.text = "A chunk of exploded star.  Very hot."
        } else if currentEnemy == "SpaceVirus" {
            coreEffect?.isHidden = true
            cometTrail?.isHidden = true
            enemySprite?.texture = SKTexture(imageNamed: "SpaceVirus")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theSpaceVirusText_1")
            enemyDescription?.text = "These space viruses are huge."
        } else if currentEnemy == "MicroBlackHole" {
            coreEffect?.isHidden = true
            cometTrail?.isHidden = true
            enemySprite?.texture = SKTexture(imageNamed: "microBlackHole_1")
            enemySpriteDescription?.texture = SKTexture(imageNamed: "theBlackHoleText_1")
            enemyDescription?.text = "Micro Black Holes will rip you apart."
        }
    }
}
