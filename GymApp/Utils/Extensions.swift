//
//  Extensions.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 1/08/23.
//

import UIKit

extension UIViewController {
    func showSuccessAlert(message: String? = "Action completed successfully.") {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


extension UIImageView {
    func load(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        completion(.success(image))
                    }
                } else {
                    throw NSError(domain: "Image Error", code: 0, userInfo: nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
