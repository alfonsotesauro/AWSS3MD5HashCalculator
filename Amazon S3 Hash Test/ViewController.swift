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
        
      let sampleMapURL = URL.init(fileURLWithPath: "/Volumes/Mac 4 Tera/Alleggerimento SSD/Map important Graham work/map-of-australia-scripts/Alfonso actual map preparation/builds/separated/AustraliaBasicWithPostalCodesandch-April-4-2019.ctm1")
        
        
        //let awsHash = sampleMapURL.calculateAWSS3MD5Hash(76)
        
        //print("\(awsHash!)")
        
        let sampleMapURL2 = URL.init(fileURLWithPath: "/Volumes/Mac 4 Tera/Alleggerimento SSD/Map important Graham work/map-of-australia-scripts/Alfonso actual map preparation/builds/separated/AustraliaOnlyHeightsWithIndex.ctm1")
        
        
       //let awsHash3 = sampleMapURL2.calculateAWSS3MD5Hash(64)
        
        //print("\(awsHash3!)")
        
        let sampleMapURL3 = URL.init(fileURLWithPath: "/Users/fofo/Downloads/AustraliaBasicWithPostalCodesandch.ctm1")
        
        let newResultWithNoParts = "362b3706d3df0086d0bf91fb8ca1503d"
        let awsHash4 = sampleMapURL3.calculateAWSS3MD5Hash(0)
        
        if newResultWithNoParts == awsHash4 {
            print("Funziona anche senza parti quando il file è piccolo.")
        }
        
        
        
    }

}

extension URL {
    
    func calculateAWSS3MD5Hash(_ numberOfParts: UInt64) -> String? {
        
        let result = "f5738cd338c216edabb415031bb5ee93-76"
        
        let thirdKeyResult = "59b574930d739ce204217786f96ddb7b-64"
        
        
        
        
        do {
            
            var fileSize: UInt64!
            var purposedPartSize: UInt64!
            
            let attr:NSDictionary? = try FileManager.default.attributesOfItem(atPath: self.path) as NSDictionary
            if let _attr = attr {
                fileSize = _attr.fileSize();
                if numberOfParts != 0 {
                    
                    let partSize = fileSize / numberOfParts
                    
                    let floor2 = ceil(Double(partSize / (1024*1024)))
                    
                    purposedPartSize = UInt64(floor2)
                    
                    if fileSize % purposedPartSize > 0 {
                        purposedPartSize += 1
                    }
                    
                    print(purposedPartSize)
                }
                
            }
            
            let hasher = AWS3MD5Hash.init()
            let file = fopen(self.path, "r")

            if numberOfParts == 0 {
                let data = hasher.data(from: file!, startingOnByte: 0, length: fileSize, filePath: self.path)
                let string = MD5.get(data: data)
                return string
            }
            
            
            
            var index: UInt64 = 0
            var bigString: String! = ""
            var data: Data!
            
            while true {
                
                if index == (numberOfParts-1) {
                    print("Siamo all'ultima linea.")
                }
                
                
                data = hasher.data(from: file!, startingOnByte: index * purposedPartSize * 1024 * 1024, length: purposedPartSize * 1024 * 1024, filePath: self.path)
                
                
                
                
                
                
                bigString = bigString + MD5.get(data: data) + "\n"
                
                index += 1
                
                if index == numberOfParts {
                    break
                }
                
            }
            
            //let dataManual = try Data.init(contentsOf: URL.init(fileURLWithPath: "/Users/fofo/Desktop/pippo.txt"))
            
            let final = MD5.get(data :hasher.data(fromHexString: bigString)) + "-\(numberOfParts)"
            
            //try bigString.write(toFile: "/Users/fofo/Desktop/pippo2.txt", atomically: true, encoding: String.Encoding.utf8)
            
            //let resultData = hasher.data(fromHexString: String.init(data: dataManual, encoding: String.Encoding.utf8)!)
            
            //try resultData.write(to: URL.init(fileURLWithPath: "/Users/fofo/Desktop/pippo2.bin"))
            
            
            //let final2 = MD5.get(data :resultData)
            
            if final == result {
                print("Ecco servito.")
            }
            
            
            
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
        
        data.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
}
