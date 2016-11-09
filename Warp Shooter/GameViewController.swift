//
//  GameViewController.swift
//  Warp Shooter
//
//  Created by Tim Gleason on 10/1/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import ReplayKit

class GameViewController: UIViewController, RPPreviewViewControllerDelegate {
    
    // is the user recording gameplay
    var isRecording = false

    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'StartScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "StartScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameStartScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    //view.showsFPS = true
                    //view.showsNodeCount = true
                }
            }
        }
    }

    @IBAction func recordButtonPressed(_ sender: UIButton) {
        isRecording = !isRecording
        
        if isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
    
    // start recording gameplay
    func startRecording() {
        let recorder = RPScreenRecorder.shared()
        
        recorder.startRecording{[unowned self] (error) in
            if let unwrappedError = error {
                print(unwrappedError.localizedDescription)
            } else {
                let recordingIcon = UIImage(named: "cameraOnIcon")
                self.recordButton.setImage(recordingIcon, for: UIControlState.normal)
            }
        }
    }
    
    // stop recording gameplay
    func stopRecording() {
        let recorder = RPScreenRecorder.shared()
        
        let offIcon = UIImage(named: "cameraOffIcon")
        
        recordButton.setImage(offIcon, for: UIControlState.normal)
        
        recorder.stopRecording{[unowned self] (preview, error) in
            if let unwrappedPreview = preview {
                unwrappedPreview.previewControllerDelegate = self
                self.present(unwrappedPreview, animated: true)
            }
        }
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
