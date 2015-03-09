//
//  RecordSoundsViewController.swift
//  Pitch-Perfect
//
//  Created by David on 3/4/15.
//  Copyright (c) 2015 David Fry. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
{

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recoredAudioFile: RecoredAudio!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        

       
        
        
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.stopButton.hidden = true
        self.recordButton.enabled = true
    }
    

    @IBAction func recordAudio(sender: UIButton)
    {
        
        // Display buttons
        self.recordingLabel.hidden = false
        self.stopButton.hidden = false
        self.recordButton.enabled = false
        
        // Path to save file
        let dirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filepath = NSURL.fileURLWithPathComponents(pathArray)

        println(filepath!)
        
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: nil, error: nil)
        
        // init and prepare the recorder
        self.audioRecorder = AVAudioRecorder(URL: filepath, settings: nil, error: nil)
        self.audioRecorder.delegate = self
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
    }

    @IBAction func stopButtonPressed(sender: UIButton)
    {
        self.recordingLabel.hidden = true
        self.stopButton.hidden = true
        self.audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if (flag)
        {
            // Save audio file
            self.recoredAudioFile = RecoredAudio()
            self.recoredAudioFile.filePathURL = recorder.url
            self.recoredAudioFile.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("stopRecording", sender: self.recoredAudioFile)
        }
        else
        {
            println("There was and error saving your file")
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "stopRecording"
        {
            let playSoundVC = segue.destinationViewController as PlaySoundsViewController
            playSoundVC.recivedAudio = sender as RecoredAudio
        }
        
    }
}

