//
//  ViewController.swift
//  AppleVisionAPK
//
//  Created by Jesse Rae on 6/7/21.
//

import UIKit
import Vision

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "NBA2") else {return}
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight + 650)

        view.addSubview(imageView)
        
        let request = VNDetectFaceRectanglesRequest { req, err in
            
            if let err = err {
                print("Failed to detect faes", err)
                return
            }
            print(req)
            req.results?.forEach({ (res) in
                print(res)

                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else {return}

                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y = scaledHeight * (1 - faceObservation.boundingBox.origin.y) - height
                    let width = self.view.frame.width * faceObservation.boundingBox.width

                
                    let redView = UIView()
                    redView.backgroundColor = .red.withAlphaComponent(0.3)
                    redView.frame = CGRect(x: x, y: y + 325, width: width, height: height)
                    self.view.addSubview(redView)
                    
                    print(faceObservation.boundingBox)
                }
            })
        }
        
        guard let cgImage = image.cgImage else {return}
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request", reqErr)
            }
        }
    }
}

