//
//  CamView.swift
//  MoodMusic
//
//  Created by Sathvik Katam on 11/11/16.
//  Copyright © 2016 Sathvik Katam. All rights reserved.
//

import UIKit
import AVFoundation
protocol DataSentDelegate {
    func ReciveEmotion(data: String)
}

class CamView: UIViewController {
    
    
    var captureSession = AVCaptureSession()
    var Output = AVCapturePhotoOutput()
    var preview = AVCaptureVideoPreviewLayer()
    var delegate: DataSentDelegate? = nil
    

    @IBOutlet weak var cameraView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        let devices =  AVCaptureDeviceType(rawValue: AVMediaTypeVideo)
        for device in devices{
            if device.postion == AVCaptureDevicePosition.front{
                do{
                    let input = try AVCaptureDeviceInput (device : device as! AVCaptureDevice)
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        captureSession.startRunning()
                        Output.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
                        if captureSession.canAddOutput(Output){
                            captureSession.addOutput(Output)
                            preview = AVCaptureVideoPreviewLayer(sesssion : captureSession)
                            preview.videoGravity = AVLayerVideoGravityResizeAspectFill
                            preview.connection.videoOrientation = AVCaptureVideoOrientation.portrait
                            cameraView.layer.addSublayer(preview)
                            
                            
                        }
                        
                    }
                }
                
            }
        }

    
    
    
    }
    @IBAction func Capture(_ sender: Any) {
        
        if let VConnection = Output.connection(withMediaType: AVMediaTypeVideo){
            Output.capturePhoto(with: VConnection, delegate: <#T##AVCapturePhotoCaptureDelegate#>)
            
            let imagedata = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer)
            
            
            self.findFace()
            
        }
    }
    func findFace() {
        
        guard let faceImage = CIImage(image: imagedata!) else { return }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: faceImage, options: [CIDetectorSmile: true, CIDetectorEyeBlink: true])
        
        for face in faces as! [CIFaceFeature] {
            
            if face.hasSmile {
                let data = "happy"
            }
            
            if face.leftEyeClosed {
                let data = "lucky"
            }
            
            if face.rightEyeClosed {
                let data = "funny"
            }
        }
        
        if faces!.count != 0 {
            print("Number of Faces: \(faces!.count)")
        } else {
            let data = "sad"
        }
        
        delegate?.ReciveEmotion(data: data!)
    }

    

}
