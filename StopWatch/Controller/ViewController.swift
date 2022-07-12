//
//  ViewController.swift
//  StopWatch
//
//  Created by Arstanbaeva Aisuluu on 04.07.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var stopWatchImage: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    
    private var seconds = 0
    private var minutesInSec = 0
    private var hoursInSec = 0
    private var isTimer = true
    private var hasStarted = false
    private var timerLogic  =  TimerLogic()
    private var player : AVAudioPlayer!
   
    
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.alpha = 0
    
    }
    
    @IBAction func switchPressed(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            isTimer = true
            pickerView.alpha = 0
            stopWatchImage.image = UIImage(systemName: "timer")
           
     
        case 1 :
            isTimer = false
           pickerView.alpha = 1
           stopWatchImage.image = UIImage(systemName: "stopwatch")
           
           
         
        default:
            break
        }
        playButton.isEnabled = true
        pauseButton.isEnabled = true
        timerLogic.setIsTimer(isTimer)
   }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch (sender.currentTitle) {
        case "pause" :
            playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: UIControl.State.normal)
            pauseButton.currentBackgroundImage == UIImage(systemName: "pause.circle.fill") ?
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: UIControl.State.normal) :
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: UIControl.State.normal)
            pause()
            pauseButton.isEnabled = false
            playButton.isEnabled = true
            
            
        case "play":
            timer.invalidate()
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: UIControl.State.normal)
            playButton.currentBackgroundImage == UIImage(systemName: "play.circle.fill") ?
            playButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: UIControl.State.normal) :
            playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: UIControl.State.normal)
            timerStart()
            playButton.isEnabled = false
            pauseButton.isEnabled = true
           
           
                
        default:
            playButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: UIControl.State.normal)
            pauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: UIControl.State.normal)
            reset()
            playButton.isEnabled = true
            pauseButton.isEnabled = true
            
        }
    }
    
    func timerStart(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        pickerView.alpha = 0
        if isTimer && !hasStarted || !isTimer && !hasStarted {
            timerLogic.setSeconds(sec: hoursInSec + minutesInSec + seconds)
        }
    }
    
    func reset() {
        if !isTimer{
            pickerView.alpha = 1
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }
        timer.invalidate()
        hoursInSec = 0
        minutesInSec = 0
        seconds = 0
        timerLogic.isTime = false
        hasStarted = false
        timeLabel.text = "00:00:00"
        
    }
    
    func pause(){
        if !isTimer {
            pickerView.alpha = 1
        }
        hasStarted = true
        timer.invalidate()
    }
    
    func reInit(){
        
    }
    
    @objc func updateCounter(){
        hasStarted = true
        timeLabel.text = timerLogic.timeFormatted(timerLogic.updateTime)
        if timerLogic.isTime {
            timer.invalidate()
            timeLabel.text = "DONE!"
            playSound()
           
        }
    }
    func playSound(){
        let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        reset()
        hasStarted = false
    }
}


//MARK: - Delegate and DataSource 

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0,1,2:
            return "\(row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            hoursInSec = row * 3600
            timeLabel.text = timerLogic.timeFormatted(hoursInSec + minutesInSec + seconds)
           
        case 1:
            minutesInSec = row * 60
            timeLabel.text = timerLogic.timeFormatted(hoursInSec + minutesInSec + seconds)
            
        case 2:
            seconds = row
            timeLabel.text = timerLogic.timeFormatted(hoursInSec + minutesInSec + seconds)
            
        default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component{
        case 0:
            return 24
        case 1,2 :
            return 60
        default:
            return 0
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
}

