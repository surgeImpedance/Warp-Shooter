//
//  Effects.swift
//  Star Shooter
//
//  Created by Tim Gleason on 9/19/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//
//  Functions and modules for game effects


import Foundation
import SpriteKit

let shipExhaustEffect_1 = SKEmitterNode(fileNamed: "ShipExhaust1")
let shipExhaustEffect_blueness1 = SKEmitterNode(fileNamed: "ShipExhaust2")
let shipExhaustEffect_blueness2 = SKEmitterNode(fileNamed: "ShipExhaust2")
let shipExhaustEffect_3 = SKEmitterNode(fileNamed: "shipExhaust3")
let shipExhaustEffect_sidewinder1 = SKEmitterNode(fileNamed: "ShipExhaust4")
let shipExhaustEffect_sidewinder2 = SKEmitterNode(fileNamed: "ShipExhaust4")

// default for storing and retrieving the ship name
let userDefaults = UserDefaults.standard

// current ship's exhaust, set to a default of shipExhaustEffect_1
var currentShipExhaust = shipExhaustEffect_1

// a second exhaust, if necessary
var currentShipExhaust2 = shipExhaustEffect_1

// explosion effect
func explosion(_ pos: CGPoint, gScene: GameScene) {
    let emitterNode = SKEmitterNode(fileNamed: "Explosion1")
    
    // asteroid explosion sound
    let playAsteroidExplosionSound = SKAction.playSoundFileNamed("asteroidExplosion_1.mp3", waitForCompletion: true)
    
    // show explosion at the same position as the asteroid and play explosion sound
    emitterNode?.particlePosition = pos
    gScene.addChild(emitterNode!)
    gScene.run(playAsteroidExplosionSound)
    
    gScene.run(SKAction.wait(forDuration: 2), completion: {
        emitterNode?.removeFromParent()
    })
}

// set the ship exhaust effect
func setShipExhaust() {
    // ship name
    let shipName = userDefaults.string(forKey: "shipName")
    
    if shipName == "alcubierre" {
        currentShipExhaust = shipExhaustEffect_1
        currentShipExhaust2 = shipExhaustEffect_1
    } else if shipName == "blueness" {
        currentShipExhaust = shipExhaustEffect_blueness1
        currentShipExhaust2 = shipExhaustEffect_blueness2
        
        // resize the ship exhaust effect
        currentShipExhaust?.xScale = 0.75
        currentShipExhaust2?.xScale = 0.75
    } else if shipName == "hammer" {
        currentShipExhaust = shipExhaustEffect_3
    } else if shipName == "sidewinder" {
        currentShipExhaust = shipExhaustEffect_sidewinder1
        currentShipExhaust2 = shipExhaustEffect_sidewinder2
        
        // resize the ship exhaust effect
        currentShipExhaust?.xScale = 0.75
        currentShipExhaust2?.xScale = 0.75
    }
}

// ship explosion effect
func shipExplosion(_ gScene: GameScene) {
    let shipExplosionEmitterNode = SKEmitterNode(fileNamed: "ShipExplosion")
    
    // spaceship explosion sound
    let playShipExplosionSound = SKAction.playSoundFileNamed("shipExplosion_2.wav", waitForCompletion: false)
    
    // show explosion at the same position as the ship and play explosion sound
    shipExplosionEmitterNode?.particlePosition = (gScene.currentShip?.position)!
    gScene.addChild(shipExplosionEmitterNode!)
    gScene.run(playShipExplosionSound)
    
    gScene.run(SKAction.wait(forDuration: 10), completion: {
        shipExplosionEmitterNode?.removeFromParent()
    })
}

// ship exhaust effect
func shipExhaustEffect(_ gScene: GameScene) {
    
    // ship name
    let shipName = userDefaults.string(forKey: "shipName")
    
    // set the ship exhaust, based on which ship has been selected
    setShipExhaust()
    
    // add the exhaust to the ship
    currentShipExhaust?.position.x = (gScene.currentShip?.position.x)!
    currentShipExhaust?.position.y = (gScene.currentShip?.position.y)! - 112
    currentShipExhaust?.zPosition = -2
    
    gScene.addChild(currentShipExhaust!)
    
    if shipName == "blueness" || shipName == "sidewinder" {
        gScene.addChild(currentShipExhaust2!)
    }
}


func updateShipExhaustPosition (_ gScene: GameScene) {
    // ship name
    let shipName = userDefaults.string(forKey: "shipName")
    
    if shipName == "alcubierre" {
        currentShipExhaust?.position.x = (gScene.currentShip?.position.x)!
        currentShipExhaust?.position.y = (gScene.currentShip?.position.y)! - 112
    } else if shipName == "blueness" {
        currentShipExhaust?.position.x = ((gScene.currentShip?.position.x)! + 14.5)
        currentShipExhaust?.position.y = (gScene.currentShip?.position.y)! - 132
        
        currentShipExhaust2?.position.x = ((gScene.currentShip?.position.x)! - 14.5)
        currentShipExhaust2?.position.y = ((gScene.currentShip?.position.y)! - 132)
    } else if shipName == "hammer" {
        currentShipExhaust?.position.x = (gScene.currentShip?.position.x)!
        currentShipExhaust?.position.y = (gScene.currentShip?.position.y)! - 140
    } else if shipName == "sidewinder" {
        currentShipExhaust?.position.x = (gScene.currentShip?.position.x)! - 15
        currentShipExhaust?.position.y = (gScene.currentShip?.position.y)! - 142
        
        currentShipExhaust2?.position.x = ((gScene.currentShip?.position.x)! - 45)
        currentShipExhaust2?.position.y = ((gScene.currentShip?.position.y)! - 142)
    }
    
}

// update the ship exhaust, based on whether or not the ship has been destroyed
func toggleShipExhaustStatus (_ gScene: GameScene) {
    if gScene.isPlayerAlive == false {
        shipExhaustEffect_1?.removeFromParent()
        shipExhaustEffect_blueness1?.removeFromParent()
        shipExhaustEffect_blueness2?.removeFromParent()
        shipExhaustEffect_3?.removeFromParent()
        shipExhaustEffect_sidewinder1?.removeFromParent()
        shipExhaustEffect_sidewinder2?.removeFromParent()
    }
}

// function for light flashing
func flashLight(_ withColor: UIColor, at: CGPoint, inScene: GameScene) {
    let flashingLight = SKSpriteNode(color: withColor, size: CGSize(width: 5, height: 10))
    flashingLight.position = at
    let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
    let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
    let blinkAction = SKAction.repeatForever(SKAction.sequence([fadeInAction, fadeOutAction]))
    
    inScene.addChild(flashingLight)
    flashingLight.run(blinkAction)
}

