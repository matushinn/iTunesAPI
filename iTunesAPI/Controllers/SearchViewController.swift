//
//  SearchViewController.swift
//  iTunesAPI
//
//  Created by 大江祥太郎 on 2021/09/06.
//

import UIKit
import JGProgressHUD
import AVFoundation

class SearchViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var player:AVAudioPlayer?
    
    private var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: ListTableViewCell.cellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ListTableViewCell.cellIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellIdentifier, for: indexPath) as! ListTableViewCell

        let song = songs[indexPath.row]
        cell.setup(song:song)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playButtonTap(indexPath: indexPath.row)
    }
    func playButtonTap(indexPath:Int){
        
        // print(sender.debugDescription)
        //音楽を止める
        if player?.isPlaying == true {
            player?.stop()
        }
        //print(songs[indexPath].previewUrl)
        //sender.tag=index.row
        let url = URL(string: songs[indexPath].previewUrl!)
        
        downLoadMusicURL(url: url!)
    }
    
    func downLoadMusicURL(url:URL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url,completionHandler: { url, response, error in
            print(error)
            self.play(url: url!)
            
        })
        downloadTask.resume()
    }
    
    //再生する関数
    func play(url:URL){
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.volume = 1.0
            player?.play()
            
        } catch let error as NSError {
            print(error.debugDescription)
            
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        iTunesAPI.taskCancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard !(searchBar.text?.isEmpty ?? true) else { return }
        searchBar.resignFirstResponder()
        let word = searchBar.text!
        
        let progressHUD = JGProgressHUD()
        progressHUD.show(in: self.view)
        
        iTunesAPI.searchRepository(text: word) { result in
            DispatchQueue.main.async {
                progressHUD.dismiss()
            }
            
            switch result {
            case .success(let results):
                self.songs = results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    switch error {
                    case .wrong :
                        let alert = ErrorAlert.wrongWordError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    case .network:
                        let alert = ErrorAlert.networkError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    case .parse:
                        let alert = ErrorAlert.parseError()
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
        return
    }

}
