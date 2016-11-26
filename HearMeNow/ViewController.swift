//
//  ViewController.swift
//  HearMeNow
//
//  Created by Sean Fulcher on 11/26/16.
//  Copyright © 2016 Sean Fulcher. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
   
    var hasRecording = false
    var soundPlayer : AVAudioPlayer?
    var soundRecorder : AVAudioRecorder?
    var session : AVAudioSession?
    var soundPath : String?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordPressed(sender: AnyObject) {
        if(soundRecorder?.recording == true)
        {
            soundRecorder?.stop()
            recordButton.setTitle("Record", forState: UIControlState.Normal)
            hasRecording = true
        }
        else
        {
            session?.requestRecordPermission(){
                granted in
                if(granted == true)
                {
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", forState: UIControlState.Normal)
                }
                else
                {
                    print("Unable to record")
                }
            }
        }
    }
    @IBAction func playPressed(sender: AnyObject) {
        if(soundPlayer?.playing == true)
        {
            soundPlayer?.pause()
            playButton.setTitle("Play", forState: UIControlState.Normal)
        }
        else if (hasRecording == true)
        {
            let url = NSURL(fileURLWithPath: soundPath!)
            var error : NSError?
            
            do{
            soundPlayer = try AVAudioPlayer(contentsOfURL: url)
            }
            catch {
                print("Error initializing player \(error)")
            }
            soundPlayer?.delegate = self
            soundPlayer?.play()
            
            playButton.setTitle("Pause", forState: UIControlState.Normal)
            hasRecording = false
        }
        else if (soundPlayer != nil)
        {
            soundPlayer?.play()
            playButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        soundPath = "\(NSTemporaryDirectory())hearmenow.wav"
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue];
        
        let url = NSURL(fileURLWithPath: soundPath!)
        do{
        session = AVAudioSession.sharedInstance()
        try session?.setActive(true)
        
        var error : NSError?
        
        try session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        soundRecorder = try AVAudioRecorder(URL: url, settings: settings)
            
        }
        catch{
            print("Error intializing the recorder: \(error)")
        }
        
       soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        recordButton.setTitle("Record", forState: UIControlState.Normal)
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", forState: UIControlState.Normal)
    }

}

