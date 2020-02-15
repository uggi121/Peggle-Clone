//
//  ViewController.swift
//  PeggleClone
//
//  Created by Sudharshan Madhavan on 12/2/20.
//  Copyright © 2020 Sudharshan Madhavan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var bluePegButton: UIButton!
    @IBOutlet var orangePegButton: UIButton!
    @IBOutlet var deletePegButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializePegButtons()
    }

    @IBAction func userTapsBluePegButton(_ sender: UIButton) {
        selectButton(sender)
    }

    @IBAction func userTapsOrangePegButton(_ sender: UIButton) {
        selectButton(sender)
    }

    @IBAction func userTapsDeletePegButton(_ sender: UIButton) {
        selectButton(sender)

    }
    private func selectButton(_ sender: UIButton) {
        guard !sender.isSelected else {
            sender.isSelected = false
            return
        }

        deselectPegButtons()
        sender.isSelected = true
    }

    /// Sets up the buttons' selected state images.
    private func initializePegButtons() {
        setSelectedStateImage(button: bluePegButton, imageName: "selected-peg-blue")
        setSelectedStateImage(button: orangePegButton, imageName: "selected-peg-orange")
        setSelectedStateImage(button: deletePegButton, imageName: "selected-peg-delete.png")
    }

    private func setSelectedStateImage(button: UIButton, imageName: String) {
        guard let selectedStateImage = UIImage(named: imageName) else {
            return
        }

        guard button != deletePegButton else {
            button.setImage(selectedStateImage, for: .selected)
            return
        }

        let resizedImage = Utils.resizeImage(image: selectedStateImage,
                                             targetSize: LevelDesignerConstants.pegButtonSize)
        button.setImage(resizedImage, for: .selected)
    }

    private func deselectPegButtons() {
        bluePegButton.isSelected = false
        orangePegButton.isSelected = false
        deletePegButton.isSelected = false
    }


}

