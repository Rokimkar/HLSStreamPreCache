//
//  ViewController.swift
//  HLSStreamPreCache
//
//  Created by Sanchit Singh on 25/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playerStatusLabel: UILabel!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var playerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayerManager.shared.prepareAssets()
        PlayerManager.shared.lastPlayedIndex = 0
    }
    
    @IBAction func playNextTapped(_ sender: Any) {
        PlayerManager.shared.playerLayer?.removeFromSuperlayer()
        if PlayerManager.shared.lastPlayedIndex < PlayerManager.shared.assets.count - 1{
            PlayerManager.shared.lastPlayedIndex += 1
            PlayerManager.shared.playVideo()
            if let playerLayer = PlayerManager.shared.playerLayer{
                playerLayer.frame = playerContainerView.bounds
                playerLayer.videoGravity = .resizeAspectFill
                playerContainerView.layer.addSublayer(playerLayer)
            }
        }
    }
    
    @IBAction func playPreviousTapped(_ sender: Any) {
        PlayerManager.shared.playerLayer?.removeFromSuperlayer()
        if PlayerManager.shared.lastPlayedIndex > 1{
            PlayerManager.shared.lastPlayedIndex -= 1
            PlayerManager.shared.playVideo()
            if let playerLayer = PlayerManager.shared.playerLayer{
                playerLayer.frame = playerContainerView.bounds
                playerLayer.videoGravity = .resizeAspectFill
                playerContainerView.layer.addSublayer(playerLayer)
            }
        }
    }
    
    @IBAction func playPauseBtnTapped(_ sender: Any) {
//        PlayerManager.shared.playerLayer?.removeFromSuperlayer()
//        PlayerManager.shared.playVideo()
//        if let playerLayer = PlayerManager.shared.playerLayer{
//            playerLayer.frame = playerContainerView.bounds
//            playerLayer.videoGravity = .resizeAspectFill
//            playerContainerView.layer.addSublayer(playerLayer)
//        }
        let playerViewController: AssetViewController = AssetViewController(nibName: "AssetViewController", bundle: nil)
        self.present(playerViewController, animated: true)
    }
}

