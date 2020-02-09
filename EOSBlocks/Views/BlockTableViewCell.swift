//
//  BlockTableViewCell.swift
//  EOS Blocks
//
//  Created by Sajid Hussain on 9/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import UIKit

class BlockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var producer: UILabel!
    @IBOutlet weak var producerSignature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(with block: Block){
        self.producer.text = block.producer
        self.producerSignature.text = block.producerSignature
    }
    
}
