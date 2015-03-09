//
//  PlaySoundsViewController.swift
//  Pitch-Perfect
//
//  Created by David on 3/6/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController
{

    
    var audio: AVAudioPlayer!
    var recivedAudio: RecoredAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        if var path = NSBundle.mainBundle().pathForResource(self.recivedAudio.title, ofType: "wav")
//        {
//            //let pathURL = NSURL(string: path)
//            self.audio = AVAudioPlayer(contentsOfURL: self.recivedAudio.filePathURL, error: nil)
//            self.audio.enableRate = true
//        }
//        else
//        {
//            println("There was an error trying to get the path")
//        }
        
        self.audio = AVAudioPlayer(contentsOfURL: self.recivedAudio.filePathURL, error: nil)
        self.audio.enableRate = true
        
        self.audioEngine = AVAudioEngine()
        
        self.audioFile = AVAudioFile(forReading: self.recivedAudio.filePathURL, error: nil)
        
        

        
    }
    
    @IBAction func playSlowAudio(sender: UIButton)
    {
        self.playAudioWithRate(self.audio, rate: 0.5)
    }

    @IBAction func playFastAudio(sender: UIButton)
    {
        self.playAudioWithRate(self.audio, rate: 2.0)
    }
    
    @IBAction func stopButtonPressed(sender: UIButton)
    {
        self.audio.currentTime = 0
        self.audio.stop()
    }
    
    @IBAction func playChipmunk(sender: AnyObject)
    {
        self.playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderSound(sender: UIButton)
    {
        self.playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithRate(audioPlayer: AVAudioPlayer, rate: Float)
    {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        self.audio.stop()
        self.audioEngine.stop()
        self.audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        self.audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        self.audioEngine.attachNode(changePitchEffect)
        
        self.audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        self.audioEngine.connect(changePitchEffect, to: self.audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(self.audioFile, atTime: nil) { () -> Void in
            
        }
        
        self.audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    
    
    
    
    
    
}
