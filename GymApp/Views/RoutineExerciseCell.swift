//
//  RoutineExerciseCell.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 2/08/23.
//

import UIKit

class RoutineExerciseCell: UITableViewCell {
    
    
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var seriesRepsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        exerciseImageView.image = UIImage(systemName: "dumbbell.fill")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
