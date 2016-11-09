//
//  Projectiles.swift
//  Star Shooter
//
//  Created by Tim Gleason on 9/27/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import Foundation
import SpriteKit

// spawn the laser
func spawnLaser(_ gScene: GameScene) {
    
    // the laser that will be fired, set to a defualt value
    var laser = SKSpriteNode(imageNamed: "laser2")
    
    // second laser, if necessary, set to a default value
    var laser2 = SKSpriteNode(imageNamed: "laser2")
    
    // emitter node for laser effect, set to a default value
    var laserEffect = SKEmitterNode(fileNamed: "ProjectileEffect_1")
    
    // second laser effect
    var laserEffect2 = SKEmitterNode(fileNamed: "ProjectileEffect_2")
    
    // default for retreiving the ship type
    let userDefaults = UserDefaults.standard
    
    // the type of ship that was selected
    let shipName = userDefaults.string(forKey: "shipName")
    
    // set the laser type based on the ship that was selected
    if shipName == "alcubierre" {
        // emitter node for laser effect
        laserEffect = SKEmitterNode(fileNamed: "ProjectileEffect_1")
        
        // Create a laser
        laser = SKSpriteNode(imageNamed: "laser2")
        laser.position = CGPoint(x: (gScene.currentShip?.position.x)!, y: (gScene.currentShip?.position.y)! + 175)
        laser.xScale = 0.15
        laser.yScale = 0.25
        laser.zPosition = -1
        
        // add the laser effect
        laser.addChild(laserEffect!)
        
        // add the laser
        gScene.addChild(laser)
        
        // laser sound
        let playLaserSound = SKAction.playSoundFileNamed("laser_1.wav", waitForCompletion: false)
        
        // Set up laser physics body info
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.usesPreciseCollisionDetection = true
        
        // speed of the laser
        let actualDuration = 8.0
        
        // create actions
        let actionMove = SKAction.move(to: CGPoint(x: (gScene.currentShip?.position.x)!, y: 2000), duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()
        laser.run(actionMove)
        laser.run(SKAction.sequence([playLaserSound, actionMove, actionMoveDone]))
        
    } else if shipName == "blueness" {
        // emitter nodes for laser effect
        laserEffect = SKEmitterNode(fileNamed: "ProjectileEffect_2")
        laserEffect2 = SKEmitterNode(fileNamed: "ProjectileEffect_2")
        
        // Create a laser
        laser = SKSpriteNode(imageNamed: "laser_3")
        laser.position = CGPoint(x: (gScene.currentShip?.position.x)! + 75, y: (gScene.currentShip?.position.y)! + 110)
        laser.xScale = 0.15
        laser.yScale = 0.15
        laser.zPosition = -1
        
        // add the laser effect
        laser.addChild(laserEffect!)
        
        // create a second laser
        laser2 = SKSpriteNode(imageNamed: "laser_3")
        laser2.position = CGPoint(x: (gScene.currentShip?.position.x)! - 75, y: (gScene.currentShip?.position.y)! + 110)
        laser2.xScale = 0.15
        laser2.yScale = 0.15
        laser2.zPosition = -1
        
        // add the second laser effect
        laser2.addChild(laserEffect2!)
        
        // add the laser
        gScene.addChild(laser)
        
        // add the second laser
        gScene.addChild(laser2)
        
        // laser sound
        let playLaserSound = SKAction.playSoundFileNamed("laser_2.wav", waitForCompletion: false)
        
        // Set up laser physics body info
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.usesPreciseCollisionDetection = true
        
        // set up the second laser physics body
        laser2.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser2.physicsBody?.isDynamic = true
        laser2.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        laser2.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        laser2.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser2.physicsBody?.usesPreciseCollisionDetection = true
        
        // speed of the laser
        let actualDuration = 9.0
        
        // create actions
        let actionMove = SKAction.move(to: CGPoint(x: (gScene.currentShip?.position.x)! + 100, y: 2000), duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()
        laser.run(actionMove)
        laser.run(SKAction.sequence([playLaserSound, actionMove, actionMoveDone]))
        
        // actions for the second laser
        let actionMove2 = SKAction.move(to: CGPoint(x: (gScene.currentShip?.position.x)! - 100, y: 2000), duration: actualDuration)
        let actionMoveDone2 = SKAction.removeFromParent()
        laser2.run(actionMove2)
        laser2.run(SKAction.sequence([playLaserSound, actionMove2, actionMoveDone2]))
    } else if shipName == "hammer" {
        // emitter node for laser effect
        laserEffect = SKEmitterNode(fileNamed: "ProjectileEffect_3")
        //laserEffect?.zPosition = 3
        
        // Create a laser
        laser = SKSpriteNode(imageNamed: "laser_4")
        laser.position = CGPoint(x: (gScene.currentShip?.position.x)!, y: (gScene.currentShip?.position.y)! + 180)
        laser.xScale = 0.15
        laser.yScale = 0.15
        laser.zPosition = -1
        
        // add the laser effect
        laser.addChild(laserEffect!)
        
        // add the laser
        gScene.addChild(laser)
        
        // laser sound
        let playLaserSound = SKAction.playSoundFileNamed("laser_3.wav", waitForCompletion: false)
        
        // Set up laser physics body info
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.usesPreciseCollisionDetection = true
        
        // speed of the laser
        let actualDuration = 6.0
        
        // create actions
        let actionMove = SKAction.move(to: CGPoint(x: (gScene.currentShip?.position.x)!, y: 1300), duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()
        laser.run(actionMove)
        laser.run(SKAction.sequence([playLaserSound, actionMove, actionMoveDone]))
    } else if shipName == "sidewinder" {
        // emitter node for laser effect
        laserEffect = SKEmitterNode(fileNamed: "ProjectileEffect_4")
        //laserEffect?.zPosition = 3
        
        // Create a laser
        laser = SKSpriteNode(imageNamed: "laser_5")
        laser.position = CGPoint(x: (gScene.currentShip?.position.x)! + 70, y: (gScene.currentShip?.position.y)! + 147)
        laser.xScale = 0.15
        laser.yScale = 0.15
        laser.zPosition = -1
        
        // add the laser effect
        laser.addChild(laserEffect!)
        
        // add the laser
        gScene.addChild(laser)
        
        // laser sound
        let playLaserSound = SKAction.playSoundFileNamed("laser_4.wav", waitForCompletion: false)
        
        // Set up laser physics body info
        laser.physicsBody = SKPhysicsBody(rectangleOf: laser.size)
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        laser.physicsBody?.contactTestBitMask = PhysicsCategory.Asteroid
        laser.physicsBody?.collisionBitMask = PhysicsCategory.None
        laser.physicsBody?.usesPreciseCollisionDetection = true
        
        // speed of the laser
        let actualDuration = 6.0
        
        // create actions
        let actionMove = SKAction.move(to: CGPoint(x: (gScene.currentShip?.position.x)! + 90, y: 1300), duration: actualDuration)
        let actionMoveDone = SKAction.removeFromParent()
        laser.run(actionMove)
        laser.run(SKAction.sequence([playLaserSound, actionMove, actionMoveDone]))
    }
}
