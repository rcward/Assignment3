//
//  ViewController.swift
//  Assignment3
//
//  Created by user230914 on 2/1/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    //let date = Date()
    let hour   = (Calendar.current.component(.hour, from: Date()))
    
    @IBOutlet weak var DateTime: UILabel!
    
    @IBOutlet weak var timeremaining: UILabel!
    @IBOutlet weak var timewheel: UIDatePicker!
    
    
    
    var setTime : Date?
    var duration : Int?
    var timeLeft : Int?
    var estimatedTime : Int?
    var timer = Timer()
    var audioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var StartTimer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignbackground()
        DateTime.text = Date().formatted()
        let deflt = "01 January 2001 00:01:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "EE, dd MMM yyyy HH:mm:ss"
        setTime = dateFormatter.date(from: deflt)
        DateTime.text = dateFormatter2.string(from:Date())
        StartTimer.setTitle("Start Timer", for: .normal)
        let timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
        
    }
    
    @IBAction func Timeentered(_ sender: UIDatePicker) {
       
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        //let outputTime = dateFormatter.string(from: sender.date)
        
        setTime = sender.date
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
       // timeremaining.text = outputTime
        timer.invalidate()
        if StartTimer.currentTitle == "Stop Music"{
            audioPlayer.stop()
            StartTimer.setTitle("Start Timer", for: .normal)
            
        }
        else {
            let components = Calendar.current.dateComponents([.hour, .minute], from: setTime!)
            let hours = components.hour!
            let minutes = components.minute!
            
            timeLeft = (hours * 3600) + (minutes * 60)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
        }
    }
    @objc func tick() {
        assignbackground()
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "EE, dd MMM yyyy HH:mm:ss"
        DateTime.text = dateFormatter2.string(from:Date())
    }
    
    @objc func timeLeftString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    @objc func startCountDown() {
        if timeLeft! >= 0 {
            timeremaining.text = timeLeftString(time: TimeInterval(timeLeft!))
            timeLeft! -= 1
            
        } else {
            // invalidate timer
            playSound()
            StartTimer.setTitle("Stop Music", for: .normal)
            timer.invalidate()
            
        }
    }
    
    @objc func playSound() {
        let sound = Bundle.main.path(forResource: "clap", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch {
            print(error)
            StartTimer.setTitle("Error", for: .normal)        }
    }
    @objc func assignbackground(){
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: .zero)
            //   label.text = String(hour)
            if (hour > 17) {
                imageView.image = UIImage(named: "dusk")
            }
            else {
                imageView.image = UIImage(named: "clouds")
            }
            
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        view.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])    }
    
}

