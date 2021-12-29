//
//  ChannelsCollectionViewCell.swift
//  Test
//
//  Created by bayareahank on 12/13/21.
//

import UIKit
// import Kingfisher

class ChannelsCollectionViewCell: UICollectionViewCell {
    static let cellId = "channelsCVCell"
    
    
    @IBOutlet var channelImageView: UIImageView!
    @IBOutlet var channelLabel: UILabel!
    
    func configure(_ channel: Channel) {
        
        // print ("ChannelsCell.configure \(channel)")
        channelLabel.text = channel.name
        
        let trueUrlName = "https://mobile-interview.s3.amazonaws.com/" + channel.imageUrl
        guard let url = URL(string: trueUrlName) else {
            return
        }
        
        downloadImage(from: url)
        /*
         channelImageView.kf.setImage(with: url) {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        */
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                [weak self] in
                self?.channelImageView.image = UIImage(data: data)
            }
        }
    }
}
