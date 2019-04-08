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
        
        let result = "f5738cd338c216edabb415031bb5ee93-76"
        
        let calculatedMd5Data = URL.init(fileURLWithPath: "/Volumes/Mac 4 Tera/Alleggerimento SSD/Map important Graham work/map-of-australia-scripts/Alfonso actual map preparation/builds/separated/AustraliaBasicWithPostalCodesandch-April-4-2019.ctm1")
        
        
        do {
            
            var hashString = ""
            let file = fopen(calculatedMd5Data.path, "r")
            let destinationFile = fopen("/Users/fofo/Desktop/md5/checksums.txt","w")
            
            let hasher = AWS3MD5Hash.init()
            var index: UInt64 = 0
            var bigString: String! = ""
            
            while true {
            
            let data = hasher.data(from: file!, startingOnByte: index * 16384, length: 16 * 1024)
            
            bigString = bigString + MD5.get(data: data)

            index += 1
                
                if index == 76 {
                    break
                }
                
            }
            
            let final = MD5.get(data :bigString.data(using: String.Encoding.utf8)!)
            
            print("\(final)-76")
        } catch {
            
        }
        
        
        
        
        
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
