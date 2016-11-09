//
//  UserMusic.swift
//  Warp Shooter
//
//  Created by Tim Gleason on 10/24/16.
//  Copyright © 2016 Tim Gleason. All rights reserved.
//

import Foundation
import StoreKit
import MediaPlayer

//application music player
let applicationMusicPlayer = MPMusicPlayerController.applicationMusicPlayer()

// ask for permission to access music library on device
func requestMusicLibraryAccess() {
    SKCloudServiceController.requestAuthorization({(status: SKCloudServiceAuthorizationStatus) in
        
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized:
            print("User is already authorized.")
            return
        case .denied:
            print("The user has selected 'Don't Allow' in the past, so we're going to show them a different dialog to push them through to their Settings page and change their mind, and exit the function early.")
            // show alert
            return
        case .notDetermined:
            print("The user hasn't decided yet - so we'll break out of the switch and ask them.")
            break
        case .restricted:
            print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
            return
        }
        
        switch status {
        case .authorized: print("Access granted.")
        case .denied, .restricted: print("Access denied or restricted.")
        case .notDetermined: print("Access cannot be determined")
        }
    })
}

// check app's authorization status for the music library on the device
func checkMusicLibraryAuthorizationStatus() {
    switch SKCloudServiceController.authorizationStatus() {
    case .authorized: print("Access granted.")
    case .notDetermined:
        //requestAuthorization()
        print("request authorization")
    case .denied, .restricted: print("Access denied or restricted.")
    }
}

func appleMusicCheckIfDeviceCanPlayback() {
    let serviceController = SKCloudServiceController()
    serviceController.requestCapabilities(completionHandler: {(capabilities: SKCloudServiceCapability, error: NSError?) in
        
        if capabilities.contains(SKCloudServiceCapability.musicCatalogPlayback) {
            print("The device allows playback of Apple Music catalog.")
        }
        
        if capabilities.contains(SKCloudServiceCapability.addToCloudMusicLibrary) {
            print("The device allows tracks to be added to the user's music library.")
        }
        
    } as! (SKCloudServiceCapability, Error?) -> Void)
}

// playback a track
func appleMusicPlayTrackID(ids: [String]) {
    applicationMusicPlayer.setQueueWithStoreIDs(ids)
    applicationMusicPlayer.play()
}



