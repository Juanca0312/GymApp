//
//  ExerciseCell.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 26/07/23.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    
    @IBOutlet weak var exerciseNameLabel: UILabel!
    
    @IBOutlet weak var exerciseImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
