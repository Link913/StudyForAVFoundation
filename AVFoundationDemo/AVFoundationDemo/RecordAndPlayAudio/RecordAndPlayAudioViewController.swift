//
//  RecordAndPlayAudioViewController.swift
//  AVFoundationDemo
//
//  Created by Link on 2019/7/28.
//  Copyright © 2019 Link. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAndPlayAudioViewController: UIViewController {

    private lazy var recordButton = createButton(title: "record", sel: #selector(record))
    private lazy var playRecordButton = createButton(title: "play record", sel: #selector(playRecord))
    private lazy var stopRecordButton = createButton(title: "stop record", sel: #selector(stopRecord))
    private lazy var playMP3Button = createButton(title: "play mp3", sel: #selector(playMP3))
    
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(recordButton)
        recordButton.frame = CGRect(x: 0, y: 100, width: 100, height: 48)
        
        view.addSubview(stopRecordButton)
        stopRecordButton.frame = CGRect(x: 150, y: 100, width: 100, height: 48)
        
        view.addSubview(playRecordButton)
        playRecordButton.frame = CGRect(x: 0, y: 150, width: 100, height: 48)
        
        
        view.addSubview(playMP3Button)
        playMP3Button.frame = CGRect(x: 0, y: 200, width: 100, height: 48)
    }

}

private extension RecordAndPlayAudioViewController {
    @objc
    func record() {
        
        // globe config
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            print(error)
        }
        
        let recordPath = getPath()
        let recordUrl = URL(string: recordPath!)
        
        // AVAudioSettings.h
        recorder = try! AVAudioRecorder(url: recordUrl!, settings: [AVFormatIDKey: kAudioFormatMPEG4AAC,
                                                                    AVSampleRateKey: 42100,
                                                                    AVLinearPCMBitDepthKey: 16])
        // get sound db. max: 0db min: -160db
        recorder?.isMeteringEnabled = true
        recorder?.record()
    }
    
    @objc
    func stopRecord() {
        recorder?.stop()
    }
    
    @objc
    func playRecord() {
        let playPath = getPath()
        let playUrl = URL(string: playPath!)
        player = try! AVAudioPlayer(contentsOf: playUrl!)
        player!.play()
    }
    
    @objc
    func playMP3() {
        let fileUrl = Bundle.main.url(forResource: "1", withExtension: "mp3")
        do {
            player = try AVAudioPlayer(contentsOf: fileUrl!)
            player!.play()
        } catch let error {
            print(error)
        }
    }
    
    func getPath() -> String? {
        guard let directorPath = getRecordDirectorPath(directoryName: "RecordAndPlay") else {return nil}
        let path = directorPath + "/" + "record.aac"
        return path
    }
    
    func getRecordDirectorPath(directoryName: String) -> String? {
        guard let directorPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        let directorURL = NSURL(fileURLWithPath: directorPath)
        if let pathComponent = directorURL.appendingPathComponent(directoryName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            var isDir: ObjCBool = false
            
            if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
                return filePath
            } else {
                do {
                    try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
                    return filePath
                } catch {
                    print("🎵🎵🎵 音频文件夹创建失败：\(error.localizedDescription)")
                }
            }
        }
        return nil
    }
}

private extension RecordAndPlayAudioViewController {
    func createButton(title: String, sel: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: sel, for: .touchUpInside)
        return button
    }
}
