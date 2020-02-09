//
//  DetailViewController.swift
//  EOSBlocks
//
//  Created by Sajid Hussain on 8/2/20.
//  Copyright © 2020 Sajid Hussain. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, AlertDisplayer {

    let blockUrl = "https://api.eosnewyork.io/v1"
    
    @IBOutlet weak var producer: UILabel!
    @IBOutlet weak var producerSignature: UILabel!
    @IBOutlet weak var transactionCount: UILabel!
    
    var detailItem : BlockDetail?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            self.producer.text = item!.producer
            self.producerSignature.text = item!.producerSignature
            self.transactionCount.text = String(detail.transactionCount())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var item: Block? {
        didSet {
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: URL(string: String(format: blockUrl, arguments: [item!.id]))!) { data, response, error in
                guard let data = data else {
                    print("Error: No block data!")
                    self.displayAlert(with: "Alas!" , message: "No Block Data is Found!", actions: [UIAlertAction(title: "OK", style: .default)])
                    return
                }
                
                print("Block Response: " + String(decoding: data, as: UTF8.self))
                
                guard let blockDetail = try? JSONDecoder().decode(BlockDetail.self, from: data) else {
                    print("Error: Couldn't decode data into block detail")
                    return
                }
                
                self.detailItem = blockDetail
                
                DispatchQueue.main.async {
                    self.configureView()
                }
                
                }.resume()
        }
    }

}

