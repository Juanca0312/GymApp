//
//  Extensions.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 1/08/23.
//

import UIKit

extension UIViewController {
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Data created successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
