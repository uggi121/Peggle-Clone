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
    @IBOutlet var gameView: UIGameView!

    private var model: Model! = nil
    private var doesPersistenceWork = true
    private var gameState: GameState = .inactive

    override func viewDidLoad() {
        super.viewDidLoad()
        initializePegButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameView.superview?.layoutSubviews()
        gameView.superview?.layoutIfNeeded()
        initializeModel()
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


    @IBAction func userPressesStartButton(_ sender: UIButton) {
        gameState = .active
        let displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink.preferredFramesPerSecond = 60
        displayLink.add(to: .main, forMode: .default)
        previous = date.timeIntervalSinceReferenceDate
    }

    let date = Date()
    var previous: TimeInterval!
    var lag = 0.0

    @objc private func gameLoop(displayLink: CADisplayLink) {
        //print(displayLink.timestamp)
        var current = date.timeIntervalSinceReferenceDate
        var elapsed = current - previous
        previous = current
        lag += elapsed

        while lag > (0.0167) {
            update()
            lag -= 0.0167
        }

        render()
    }

    @IBAction func userTapsGameBoard(_ sender: UITapGestureRecognizer) {

        switch gameState {
        case .inactive:
            let tapLocation = sender.location(in: gameView)

            if bluePegButton.isSelected {
                addPeg(tapLocation, .blue)
            } else if orangePegButton.isSelected {
                addPeg(tapLocation, .orange)
            } else if deletePegButton.isSelected {
                deletePeg(tapLocation)
            } else {
                return
            }
        case .active:
            print("Tapped")
        }
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

    private func initializeModel() {
        let gameViewFrame = gameView.frame
        let safetyBuffer = Double(LevelDesignerConstants.pegRadius)

        let xMin = 0.0
        let yMin = 0.0
        let xMax = Double(gameViewFrame.width - gameViewFrame.origin.x)
        let yMax = Double(gameViewFrame.height - gameViewFrame.origin.y)

        let dimensions = GameBoardDimensions(xMin: xMin, xMax: xMax,
                                             yMin: yMin, yMax: yMax,
                                             minimumSize: safetyBuffer * 2)

        do {
            try model = Model(dimensions: dimensions!)
        } catch is PersistenceError {
            doesPersistenceWork = false
        } catch {
            // No exception to be thrown here
        }
    }

    private func addPeg(_ location: CGPoint, _ color: Color) {
        let wasAdded = addPegToModel(location, color)
        if wasAdded {
            addPegToView(location, color)
        }
    }

    private func addPegToModel(_ location: CGPoint, _ color: Color) -> Bool {
        let point = Utils.convertCGPointToPoint(location)
        let peg = Peg(center: point,
                      radius: LevelDesignerConstants.pegRadius,
                      color: color)
        return model.addPeg(peg: peg!)
    }

    private func addPegToView(_ location: CGPoint, _ color: Color) {
        let image: UIPegImageView
        if color == .blue {
            image = UIPegFactory.makeBluePegImageView(
                center: location, radius: LevelDesignerConstants.pegRadius)
        } else {
            image = UIPegFactory.makeOrangePegImageView(center: location, radius: LevelDesignerConstants.pegRadius)
        }

        gameView.addPegView(image)
    }

    /// Deletes the `Peg` at the tapped location from the model and the UI, if the peg exists.
    private func deletePeg(_ location: CGPoint) {
        let point = Utils.convertCGPointToPoint(location)
        guard let locationOfRemovedPeg = model.removePeg(at: point) else {
            return
        }

        gameView.removePegView(at: Utils.convertPointToCGPoint(locationOfRemovedPeg))
    }

}
