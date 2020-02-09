//
//  Block.swift
//  EOS Blocks
//
//  Created by Sajid Hussain on 9/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import Foundation

struct Block: Codable {
    let id: String
    let producer: String
    let producerSignature: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case producer = "producer"
        case producerSignature = "producer_signature"
    }
}
