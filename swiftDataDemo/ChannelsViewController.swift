//
//  ChannelsViewController.swift
//  Test
//
//  Created by bayareahank on 12/13/21.
//

import UIKit
import os.log

class ChannelsViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var data = [Channel]()
    var channelList = ChannelList(Channels: [])
    
    let movesJsonName = "moves.json"
    var movesUrl: URL?
    
    let url = "https://mobile-interview.s3.amazonaws.com/channels.json"
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = makeLayout()
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        movesUrl = documentDirectoryUrl.appendingPathComponent(movesJsonName)
        
        loadOverNet()
        // loadFromLocal()
    }
    
    
    func saveToLocal() {
        guard let encodedData = try? JSONEncoder().encode(channelList) else {
            return
        }
        
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
            
        let fileUrl = documentDirectoryUrl.appendingPathComponent("channels.json")

        do {
            try encodedData.write(to: fileUrl)
                // Is this overwrite or append? Overwrite
        } catch {
            print ("Failed \(error.localizedDescription)")
        }
            
    }
    
    // If file exists, read from file, otherwise load over the net and save to local.
    func loadFromLocal() {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
            
        let fileUrl = documentDirectoryUrl.appendingPathComponent("channels.json")

        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            self.channelList = try JSONDecoder().decode(ChannelList.self, from: data)
            self.data = self.channelList.Channels
        } catch {
            print("Read file failed \(error.localizedDescription)")
            loadOverNet()
        }
    }
    
    func loadOverNet() {
        URLSession.shared.dataTask(with: URL(string: url)!) {
            [weak self] (data, response, error) -> Void in
            // Check if data was received successfully
            
            guard let data = data else {
                return
            }
           
            guard let sself = self else {
                return
            }
            
            do {
                
                sself.channelList = try JSONDecoder().decode(ChannelList.self, from: data)
                /*
                // Convert to dictionary where keys are of type String, and values are of any type
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                // Access specific key with value of type String
                guard let channels = json["Channels"] else {
                    return
                }
                print ("Channels: \(String(describing: channels))")
                // self.data = try! JSONDecoder().decode([Channel].self, from: channels as! Data)
                
                for item in channels as! Array<[String: Any]> {
                    // print ("Item \(item) \(item["id"])")
                    let id = item["id"] as! Int
                    let name = item["name"] as! String
                    let imageUrl = item["imageUrl"] as! String
                    let channel = Channel(id: id, name: name, imageUrl: imageUrl, optional: nil)
                    self.data.append(channel)
                }
                 */
                
                sself.data = sself.channelList.Channels
                sself.saveToLocal()
                // print ("ChannelList: \(self.channelList) \nchannels: \(self.data)")
            } catch {
                // Something went wrong
                print ("Something went wrong when loading data")
            }
            
        }.resume()
        
        /*
        DispatchQueue.global().async {
            let list = try? String(contentsOf: URL(string: self.url)!)
            let items = list["Channels"]
        }
         */
    }

    // Use compositional layout for collectionView
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0/3.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}


extension ChannelsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelsCollectionViewCell.cellId, for: indexPath) as! ChannelsCollectionViewCell
        
        cell.configure(data[indexPath.item])
        
        return cell
    }
}

extension ChannelsViewController: UICollectionViewDelegate {
    
}
