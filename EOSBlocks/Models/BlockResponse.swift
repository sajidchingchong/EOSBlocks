//
//  BlockResponse.swift
//  EOS Blocks
//
//  Created by Sajid Hussain on 9/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import Foundation

struct BlockResponse: Codable {
    let results: [Block]
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}
