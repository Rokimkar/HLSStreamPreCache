//
//  PlayerManager.swift
//  HLSStreamPreCache
//
//  Created by Sanchit Singh on 26/12/23.
//

import Foundation
import AVFoundation

class PlayerManager: NSObject{
    static let shared: PlayerManager = PlayerManager()
    var assetDownloadStarted = false
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var assets: [AVURLAsset] = []
    var playUrls: [String] = [
        "https://d1gnaphp93fop2.cloudfront.net/videos/multiresolution/rendition_new10.m3u8",
        "http://content.jwplatform.com/manifests/vM7nH0Kl.m3u8",
        "https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8",
        "http://playertest.longtailvideo.com/adaptive/wowzaid3/playlist.m3u8",
        "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8",
        "https://res.cloudinary.com/dannykeane/video/upload/sp_full_hd/q_80:qmax_90,ac_none/v1/dk-memoji-dark.m3u8",
                            "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8",
                              "https://diceyk6a7voy4.cloudfront.net/e78752a1-2e83-43fa-85ae-3d508be29366/hls/fitfest-sample-1_Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_6.0Mbps_qvbr.m3u8",
                              "https://static.pexels.com/lib/videos/free-videos.mp4",
                              
                              "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8",
                              "http://nasatv-lh.akamaihd.net/i/NASA_101@319270/index_1000_av-p.m3u8?sd=10&rebase=on",
                              "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8",
                              "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
                            ]
    
    var lastPlayedIndex: Int = -1
    lazy var assetDownloadURLSession: AVAssetDownloadURLSession = {
        let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.streamCache")
//        backgroundConfiguration.isDiscretionary = true
//        backgroundConfiguration.sessionSendsLaunchEvents = true
        
        var delegateQueue = OperationQueue()
        delegateQueue.name = "Download queue"
        delegateQueue.qualityOfService = .utility
        //
        // Create the AVAssetDownloadURLSession using the configuration.
        let assetDownloadURLSession =
            AVAssetDownloadURLSession(configuration: backgroundConfiguration,
                                      assetDownloadDelegate: self, delegateQueue: delegateQueue)
        
        
        return assetDownloadURLSession
    }()
    
    func prepareAssets(){
        for item in playUrls{
            if let url = URL(string: item){
                let asset = AVURLAsset(url: url)
                assets.append(asset)
            }
        }
    }
    
    func playVideo(){
        if lastPlayedIndex > -1 && lastPlayedIndex < assets.count{
            player = AVPlayer(playerItem: AVPlayerItem(asset: assets[lastPlayedIndex]))
            playerLayer = AVPlayerLayer(player: player)
            player?.play()
        }
    }
}

extension PlayerManager: AVAssetDownloadDelegate{
    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        //
    }
}
