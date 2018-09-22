//
// RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Manpreet on 03/09/18.
//  Copyright © 2018 Manpreet. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecording.isEnabled=false
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(_ sender: Any) {
        configureUi(true)
        let dir=NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as String
        let recName="recordedVoice.wav"
        let pathArray=[dir, recName]
        let filePath=URL(string: pathArray.joined(separator:"/"))
        let session=AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord,with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!,settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled=true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
     
    }

    @IBAction func stopRecording(_ sender: Any) {
        configureUi(false)
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    func configureUi(_ recording: Bool){
        stopRecording.isEnabled=recording
        record.isEnabled = !recording
        recordingLabel.text = recording ? "Recording started" : "Tap to record"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    func audioRecorderDidFinishRecording(_: AVAudioRecorder,successfully flag: Bool){
        if(flag){
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("recording failed")
        }
    }
    
    
}

