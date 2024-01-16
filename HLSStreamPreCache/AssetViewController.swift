//
//  AssetViewController.swift
//  HLSStreamPreCache
//
//  Created by Sanchit Singh on 09/01/24.
//

import UIKit
import AVKit
 
class AssetViewController: UIViewController {
    // Replace with your actual HLS media file URL
    let hlsMediaURL = URL(string: "https://d1gnaphp93fop2.cloudfront.net/videos/multiresolution/rendition_new10.m3u8")!
 
    var assetDownloadSession: AVAssetDownloadURLSession!
    var downloadTask: AVAggregateAssetDownloadTask!
 
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var downloadLocationUrl: URL!
    // Flag to track whether to switch to online streaming
    var shouldSwitchToOnline = false
    var playBackStarted = false
    var downloadCanceledFirstTime = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up AVAssetDownloadURLSession
        guard let playerAsset = PlayerManager.shared.assets.first else{return}

        let assetDownloadConfiguration = URLSessionConfiguration.background(withIdentifier: "com.example.AssetDownloadSession")
        assetDownloadSession = AVAssetDownloadURLSession(configuration: assetDownloadConfiguration, assetDownloadDelegate: self, delegateQueue: OperationQueue.main)
 
        // Start the download task for the HLS media
        downloadTask = assetDownloadSession.aggregateAssetDownloadTask(with: playerAsset, mediaSelections: [/* Your media selections */], assetTitle: "SampleAsset", assetArtworkData: nil, options: [AVAssetDownloadTaskPrefersHDRKey: 1, AVAssetDownloadTaskMinimumRequiredPresentationSizeKey: 1])
//            downloadTask = assetDownloadSession.aggregateAssetDownloadTask(with: playerAsset, mediaSelections: [], assetTitle: "SampleAsset", assetArtworkData: nil)
        if !PlayerManager.shared.assetDownloadStarted{
            PlayerManager.shared.assetDownloadStarted = true
            downloadTask.resume()
            
        }
 
        // Prepare AVPlayer in advance
//        playerItem = AVPlayerItem(url: downloadTask.url!)
//        playerItem = AVPlayerItem(asset: playerAsset)//AVPlayerItem(url: downloadTask.urlAsset.url)
//        playerItem = AVPlayerItem(asset: playerAsset)
//        player = AVPlayer(playerItem: playerItem)
    }
 
    // Trigger playback when enough content is pre-cached
    func startPlayback() {
        print("DownloadLocation: \(downloadLocationUrl!)")
        playerItem = AVPlayerItem(url: downloadLocationUrl)
        player = AVPlayer(playerItem: playerItem)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        present(playerViewController, animated: true) {
            self.player.play()
        }
    }
 
    // Switch to online streaming if needed
    func switchToOnlineStreaming() {
        // Replace the downloadTask.url with the original online URL
        guard let playerAsset = PlayerManager.shared.assets.first else {return}
        let onlineURL = downloadTask.urlAsset.url //URL(string: "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8")!
        let onlinePlayerItem = AVPlayerItem(url: onlineURL)
        // Replace the player item
        player.replaceCurrentItem(with: onlinePlayerItem)
        // Flag to indicate that further content should be streamed online
        shouldSwitchToOnline = true
    }
    
    @IBAction func startOnlinePlayback(_ sender: Any) {
        switchToOnlineStreaming()
    }
    
    @IBAction func startPlayback(_ sender: Any) {
        startPlayback()
    }
}
 
// Implement AVAssetDownloadDelegate methods to monitor download progress
extension AssetViewController: AVAssetDownloadDelegate {
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didCompleteFor mediaSelection: AVMediaSelection) {
        // Download completed
        print("Full stream Download completed")
//        if !shouldSwitchToOnline {
//            // Continue playing the downloaded content
//            startPlayback()
//        } else {
//            // Switch to online streaming for further content
//            switchToOnlineStreaming()
//        }
    }
    
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, willDownloadTo location: URL) {
        downloadLocationUrl = location
    }
    
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad expectedTimeRange: CMTimeRange, for mediaSelection: AVMediaSelection) {
        // Monitor download progress
//        let asset = downloadTask.urlAsset
//        let totalDuration = asset.duration.seconds
//        let loadedPercentage = (timeRange.duration.seconds / totalDuration) * 100
        
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange: CMTimeRange = value.timeRangeValue
            percentComplete +=
                loadedTimeRange.duration.seconds / expectedTimeRange.duration.seconds
        }
 
        print("percentageLoaded: \(percentComplete*100)")
        if percentComplete > 0.1{
            DispatchQueue.main.async {
                if !self.playBackStarted{
                    self.playBackStarted = true
//                    self.startPlayback()
                }
            }
        }
        
        if percentComplete > 0.1 && !downloadCanceledFirstTime{
            downloadCanceledFirstTime = true
            downloadTask.cancel()
//            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
//                self.downloadTask.resume()
//            })
        }
        
        // Start playback when at least 1% is pre-cached
//        if percentComplete >= 0.01 && !shouldSwitchToOnline {
//            DispatchQueue.main.async {
//                self.switchToOnlineStreaming()
//            }
//        }
//        // Switch to online streaming after playing 1% content
//        if percentComplete >= 0.01 && shouldSwitchToOnline {
//            DispatchQueue.main.async {
//                self.switchToOnlineStreaming()
//            }
//        }
    }
 
    // Add other necessary delegate methods as per your requirements
}

