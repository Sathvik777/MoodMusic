//
//  ViewController.swift
//  MoodMusic
//
//  Created by Sathvik Katam on 11/11/16.
//  Copyright © 2016 Sathvik Katam. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController, DataSentDelegate {
    
    func userDidEnterData(data: String) {
        ReciveEmotion.text = data
    }
    
    
    
    var mainURL = "https://api.spotify.com/v1/search?q=happy&type=playlist&market=SE&offset=20"
    
    typealias JSONStandard = [String : AnyObject]
    var names = [String]()
    var posts = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: mainURL)
    }
    func callAlamo(url:String)  {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.getData(JSONData: response.data!)
        })
    }
    
    func getData(JSONData: Data){
        do{
            var readJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let playlist = readJSON["playlists"] as? JSONStandard{
                if let items = playlist["items"] {
                    for i in 0..<items.count{
                        let item = items[i] as! JSONStandard
                        let name = item["name"] as! String
                        let previewURL = item["preview_url"] as! String
                        if let album = item["album"] as? JSONStandard{
                            if let images = album["images"] as? [JSONStandard]{
                                let imageData = images[0]
                                let mainImageURL =  URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                
                                posts.append(posts.init(mainImage: mainImage, name: name, previewURL: previewURL))
                                self.tableView.reloadData()
                            }
                    }

                }
            }
        }
        }
        catch{
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        Cell?.textLabel?.text = names[indexPath.row]
        return Cell!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
