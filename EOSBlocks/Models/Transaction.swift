//
//  Transaction.swift
//  EOS Blocks
//
//  Created by Sajid Hussain on 9/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    let status: String
    let cpuUsageUs: Int
    let netUsageWords: Int
    let trx: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case cpuUsageUs = "cpu_usage_us"
        case netUsageWords = "net_usage_words"
        case trx = "trx"
    }
}
