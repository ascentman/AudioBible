//
//  AudioVC.swift
//  TableViewExpand
//
//  Created by user on 01.04.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class AudioVC: UIViewController {

    @IBOutlet weak var imageName: UIImageView!
    
    @IBOutlet weak var pauseSong: UIButton!
    @IBOutlet weak var previousSong: UIButton!
    @IBOutlet weak var nextSong: UIButton!
    @IBOutlet weak var sliderDuration: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var connectingLabel: UILabel!
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    var book : String!
    var player:AVPlayer?
    var playerItems = [AVPlayerItem]()
    var currentTrack = 0
    var myURL : String!
    var playButton:UIButton?
    
    var imagesName = [ "frame_00.jpg", "frame_01.jpg",
                       "frame_02.jpg", "frame_03.jpg",
                       "frame_04.jpg", "frame_05.jpg",
                       "frame_06.jpg", "frame_07.jpg",
                       "frame_08.jpg", "frame_09.jpg"
    ]
    var imagesArr = [UIImage]()

    @IBAction func pauseTapped(_ sender: Any) {

        if player?.rate == 0
        {
            player!.play()
            pauseSong.setImage(UIImage(named: "pause.png"), for: .normal)
        } else {
            player!.pause()
            pauseSong.setImage(UIImage(named: "play.png"), for: .normal)
        }
    }
    @IBAction func previousTapped(_ sender: UIButton) {
        if currentTrack - 1 < 0 {
            currentTrack = (playerItems.count - 1) < 0 ? 0 : (playerItems.count - 1)
        } else {
            currentTrack -= 1
        }
    }
    @IBAction func nextTapped(_ sender: UIButton) {
//        if currentTrack + 1 > playerItems.count {
//            currentTrack = 0
//        } else {
//            currentTrack += 1;
//        }
        player?.pause()
        let myyURL = "http://bible.mypressonline.com/wp-content/uploads/NewTestament/Mark/2.mp3"
        if let locURL = URL(string: myyURL) {
            let playerItem = AVPlayerItem(url: locURL)
            playerItems.append(playerItem)
            currentTrack = 1
        }
        print(playerItems)
        playTrack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sliderDuration.minimumTrackTintColor = UIColor.white
        self.sliderDuration.maximumTrackTintColor = UIColor.darkGray
        
        self.sliderDuration.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        for img in 0..<imagesName.count {
            imagesArr.append(UIImage(named: imagesName[img])!)
        }
        imageName.animationImages = imagesArr
        imageName.animationDuration = 1.8
        imageName.startAnimating()
        
        
        if let localURL = URL(string: myURL) {
            let playerItem = AVPlayerItem(url: localURL)
            playerItems.append(playerItem)

            playTrack()
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
                print("Playback OK")
                try AVAudioSession.sharedInstance().setActive(true)
                print("Session is Active")
            } catch {
                print(error)
            }
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                self.currentTimeLabel.text = "\(minutesText):\(secondsText)"
                
                //lets move the slider thumb
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    self.sliderDuration.value = Float(seconds / durationSeconds)
                }
                
                if secondsText == "01" {
                    self.activityIndic.stopAnimating()
                    self.activityIndic.isHidden = true
                    self.connectingLabel.isHidden = true
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                self.durationLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    @objc func handleSliderChange() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(self.sliderDuration.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //perhaps do something later here
            })
        }
    }
    
    func customInit(url: String, book: String) {
        self.myURL = url
        self.book = book
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()    }
    
    func playTrack() {
        player = AVPlayer(playerItem: playerItems[currentTrack])
        if playerItems.count > 0 {
            //player?.replaceCurrentItem(with: playerItems[currentTrack])
            print("current track: \(currentTrack)")
            player?.play()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
