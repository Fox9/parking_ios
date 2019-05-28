//
//  ParkingTVCell.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/28/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit

class ParkingTVCell: UITableViewCell {

    @IBOutlet weak var parkingImageView: UIImageView! {
        didSet {
            parkingImageView.layer.cornerRadius = parkingImageView.frame.width / 2
            parkingImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var parkingNameLabel: UILabel!
    @IBOutlet weak var parkingDescriptionLabel: UILabel!
    
    var parking: Parking? {
        didSet {
            guard let parking = parking else { return }
            self.parkingImageView.image = UIImage(named: parking.image)
            self.parkingNameLabel.text = parking.name
            self.parkingDescriptionLabel.text = parking.parkingDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ parking: Parking) {
        self.parking = parking
    }
    
}
