//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Yawen on 30/1/2017.
//  Copyright © 2017 Ya-Wen Chu. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var movies: [NSDictionary]? //?-makes the type optional
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    
                    self.movies = dataDictionary["results"] as![NSDictionary]
                    
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tells table view how many cells it has
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //if movies != null, it will do something.
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
        
        return movies!.count //This will be the numbers of movies in the movies array
    }
    
    //Be able to communicate and set the content inside the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell //Index Path tells where the cell is in the tableView.
        
        let movie = movies![indexPath.row] //!-I am positive that is something in there that is not null.
        
        let title = movie["title"] as! String //cast it as a String.
        
        let overview = movie["overview"] as! String
        
        let baseurl = "https://image.tmdb.org/t/p/w500"
        
        let posterPath = movie["poster_path"] as! String
        
        let imageUrl = NSURL(string: baseurl + posterPath)
        
        cell.posterView.setImageWith(imageUrl as! URL)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        
        
        print("row\(indexPath.row)")
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
