//
//  IOPTestView.swift
//  OptiCare
//
//  Created by Isha Nagireddy on 1/14/24.
//

import UIKit
import AVFoundation
import CoreData

class IOPTestView: UIViewController {
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var analyzeButton: UIButton!
    @IBOutlet weak var decibelsOutputLabel: UILabel!
    @IBOutlet weak var decibelsLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var recordDecibelsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var averageDecibels = 0.0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var currentTest = Test()
    
    var audioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "8000HzTestTone", ofType: "mp4")!))
            audioPlayer.prepareToPlay()
            
            let audioSession = AVAudioSession.sharedInstance()
             
            do {
                try audioSession.setCategory(AVAudioSession.Category.playback)
            }
            
            catch {
                print("having trouble playing in the background")
                print(error)
            }
            

        }
        
        catch {
            print("audio final not found")
            print(error)
        }
        
    }
    @IBAction func playButtonClicked(_ sender: Any) {
        audioPlayer.play()
    }
    @IBAction func pauseButtonClicked(_ sender: Any) {
        if (audioPlayer.isPlaying) {
            audioPlayer.pause()
        }
    }
    @IBAction func restartButtonClicked(_ sender: Any) {
        if (audioPlayer.isPlaying) {
            audioPlayer.currentTime = 0
            audioPlayer.play()
        }
        
        else {
            audioPlayer.play()
        }
    }
    @IBAction func analyzeButtonClicked(_ sender: Any) {
        
        if (IOPTestView.averageDecibels != 0.0) {
            let currentTest = Test(context: self.context)
            currentTest.decibels = IOPTestView.averageDecibels
            currentTest.pressure = currentTest.decibels
            IOPTestView.averageDecibels = 0
            
            // save the data
            do {
                try self.context.save()
            }
            
            catch {
                print(error)
            }
            
            performSegue(withIdentifier: "toResultsView", sender: nil)
            
        }
        
        else {
            // create the alert
            let alert = UIAlertController(title: "Test Not Saved", message: "This test will not be saved in data because the average decibels recorded were 0.0dB. Press 'Continue' to see the rest of your entries.", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: { action in
                self.performSegue(withIdentifier: "toResultsView", sender: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    @IBAction func deicbelsButtonClicked(_ sender: Any) {
        var secondsRemaining = 10
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if (secondsRemaining > 0 && self.audioPlayer.isPlaying) {
                    self.decibelsLabel.text = "Recording decibels in \(secondsRemaining)...."
                    secondsRemaining -= 1
                }
            
            else if (!self.audioPlayer.isPlaying) {
                Timer.invalidate()
                // create the alert
                let alert = UIAlertController(title: "Audio Not Playing", message: "You cannot record decibels without the audio playing the background. Make sure you press the play button above.", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            }
            
            else {
                    self.decibelsLabel.text = "Recorded number of decibels reflected from your eye"
                    Timer.invalidate()
                    self.setUpAudioCapture()
                }
            }
                
        
    }
    
    private func setUpAudioCapture() {
                
            let recordingSession = AVAudioSession.sharedInstance()
                
            do {
                try recordingSession.setCategory(.playAndRecord)
                try recordingSession.setActive(true)
                    
                recordingSession.requestRecordPermission({ result in
                        guard result else { return }
                })
                    
                captureAudio()
                    
            } catch {
                print("ERROR: Failed to set up recording session.")
            }
        }
    
    private func captureAudio() {
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilename = documentPath.appendingPathComponent("recording.m4a")
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                
                let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.record()
                audioRecorder.isMeteringEnabled = true
                
                var capturingTime = 100
                var counter = 0
                
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
                    if (capturingTime > 0 && self.audioPlayer.isPlaying) {
                        audioRecorder.updateMeters()
                        let db = audioRecorder.averagePower(forChannel: 0)
                        IOPTestView.averageDecibels += Double(db)
                        self.decibelsOutputLabel.text = String(db)
                        capturingTime = capturingTime - 1
                        counter += 1
                    }
                    
                    else if (!self.audioPlayer.isPlaying) {
                        Timer.invalidate()
                        self.decibelsOutputLabel.text = "0.00dB"
                        // create the alert
                        let alert = UIAlertController(title: "Audio Not Playing", message: "You cannot record decibels without the audio playing the background. Make sure you press the play button above. Please rerecord.", preferredStyle: UIAlertController.Style.alert)
                        
                        // add the actions (buttons)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    else {
                        Timer.invalidate()
                        IOPTestView.averageDecibels = IOPTestView.averageDecibels / Double(counter)
                        self.decibelsLabel.text = "The average recorded decibels has been collected:"
                        let finalAverage = String(format: "%.4f", IOPTestView.averageDecibels)
                        self.decibelsOutputLabel.text = "\(finalAverage)dB"
                        IOPTestView.averageDecibels = Double(finalAverage)!
                    }
                }
            }
        
        catch {
                print("ERROR: Failed to start recording process.")
            }
        }
}
