//
//  ViewController.swift
//  iOS-AudioRecorder
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018 HelloTalk. All rights reserved.
//

//Standard UI Kit
import UIKit
// Module with AV Functions
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var play: UIButton!
    
    //AVAudioRecorder provides audio recording capability.
    var audioRecorder: AVAudioRecorder!
    //AVAudioPlayer plays back audio from file or memory.
    var audioPlayer: AVAudioPlayer!
    var fileName : String = "audio.m4a"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingSetup()
        play.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDocumentsDirector() -> URL {
        // Grab CWD and set to paths
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func recordingSetup() {
        let recordSetting = [AVFormatIDKey : kAudioFormatAppleLossless, AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue, AVEncoderBitRateKey : 32000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.2] as [String: Any] //Why??
        // Append the filename to path
        let audioFileName = getDocumentsDirector().appendingPathComponent(fileName)
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: recordSetting)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    func playerSetup() {
        let audioFileName = getDocumentsDirector().appendingPathComponent(fileName)
        
        do {
            // Whats going on here? Defining a constant does not resolve the indentifier in the function call
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1
    
        } catch {
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        record.isEnabled = true
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        play.isEnabled = true
        play.setTitle("Playing", for : .normal)
    }
    
    
    @IBAction func recordAction(_ sender: Any) {
        // UI Label needs to be marked with '?'
        if record.titleLabel?.text == "Record" {
            audioRecorder.record()
            // UIControlState --> .normal
            record.setTitle("Stop", for: .normal)
            play.isEnabled = false
            
        } else {
            audioRecorder.stop()
            record.setTitle("Record", for: .normal)
            play.isEnabled = false
        }
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        if play.titleLabel?.text == "Play" {
            play.setTitle("Stop", for: .normal)
            record.isEnabled = false
            playerSetup()
            soundPlayer.start()
        } else {
            playerSetup()
            soundPlayer.stop()
            play.setTitle("Play", for: .normal)
        }
    }

}
