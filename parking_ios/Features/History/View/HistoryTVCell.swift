//
//  HistoryTVCell.swift
//  parking_ios
//
//  Created by Ellan Esenaliev on 5/29/19.
//  Copyright © 2019 Ellan Esenaliev. All rights reserved.
//

import UIKit

class HistoryTVCell: UITableViewCell {

    @IBOutlet weak var parkingName: UILabel!
    @IBOutlet weak var historyParkingStartDateLabel: UILabel!
    @IBOutlet weak var historyParkingEndDateLabel: UILabel!
    @IBOutlet weak var parkingImageView: UIImageView! {
        didSet {
            parkingImageView.contentMode = .scaleAspectFill
            parkingImageView.layer.cornerRadius = parkingImageView.frame.width / 2
        }
    }
    
    var history: ParkingHistory? {
        didSet {
            guard let history = history, let parking = history.parking else { return }
            self.parkingName.text = parking.name
            self.parkingImageView.image = UIImage(named: parking.image)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd:MM:YYYY 'at' HH:mm"
            self.historyParkingStartDateLabel.text = formatter.string(from: history.startDate)
            self.historyParkingEndDateLabel.text = formatter.string(from: history.endDate)
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
    
    func setup(_ history: ParkingHistory) {
        self.history = history
    }
    
}
