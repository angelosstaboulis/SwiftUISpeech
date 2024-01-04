//
//  SpeechHelper.swift
//  SwiftUISpeech
//
//  Created by Angelos Staboulis on 3/1/24.
//

import Foundation
import Speech
class SpeechHelper{
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "el"))
    var recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    let audioEngine = AVAudioEngine()
    let audioSession = AVAudioSession.sharedInstance()
    func checkPermissions() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    debugPrint("authorized")
                    break
                case .denied:
                    debugPrint("denied")
                    break
                case .restricted:
                    debugPrint("restricted")
                    break
                case .notDetermined:
                    debugPrint("notDetermined")
                    break
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    func speak(completion:@escaping(String)->()){
        DispatchQueue.main.async { [self] in
            do{
               
                try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                let node = audioEngine.inputNode
                let recordingFormat = node.outputFormat(forBus: 0)
                node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                    self.recognitionRequest.append(buffer)
                }
                audioEngine.prepare()
                try audioEngine.start()
                self.speechRecognizer?.recognitionTask(with: self.recognitionRequest, resultHandler: { result, error in
                    completion(result!.bestTranscription.segments.first!.substring)
                    self.audioEngine.stop()
                    self.audioEngine.inputNode.removeTap(onBus: 0)
                    self.recognitionRequest.endAudio()
                    
                })
        
                
            }catch{
                debugPrint("something went wrong!!!"+error.localizedDescription)
            }
        }
    }
}
