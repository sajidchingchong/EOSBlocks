//
//  BlockResponse.swift
//  EOS Blocks
//
//  Created by Sajid Hussain on 9/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import Foundation

struct InfoResponse: Codable {
    let headBlockNum: Int
    
    enum CodingKeys: String, CodingKey {
        case headBlockNum = "head_block_num"
    }
}
