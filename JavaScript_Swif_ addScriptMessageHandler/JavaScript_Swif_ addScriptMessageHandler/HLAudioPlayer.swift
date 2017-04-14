//
//  HLAudioPlayer.swift
//  JavaScript_Swif_ addScriptMessageHandler
//
//  Created by xiaovv on 2017/4/9.
//  Copyright © 2017年 xiaovv. All rights reserved.
//

import UIKit
import AVFoundation

class HLAudioPlayer: NSObject {
    
    override init() {
        
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
        } catch let error as NSError{
            
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
            
        } catch let error as NSError{
            
            print(error.localizedDescription)
        }
        
    }
    

}
