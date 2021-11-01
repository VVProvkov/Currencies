//
//  currenciesViewCell.swift
//  firstAppSenin
//
//  Created by Vadim on 25.09.2021.
//

import UIKit

class currenciesViewCell: UITableViewCell {
   
    
    
    
    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var course: UILabel!
    
    func initCell(currency: Currency) {
        imageFlag.image = currency.imageFlag
        currencyName.text = currency.name
        course.text = currency.value
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
