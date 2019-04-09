//
//  ViewController.swift
//  Amazon S3 Hash Test
//
//  Created by Alfonso Maria Tesauro on 08/04/2019.
//  Copyright © 2019 Alfonso Maria Tesauro. All rights reserved.
//

import UIKit
import CommonCrypto

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         let sampleFileUrl = URL.init(fileURLWithPath: "/Applications/test/test.bin")

         let awsHash = sampleFileUrl.calculateAWSS3MD5Hash(50)
        
         print("\(awsHash!)")
    }

}

extension URL {
    
    func calculateAWSS3MD5Hash(_ numberOfParts: UInt64) -> String? {
        
        do {
            
            var fileSize: UInt64!
            var calculatedPartSize: UInt64!
            
            let attr:NSDictionary? = try FileManager.default.attributesOfItem(atPath: self.path) as NSDictionary
            if let _attr = attr {
                fileSize = _attr.fileSize();
                if numberOfParts != 0 {
                    
                    let partSize = fileSize / numberOfParts
                    
                    let temp = Double(partSize / (1024*1024))
                    
                    calculatedPartSize = UInt64(temp)
                    
                    var calculatedPartSizeInBytes = calculatedPartSize * 1024 * 1024
                    
                    if fileSize - (calculatedPartSizeInBytes * numberOfParts) > calculatedPartSizeInBytes {
                        calculatedPartSize += 1
                    }
                    calculatedPartSizeInBytes = calculatedPartSize * 1024 * 1024
                    
                    let abstractLength = calculatedPartSizeInBytes * numberOfParts
                    
                    if fileSize > abstractLength {
                        
                        if (fileSize - abstractLength) > calculatedPartSizeInBytes {
                            calculatedPartSize += 1
                        }
                        
                    }
                    
                    
                    }
                    print("The calculated part size is \(calculatedPartSize!) Megabytes")
                    
                    
            }
                
            
            
            let hasher = AWS3MD5Hash.init()
            let file = fopen(self.path, "r")
            defer { let result = fclose(file)}
            
            if numberOfParts == 0 {
                let data = hasher.data(from: file!, startingOnByte: 0, length: fileSize, filePath: self.path)
                let string = MD5.get(data: data)
                return string
            }
            
            
            
            var index: UInt64 = 0
            var bigString: String! = ""
            var data: Data!
            
            while index != numberOfParts {
                
                autoreleasepool {
                
                data = hasher.data(from: file!, startingOnByte: index * calculatedPartSize * 1024 * 1024, length: calculatedPartSize * 1024 * 1024, filePath: self.path)
        
                bigString = bigString + MD5.get(data: data) + "\n"
                
                index += 1
                
                }
            }
            
            //let dataManual = try Data.init(contentsOf: URL.init(fileURLWithPath: "/Users/fofo/Desktop/pippo.txt"))
            
            let final = MD5.get(data :hasher.data(fromHexString: bigString)) + "-\(numberOfParts)"
            
            //try bigString.write(toFile: "/Users/fofo/Desktop/pippo2.txt", atomically: true, encoding: String.Encoding.utf8)
            
            //let resultData = hasher.data(fromHexString: String.init(data: dataManual, encoding: String.Encoding.utf8)!)
            
            //try resultData.write(to: URL.init(fileURLWithPath: "/Users/fofo/Desktop/pippo2.bin"))
            
            
            //let final2 = MD5.get(data :resultData)
          
            print("\(final)")
            
            return final
            
        } catch {
            
        }
        
        return nil
    }
    
    
    
}

struct MD5 {
    
    static func get(data: Data) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        
        let _ = data.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
}
