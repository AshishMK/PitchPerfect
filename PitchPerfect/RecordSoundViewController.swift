//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Ashish Nautiyal on 7/25/18.
//  Copyright © 2018 Ashish  Nautiyal. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    //Mark: Properties
    var audioRecorder:AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordButton.imageView?.contentMode = .scaleAspectFit
        recordButton.contentMode = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var i:Int=0
    @IBAction func recordAudio(_ sender: Any) {
        if  audioRecorder==nil || !audioRecorder.isRecording {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
            checkMicrophonePermission(session)
       }
        else {
            audioRecorder.stop()
            let session = AVAudioSession.sharedInstance()
            try! session.setActive(false)
            
        }
        configureUI(isRecording: audioRecorder.isRecording )
    }
    
    func checkMicrophonePermission(_ session:AVAudioSession){
        switch session.recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            audioRecorder.record()
        case AVAudioSessionRecordPermission.denied:
            print("Pemission denied")
        case AVAudioSessionRecordPermission.undetermined:
            print("Request permission here")
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                // Handle granted'
                self.audioRecorder.record()
            })
        }}
    
    func configureUI(isRecording:Bool) {
        if isRecording{
            recordingLabel.text="Tap to stop recording"
            recordButton.setImage(UIImage(named: "Stop.png"), for: .normal)
    }else{
              recordButton.setImage(UIImage(named: "RecordButton.png"), for: .normal)
       recordingLabel.text="Tap to start recording"
        }
    }

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recordind was not successful")
        
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"
        {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL=sender as! URL
            playSoundVC.recordedAudioURL=recordedAudioURL
        }
    }
}

