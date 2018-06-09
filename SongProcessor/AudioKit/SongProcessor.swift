//
//  SongProcessor.swift
//  SongProcessor
//
//  Created by Aurelius Prochazka, revision history on Githbub.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import UIKit
import AudioKit
import MediaPlayer

class SongProcessor: NSObject, UIDocumentInteractionControllerDelegate {

    static let sharedInstance = SongProcessor()

    var iTunesFilePlayer: AKPlayer?
    var variableDelay = AKDelay()  //Was AKVariableDelay, but it wasn't offline render friendly!
    var delayMixer = AKDryWetMixer()
    var moogLadder = AKMoogLadder()
    var filterMixer = AKDryWetMixer()
    var reverb = AKCostelloReverb()
    var reverbMixer = AKDryWetMixer()
    var pitchShifter = AKPitchShifter()
    var pitchMixer = AKDryWetMixer()
    var bitCrusher = AKBitCrusher()
    var bitCrushMixer = AKDryWetMixer()
    var playerBooster = AKBooster()
    var offlineRender = AKOfflineRenderNode()
    var player = AKPlayer()
    var playerMixer = AKMixer()
    var isPlaying = false
    var currentLoop: LoopType?
    
    fileprivate var docController: UIDocumentInteractionController?

    var iTunesPlaying: Bool {
        set {
            if newValue {
                guard let iTunesFilePlayer = iTunesFilePlayer else { return }
                if !iTunesFilePlayer.isPlaying { iTunesFilePlayer.play() }
            } else {
                iTunesFilePlayer?.stop()
            }
        }
        get {
            return iTunesFilePlayer?.isPlaying ?? false
        }
    }
    
    var loopsPlaying: Bool {
        set {
            if newValue {
                if !player.isPlaying { playLoops() }
            } else {
                stopLoops()
            }
        }
        get {
            return player.isPlaying 
        }
    }

    override init() {
        super.init()
        
        player.connect(to: playerMixer)
        playerMixer >>>
        offlineRender

        AudioKit.output = offlineRender

        /*
        playerMixer >>> variableDelay >>> delayMixer.wetInput
        delayMixer >>> moogLadder >>> filterMixer.wetInput
        filterMixer >>> reverb >>> reverbMixer.wetInput
        reverbMixer >>> pitchShifter >>> pitchMixer.wetInput
        pitchMixer >>> bitCrusher >>> bitCrushMixer.wetInput
         */
 
        // Allow the app to play in the background
        do {
            try AKSettings.setSession(category: .playback, with: .mixWithOthers)
        } catch {
            print("error")
        }
        AKSettings.playbackWhileMuted = true

        AudioKit.output = offlineRender
        initParameters()
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        

    }
    
    func updateEffectsChain(effects: [Effect]) {
        do {
            try AudioKit.stop()
        } catch {
            AKLog("AudioKit did not stop!")
        }
        var currentNode: AKInput = playerMixer
        effects.forEach { effect in
            currentNode.disconnectOutput()
            currentNode >>> effect.node
            currentNode = effect.node
        }
        currentNode >>> offlineRender
        
        AudioKit.output = offlineRender
        initParameters()
        do {
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        if isPlaying {
            if let currentLoop = currentLoop {
                playNew(loop: currentLoop.filename)
            }
        }
    }
    
    func initParameters() {

        delayMixer.balance = 0
        filterMixer.balance = 0
        reverbMixer.balance = 0
        pitchMixer.balance = 0

        bitCrushMixer.balance = 0
        bitCrusher.bitDepth = 16
        bitCrusher.sampleRate = 3_333

        //Booster for Volume
        playerBooster.gain = 0.5
    }

    func rewindLoops() {
        playersDo { $0.play(from: 0) }
//        playersDo { $0.schedule(from: 0, to: $0.duration, avTime: nil)}
    }
    
    func playNew(loop: String) {
        do {
            let audioFile = try AKAudioFile(readFileName: loop + "loop.wav", baseDir: .resources)
            player.load(audioFile: audioFile)
            player.isLooping = true
            player.loop.start = 0
            player.loop.end = player.duration
            player.play()
            isPlaying = true
        } catch {
            print(error)
        }
    }
    
    func playUrl(url: URL) {
        do {
            let audioFile = try AKAudioFile(forReading: url)
            player.load(audioFile: audioFile)
            player.isLooping = true
            player.loop.start = 0
            player.loop.end = player.duration
            player.play()
            isPlaying = true
        } catch {
            print(error)
        }
    }
    
    func playLoops(at when: AVAudioTime? = nil) {
        let startTime = when ?? SongProcessor.twoRendersFromNow()
        playersDo { $0.play(at: startTime) }
    }
    
    func stopLoops() {
        playersDo { $0.stop() }
    }
    
    func playersDo(_ action: @escaping (AKPlayer) -> Void) {
        action(player)
    }
    
    private class func twoRendersFromNow() -> AVAudioTime {
        let twoRenders = AVAudioTime.hostTime(forSeconds: AKSettings.bufferLength.duration * 2)
        return AVAudioTime(hostTime: mach_absolute_time() + twoRenders)
    }

    enum ShareTarget {
        case iTunes
        case loops
    }

    fileprivate func mixDownItunes(url: URL) throws {

        offlineRender.internalRenderEnabled = false

        guard let player = iTunesFilePlayer else {
            offlineRender.internalRenderEnabled = true
            throw NSError(domain: "SongProcessor", code: 1, userInfo: [NSLocalizedDescriptionKey: "Target itunes but no player exists"])
        }
        let duration = player.duration
        player.play(from: 0)
//        player.schedule(from: 0, to: duration, avTime: nil)
        let timeZero = AVAudioTime(sampleTime: 0, atRate: offlineRender.avAudioNode.inputFormat(forBus: 0).sampleRate)

        player.play(at:timeZero)
        try offlineRender.renderToURL(url, seconds: duration)
        player.stop()
        offlineRender.internalRenderEnabled = true

    }
    fileprivate func mixDownLoops(url: URL, loops: Int) throws {

        offlineRender.internalRenderEnabled = false

        let duration = player.duration * Double(loops)
        let timeZero = AVAudioTime(sampleTime: 0, atRate: offlineRender.avAudioNode.inputFormat(forBus: 0).sampleRate)
        rewindLoops()
        playLoops(at: timeZero)
        try offlineRender.renderToURL(url, seconds: duration)
        rewindLoops()
        stopLoops()
        offlineRender.internalRenderEnabled = true
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        docController = nil
        guard let url = controller.url else { return }
        if FileManager.default.fileExists(atPath: url.path) {
            do { try FileManager.default.removeItem(at: url) } catch {
                print(error)
            }
        }
    }
    
    var mixDownURL: URL = {
        let tempDir = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
        return tempDir.appendingPathComponent("mixDown.m4a")
    }()
}

extension UIViewController {
    func renderAndShare(completion: @escaping (UIDocumentInteractionController?) -> Void) {
        let songProcessor = SongProcessor.sharedInstance
        let url = songProcessor.mixDownURL

        let cleanup: (Error) -> Void = { error in
            if FileManager.default.fileExists(atPath: url.path) {
                do { try FileManager.default.removeItem(at: url) } catch {
                    print(error)
                }
            }
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            self.present(alert, animated: true, completion: {completion(nil)})
        }

        let success = {
            let docController = UIDocumentInteractionController(url: url)
            docController.delegate = songProcessor
            songProcessor.docController = docController
            completion(docController)
        }

        let shareLoops = {
            let alert = UIAlertController(title: "How many loops?", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.keyboardType = .decimalPad
                textField.text = String(1)
            }
            alert.addAction(.init(title: "OK", style: .default, handler: { (_) in
                let text = alert.textFields?.first?.text
                guard let countText = text,
                    let count = Int(countText),
                    count > 0 else {

                        let message = text == nil ? "Need a count" : text! + " isn't a vaild loop count!"
                        cleanup(NSError(domain: "SongProcessor", code: 1, userInfo: [NSLocalizedDescriptionKey: message]))
                        return
                }
                do {
                    try songProcessor.mixDownLoops(url: url, loops: count)
                    success()

                } catch {
                    cleanup(error)
                }

            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler:nil))
            self.present(alert, animated: true, completion: nil)
        }

        if songProcessor.iTunesFilePlayer != nil {
            let alert = UIAlertController(title: "Export Song or Loops?", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "Song", style: .default, handler: { (_) in
                do {
                    try songProcessor.mixDownItunes(url: url)
                    success()
                } catch {
                    cleanup(error)
                }
            }))
            alert.addAction(.init(title: "Loops", style: .default, handler: { (_) in
                shareLoops()
            }))
            alert.addAction(.init(title: "Cancel", style: .cancel, handler:nil))
            present(alert, animated: true, completion: nil)
        } else {
            shareLoops()
        }

    }

    func alertForShareFail() -> UIAlertController {
        let message = TARGET_OS_SIMULATOR == 0 ? nil : "Try using a device instead of the simulator :)"
        let alert = UIAlertController(title: "No Applications to share with", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        return alert
    }
}
