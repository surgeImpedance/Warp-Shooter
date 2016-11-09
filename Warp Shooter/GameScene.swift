//
//  GameScene2.swift
//  Star Shooter
//
//  Created by Tim Gleason on 9/15/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import StoreKit
import MediaPlayer

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Asteroid     : UInt32 = 0b1
    static let Projectile   : UInt32 = 0b10
    static let Ufo          : UInt32 = 0b11
    static let Comet        : UInt32 = 0b110
    static let SpaceMine    : UInt32 = 0b111
    static let CoreFrag     : UInt32 = 0b1111
    static let SpaceVirus   : UInt32 = 0b11111
    static let MicroBlackHole : UInt32 = 0b111111
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Keep track of the player's current level
    var currentGameLevel = 1
    
    // name of ship that was selected
    var shipName: String?
    
    // audio node for the background music
    var backgroundMusic: SKAudioNode!
    
    // default for storing the score
    let userDefaults = UserDefaults.standard
    
    // background sprites
    var background1: SKSpriteNode?
    var background2: SKSpriteNode?
    
    // the current ship
    //var currentShip = SKSpriteNode(imageNamed: "Alcubierre_1Selector")
    var currentShip: SKSpriteNode?
    
    // Player status.  Are you alive, or have you been killed?
    var isPlayerAlive: Bool?
    
    // background scrolling speed
    let backgroundScrollingSpeed: CGFloat = 120.0
    
    // scrolling timing
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    let motionManager: CMMotionManager = CMMotionManager()
    
    // score label
    var scoreLabel: SKLabelNode?
    
    var score = 0
    
    // keep track of how many times the user has fired
    var fireCount = 0
    
    // keep track if the laser is active or not
    var laserActive = true
    
    override func didMove(to view: SKView) {
        
        // Set the player's status to alive intially
        isPlayerAlive = true
        
        // set up the physics world
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        // set up the backgrounds
        background1 = self.childNode(withName: "StarryBackground_1") as! SKSpriteNode?
        background2 = self.childNode(withName: "StarryBackground_2") as! SKSpriteNode?
        
        // add the score label
        scoreLabel = childNode(withName: "scoreLabel") as? SKLabelNode
        
        // get the name of the selected ship
        shipName = userDefaults.string(forKey: "shipName")
        print(shipName!)
        
        // set up the starship and add the approriate background music
        if shipName == "alcubierre" {
            currentShip = SKSpriteNode(imageNamed: "Alcubierre_1Selector")
            currentShip?.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Alcubierre_1Selector"), size: (currentShip?.size)!)
            
            // set up audio node for the background music
            if let musicURL = Bundle.main.url(forResource: "WarpShooterMusic", withExtension: "wav") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
            
            // set the ship's scale
            currentShip?.xScale = 0.75
            currentShip?.yScale = 0.75
            
        }
        
        if shipName == "blueness" {
            currentShip = SKSpriteNode(imageNamed: "Ship_2")
            currentShip?.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ship_2"), size: (currentShip?.size)!)
            
            // set up audio node for the background music
            if let musicURL = Bundle.main.url(forResource: "BluenessMusic", withExtension: "wav") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
            
            // set the ship's scale
            currentShip?.xScale = 0.55
            currentShip?.yScale = 0.55
        }
        
        if shipName == "hammer" {
            currentShip = SKSpriteNode(imageNamed: "Ship_3")
            currentShip?.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ship_3"), size: (currentShip?.size)!)
            
            // set up audio node for the background music
            if let musicURL = Bundle.main.url(forResource: "HammerMusic", withExtension: "wav") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
            
            // set the ship's scale
            currentShip?.xScale = 0.53
            currentShip?.yScale = 0.53
        }
        
        if shipName == "sidewinder" {
            currentShip = SKSpriteNode(imageNamed: "Ship_4")
            currentShip?.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ship_4"), size: (currentShip?.size)!)
            
            // set up audio node for the background music
            if let musicURL = Bundle.main.url(forResource: "SidewinderMusic", withExtension: "wav") {
                backgroundMusic = SKAudioNode(url: musicURL)
                addChild(backgroundMusic)
            }
            
            // set the ship's scale
            currentShip?.xScale = 0.55
            currentShip?.yScale = 0.55
        }
        
        currentShip?.physicsBody?.isDynamic = true
        currentShip?.physicsBody?.mass = 0.02
        currentShip?.physicsBody?.allowsRotation = false
        currentShip?.name = "ship"
        currentShip?.position = CGPoint(x: 100, y: -210)
        
        addChild(currentShip!)
        
        // set up and run the flashing lights
        if shipName == "alcubierre" {
            flashLight(CGPoint(x: (currentShip?.position.x)! - 16, y: (currentShip?.position.y)! + 207))
            flashLightLeft(CGPoint(x: (currentShip?.position.x)! - 183, y: (currentShip?.position.y)! + 207))
        } else if shipName == "blueness" {
            flashLight(CGPoint(x: (currentShip?.position.x)! + 35, y: (currentShip?.position.y)! + 263))
            flashLightLeft(CGPoint(x: (currentShip?.position.x)! - 236, y: (currentShip?.position.y)! + 263))
        } else if shipName == "hammer" {
            flashLight(CGPoint(x: (currentShip?.position.x)! + 37, y: (currentShip?.position.y)! + 171))
            flashLightLeft(CGPoint(x: (currentShip?.position.x)! - 238, y: (currentShip?.position.y)! + 171))
            flashLight(CGPoint(x: (currentShip?.position.x)! - 101, y: (currentShip?.position.y)! + 171))
        } else if shipName == "sidewinder" {
            flashLight(CGPoint(x: (currentShip?.position.x)! - 155, y: (currentShip?.position.y)! + 260))
        }
        
        // start the motion manager
        motionManager.startAccelerometerUpdates()
        
        // spawn asteroids
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAsteroid), SKAction.wait(forDuration: 1.0)])))
        
        // spawn ufos
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnUfo), SKAction.wait(forDuration: 2)])))
        
        //run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addSpaceMine), SKAction.wait(forDuration: 2)])))
        
        // set up physics body for scene, so the ship doesn't go off screen
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // add the ship's exhaust
        shipExhaustEffect(self)
    }
    
    // randomizing functions
    func  random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // Spawn asteroids
    func addAsteroid() {
        
        // Create asteroid
        let asteroid = SKSpriteNode(imageNamed: "crater12")
        asteroid.name = "asteroid"
        asteroid.xScale = 0.75
        asteroid.yScale = 0.75
        
        // Set up the physics body
        asteroid.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "crater12"), size: asteroid.size)
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.categoryBitMask = PhysicsCategory.Asteroid
        asteroid.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        asteroid.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // determine where to spawn the asteroid along the X axis
        let actualX = random(-360, max: 360)
        
        // position the asteroid slightly off-screen along the top edge,
        // and along a random position along the x - axis as calculated above
        asteroid.position = CGPoint(x: actualX , y: size.height + asteroid.size.height/2)
        
        // add the asteroid to the scene
        addChild(asteroid)
        
        // determine the speed of the asterod
        //let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))
        let actualDuration = 2.0
        
        // create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -500/*-asteroid.size.height/2*/), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        asteroid.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // Spawn comets
    func addComet() {
        let smallWait = SKAction.wait(forDuration: 2)
        self.run(smallWait)
        
        // Create comet
        let comet = SKSpriteNode(imageNamed: "comet_1")
        comet.name = "comet"
        comet.xScale = 0.15
        comet.yScale = 0.15
        
        // Create the comet trail
        let cometTrail = SKEmitterNode(fileNamed: "CometTrail_1")
        cometTrail?.zPosition = 5.0
        cometTrail?.xScale = 2
        cometTrail?.yScale = 4
        comet.addChild(cometTrail!)
        
        // Set up the physics body
        comet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "comet_1"), size: comet.size)
        comet.physicsBody?.isDynamic = true
        comet.physicsBody?.categoryBitMask = PhysicsCategory.Comet
        comet.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        comet.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // determine where to spawn the asteroid along the X axis
        let actualX = random(-360, max: 360)
    
        // position the comet slightly off-screen along the top edge,
        // and along a random position along the x - axis as calculated above
        comet.position = CGPoint(x: actualX , y: size.height + comet.size.height/2)
        
        // add the asteroid to the scene
        addChild(comet)
        
        // determine the speed of the comet
        //let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))
        let actualDuration = 4.5
        
        // create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -500/*-asteroid.size.height/2*/), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        comet.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // spawn ufo
    func spawnUfo() {
        let ufo = SKSpriteNode(imageNamed: "Ufo_1")
        ufo.name = "ufo"
        ufo.xScale = 0.40
        ufo.yScale = 0.40
        
        // set up the ufo physics body
        ufo.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ufo_1"), size: ufo.size)
        ufo.physicsBody?.isDynamic = true
        ufo.physicsBody?.categoryBitMask = PhysicsCategory.Ufo
        ufo.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        ufo.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // determine where to spawn the ufo along the X axis
        let actualX = random(-360, max: 360)
        
        // position the ufo slightly off-screen along the top edge,
        // and along a random position along the x - axis as calculated above
        ufo.position = CGPoint(x: actualX , y: size.height + ufo.size.height/2)
        
        // add the ufo to the scene
        addChild(ufo)
        
        // determine the speed of the ufo
        //let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))
        let actualDuration = 5.0
        
        // create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -500/*-asteroid.size.height/2*/), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        ufo.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        // create the light on top of the ufo
        let topLight = SKSpriteNode(imageNamed: "ufo1TopFlasher")
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.60)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.60)
        let blinkAction = SKAction.sequence([fadeOutAction, fadeInAction])
        topLight.run(blinkAction)
        
    }
    
    // add space mines
    func addSpaceMine() {
        let SpaceMine = SKSpriteNode(imageNamed: "SpaceMine_1")
        SpaceMine.name = "space_mine"
        
        // set up the space mine physics body
        SpaceMine.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "SpaceMine_1"), size: SpaceMine.size)
        SpaceMine.physicsBody?.isDynamic = true
        SpaceMine.physicsBody?.categoryBitMask = PhysicsCategory.SpaceMine
        SpaceMine.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        SpaceMine.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // determine where to spawn the space mine along the X axis
        let actualX = random(-360, max: 360)
        
        // position the space mine slightly off-screen along the top edge,
        // and along a random position along the x - axis as calculated above
        SpaceMine.position = CGPoint(x: actualX , y: size.height + SpaceMine.size.height/2)
        
        // add the space mine to the scene
        addChild(SpaceMine)
        
        // determine the speed of the space mine
        //let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))
        let actualDuration = 5.0
        
        // create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -500/*-asteroid.size.height/2*/), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        SpaceMine.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // add space viruses
    func  addSpaceVirus() {
        let SpaceVirus = SKSpriteNode(imageNamed: "SpaceVirus")
        SpaceVirus.name = "space_virus"
        SpaceVirus.xScale = 0.50
        SpaceVirus.yScale = 0.50
        
        // set up the space virus physics body
        SpaceVirus.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "SpaceMine_1"), size: SpaceVirus.size)
        SpaceVirus.physicsBody?.isDynamic = true
        SpaceVirus.physicsBody?.categoryBitMask = PhysicsCategory.SpaceVirus
        SpaceVirus.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        SpaceVirus.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // determine where to spawn the space virus along the X axis
        let actualX = random(-360, max: 360)
        
        // position the space mine slightly off-screen along the top edge,
        // and along a random position along the x - axis as calculated above
        SpaceVirus.position = CGPoint(x: actualX , y: size.height + SpaceVirus.size.height/2)
        
        // add the space virus to the scene
        addChild(SpaceVirus)
        
        // determine the speed of the space virus
        //let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))
        let actualDuration = 5.0
        
        // create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -500/*-asteroid.size.height/2*/), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        SpaceVirus.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // add stellar core fragment
    func addCoreFrag() {
        let coreFrag = SKSpriteNode(imageNamed: "StellarCoreFragment_1")
        coreFrag.name = "core_frag"
        coreFrag.xScale = 0.20
        coreFrag.yScale = 0.20
        
        // add the particle effect for the core fragment
        let coreFragEffect = SKEmitterNode(fileNamed: "CoreFragEffect1")
        coreFragEffect?.zPosition = 5
        coreFrag.addChild(coreFragEffect!)
        
        // set up the core fragment physics body
        coreFrag.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "StellarCoreFragment_1"), size: coreFrag.size)
        coreFrag.physicsBody?.isDynamic = true
        coreFrag.physicsBody?.categoryBitMask = PhysicsCategory.CoreFrag
        coreFrag.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        coreFrag.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // determine where to spawn the core frag along the X axis
        let actualX = random(-360, max: 360)
        
        // position the core frag slightly off-screen along the top edge,
        // and along a random position along the x - axis as calculated above
        coreFrag.position = CGPoint(x: actualX , y: size.height + coreFrag.size.height/2)
        
        // add the core frag to the scene
        addChild(coreFrag)
        
        // determine the speed of the core frag
        //let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))
        let actualDuration = 5.0
        
        // create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -500/*-asteroid.size.height/2*/), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        coreFrag.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // add micro black hole
    func addMicroBlackHole() {
        let microBlackHole = SKSpriteNode(imageNamed: "microBlackHole_1")
        microBlackHole.name = "micro_black_hole"
        microBlackHole.xScale = 0.20
        microBlackHole.yScale = 0.20
        
        // set up the micro black hole fragment physics body
        microBlackHole.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "microBlackHole_1"), size: microBlackHole.size)
        microBlackHole.physicsBody?.isDynamic = true
        microBlackHole.physicsBody?.categoryBitMask = PhysicsCategory.MicroBlackHole
        microBlackHole.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        microBlackHole.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // determine where to spawn the micro black hole along the X axis
        let actualX = random(-360, max: 360)
        
        // position the micro black hole slightly off-screen along the top edge,
        // and along a random position along the x - axis as calculated above
        microBlackHole.position = CGPoint(x: actualX , y: size.height + microBlackHole.size.height/2)
        
        // add the micro black hole to the scene
        addChild(microBlackHole)
        
        // determine the speed of the micro black hole
        //let actualDuration = random(min: CGFloat(3.0), max: CGFloat(5.0))
        let actualDuration = 5.0
        
        // create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -500/*-asteroid.size.height/2*/), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        microBlackHole.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    // get and process accelerometer input
    func processUserMotionForUpdate(_ currentTime: CFTimeInterval) {
        if let ship = childNode(withName: "ship") as? SKSpriteNode {
            if let data = motionManager.accelerometerData {
                if fabs(data.acceleration.x) > 0.2 {
                    if shipName == "alcubierre" {
                        ship.physicsBody?.applyForce(CGVector(dx: 40.0 * CGFloat(data.acceleration.x), dy: 0))
                    } else if shipName == "blueness" {
                        ship.physicsBody?.applyForce(CGVector(dx: 10.0 * CGFloat(data.acceleration.x), dy: 0))
                    } else if shipName == "hammer" {
                        ship.physicsBody?.applyForce(CGVector(dx: 60.0 * CGFloat(data.acceleration.x), dy: 0))
                    } else if shipName == "sidewinder" {
                        ship.physicsBody?.applyForce(CGVector(dx: 45.0 * CGFloat(data.acceleration.x), dy: 0))
                    }
                }
            }
        }
    }
    
    // collision function
    func projectileDidCollideWithAsteroid(_ projectile: SKSpriteNode, asteroid: SKSpriteNode) {
        projectile.removeFromParent()
        asteroid.removeFromParent()
    }
    
    // collision delegate
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Asteroid != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) || ((firstBody.categoryBitMask & PhysicsCategory.Ufo != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) || ((firstBody.categoryBitMask & PhysicsCategory.Comet != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) || ((firstBody.categoryBitMask & PhysicsCategory.CoreFrag != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) || ((firstBody.categoryBitMask & PhysicsCategory.SpaceVirus != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) || ((firstBody.categoryBitMask & PhysicsCategory.MicroBlackHole != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
        /*if ((firstBody.categoryBitMask & PhysicsCategory.Asteroid != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) || ((firstBody.categoryBitMask & PhysicsCategory.Ufo != 0) && (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {*/
            
            if let firstNode = firstBody.node as? SKSpriteNode, let secondNode = secondBody.node as? SKSpriteNode {
                // update the score for a  hit
                if secondNode.name == "asteroid" || firstNode.name == "asteroid" || secondNode.name == "ufo" || firstNode.name == "ufo" || secondNode.name == "space_virus" || firstNode.name == "space_virus" || secondNode.name == "micro_black_hole" || firstNode.name == "micro_black_hole"{
                    score += 1
                }
                
                if secondNode.name == "comet" || firstNode.name == "comet" || secondNode.name == "space_mine" || firstNode.name == "space_mine" || secondNode.name == "core_frag" || firstNode.name == "core_frag"{
                    score += 1
                }
                
                // add explosion effect
                if secondNode.name == "asteroid" || secondNode.name == "ufo" || secondNode.name == "comet" || secondNode.name == "space_mine" || secondNode.name == "core_frag" || secondNode.name == "space_virus" || secondNode.name == "micro_black_hole"{
                    explosion(secondNode.position, gScene: self)
                    secondNode.removeFromParent()
                }
                
                if firstNode.name == "asteroid" || firstNode.name == "ufo" || firstNode.name == "comet" || firstNode.name == "space_mine" || firstNode.name == "core_frag" || firstNode.name == "space_virus" || firstNode.name == "micro_black_hole" {
                    explosion(firstNode.position, gScene: self)
                    firstNode.removeFromParent()
                }
                
                // Determine if the ship was involved in a collision
                if firstNode.name == "ship" || secondNode.name == "ship" {
                    isPlayerAlive = false
                    shipExplosion(self)
                }
                
                projectileDidCollideWithAsteroid(firstNode, asteroid: secondNode)
            }
        }
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = "\(score)"
    }
    
    // endlessly scroll the background
    func scrollBackground () {
        background1?.position.y -= backgroundScrollingSpeed * CGFloat(dt)
        background2?.position.y -= backgroundScrollingSpeed * CGFloat(dt)
        
        if (background1?.position.y)! < -(background1?.size.height)! {
            background1?.position = CGPoint(x: (background1?.position.x)! , y: (background2?.position.y)! + (background2?.size.height)!)
        }
        
        if (background2?.position.y)! < -(background2?.size.height)! {
            background2?.position = CGPoint(x: (background2?.position.x)!, y: (background1?.position.y)! + (background1?.size.height)!)
        }
    }
    
    func calculateLastUpdateTime(_ curTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = curTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = curTime
    }
    
    // Show screen if the player's ship has been destroyed.
    func showGameOverScreen() {
        if isPlayerAlive == false {
            
            // Save the current score and current level
            userDefaults.set(score, forKey: "score")
            userDefaults.set(currentGameLevel, forKey: "highest_level")
            
            // Display the game over screen
            let wait = SKAction.wait(forDuration: 3)
            let runAct = SKAction.run {
                if let gameOverScene = SKScene(fileNamed: "GameOver") {
                    gameOverScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameOverScene)
                }
            }
            
            run(SKAction.sequence([wait, runAct]))
        }
    }
    
    // function for  right light flashing
    func flashLight(_ at: CGPoint) {
        var flashingLight = SKSpriteNode()
        var duration = 0.65
        var waitDuration = 0.20
        
        if shipName == "alcubierre" {
            flashingLight = SKSpriteNode(imageNamed: "flasher1")
        } else if shipName == "blueness" {
            flashingLight = SKSpriteNode(imageNamed: "bluenessFlasher_1")
            duration = 0.75
            waitDuration = 0.30
        } else if shipName == "hammer" {
            flashingLight = SKSpriteNode(imageNamed: "hammerFlasher_1")
            duration = 0.50
            waitDuration = 0.10
        } else if shipName == "sidewinder" {
            flashingLight = SKSpriteNode(imageNamed: "sidewinderFlasher_1")
            duration = 0.30
            waitDuration = 0.50
        }
        
        flashingLight.zPosition = 3
            
        flashingLight.position = at
        let fadeInAction = SKAction.fadeIn(withDuration: duration)
        let fadeOutAction = SKAction.fadeOut(withDuration: duration)
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let blinkAction = SKAction.repeatForever(SKAction.sequence([fadeInAction, fadeOutAction, waitAction]))
            
        currentShip?.addChild(flashingLight)
        flashingLight.run(blinkAction)
    }
    
    // function for  left light flashing
    func flashLightLeft(_ at: CGPoint) {
        var flashingLight = SKSpriteNode()
        var duration = 0.65
        var waitDuration = 0.20
        
        if shipName == "alcubierre" {
            flashingLight = SKSpriteNode(imageNamed: "flasher1")
            flashingLight.zRotation = 3.14159
        } else if shipName == "blueness" {
            flashingLight = SKSpriteNode(imageNamed: "bluenessFlasher_1")
            duration = 0.75
            waitDuration = 0.30
        } else if shipName == "hammer" {
            flashingLight = SKSpriteNode(imageNamed: "hammerFlasher_1")
            duration = 0.50
            waitDuration = 0.10
        } else if shipName == "sidewinder" {
            flashingLight = SKSpriteNode(imageNamed: "sidewinderFlasher_1")
            duration = 0.30
            waitDuration = 0.50
        }
        
        flashingLight.zPosition = 3
            
        flashingLight.position = at
        let fadeInAction = SKAction.fadeIn(withDuration: duration)
        let fadeOutAction = SKAction.fadeOut(withDuration: duration)
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let blinkAction = SKAction.repeatForever(SKAction.sequence([fadeInAction, fadeOutAction, waitAction]))
            
        currentShip?.addChild(flashingLight)
        flashingLight.run(blinkAction)
    }

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if laserActive {
            fireCount += 1
            spawnLaser(self)
        }
    }
    
    // reset the fireCount, so the user can start shooting again
    func resetShipOverheat () {
        fireCount = 0
        laserActive = true
        
        let removeColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.0, duration: 0)
        currentShip?.run(removeColor)
    }
    
    override func update(_ currentTime: TimeInterval) {
        processUserMotionForUpdate(currentTime)
        
        updateScoreLabel()
        scrollBackground()
        calculateLastUpdateTime(currentTime)
        
        updateShipExhaustPosition(self)
        toggleShipExhaustStatus(self)
        
        if fireCount >= 15 {
            laserActive = false
            let shadeRed = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.25)
            currentShip?.run(shadeRed)
            var date = Date().addingTimeInterval(3)
            
            // longer delay for blueness ship
            if shipName == "blueness" {
                date = Date().addingTimeInterval(7)
            }
            
            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(resetShipOverheat), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        
        showGameOverScreen()
        
        determineCurrentLevel()
        
        // add comets after the player has surpassed the first level
        if currentGameLevel > 1 {
            // spawn comets
            
            spawnComets()
        }
        
        // add comets and space mines after the player has surpassed the second level
        if currentGameLevel > 2 {
            spawnComets()
            spawnSpaceMines()
        }
        
        // add comets, space mines, and core frags after the player has surpassed the third level
        if currentGameLevel > 3 {
            spawnSpaceMines()
            spawnComets()
            spawnCoreFrag()
        }
        
        // add comets, space mines, core frags, and space viruses after the player has surpassed the fifth level
        if currentGameLevel > 4 {
            spawnSpaceMines()
            spawnComets()
            spawnCoreFrag()
            spawnSpaceVirus()
        }
        
        // add comets, space mines, core frags, space viruses, and micro black holes after the player has surpassed the sixth level
        if currentGameLevel > 5 {
            spawnSpaceMines()
            spawnComets()
            spawnCoreFrag()
            spawnSpaceVirus()
            spawnMicroBlackHole()
        }
        
    }
    
    // figure out how far the player has progressed
    func determineCurrentLevel() {
        if score > 15 {
            currentGameLevel = 2
        }
        
        if score > 45 {
            currentGameLevel = 3
        }
        
        if score > 100 {
            currentGameLevel = 4
        }
        
        if score > 175 {
            currentGameLevel = 5
        }
        
        if score > 250 {
            currentGameLevel = 6
        }
    }
    
    // determine if a comet needs to be spawned
    func spawnComets() {
        var numberOfComets = 0
        
        for child in self.children {
            if child.name == "comet" {
                numberOfComets += 1
            }
        }
        
        if numberOfComets < 2 {
            addComet()
        }
    }
    
    // determine if a space mine needs to be spawned
    func spawnSpaceMines() {
        var numberOfSpaceMines = 0
        
        for child in self.children {
            if child.name == "space_mine" {
                numberOfSpaceMines += 1
            }
        }
        
        if numberOfSpaceMines < 2 {
            addSpaceMine()
        }
    }
    
    // determine if a core frag needs to be spawned
    func spawnCoreFrag() {
        var numberOfCoreFrags = 0
        
        for child in self.children {
            if child.name == "core_frag" {
                numberOfCoreFrags += 1
            }
        }
        
        if numberOfCoreFrags < 2 {
            addCoreFrag()
        }
    }
    
    // determine if a space virus needs to be spawned
    func spawnSpaceVirus() {
        var numberOfSpaceViruses = 0
        
        for child in self.children {
            if child.name == "space_virus" {
                numberOfSpaceViruses += 1
            }
        }
        
        if numberOfSpaceViruses < 2 {
            addSpaceVirus()
        }
    }
    
    // determine if a micro black hole needs to be spawned
    func spawnMicroBlackHole() {
        var numberOfMicroBlackHoles = 0
        
        for child in self.children {
            if child.name == "micro_black_hole" {
                numberOfMicroBlackHoles += 1
            }
        }
        
        if numberOfMicroBlackHoles < 2 {
            addMicroBlackHole()
        }
    }
}
