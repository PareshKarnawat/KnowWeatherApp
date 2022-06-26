//
//  CityListViewController.swift
//  KnowWeatherApp
//


import UIKit
import AVKit

class CityListViewController: UIViewController {

    @IBOutlet weak var cityListTableView: UITableView!
    @IBOutlet weak var tableViewContainerView: UIView!
    
    var selectedCity = String()
    var citiArray = ["Gothenburg","Stockholm","Mountain View","London","New York", "Berlin"]
    var avPlayer : AVPlayer? = nil
    
    let StandardHeight: CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityListTableView.tableFooterView = UIView()
        playVideoInBackground()
        tableViewContainerView.dropShadow(color: UIColor.black.cgColor,radius: CGFloat(Constants.CornerRadius1 / 2))
        cityListTableView.layer.cornerRadius = CGFloat(Constants.CornerRadius1 / 2)
        tableViewContainerView.layer.cornerRadius = CGFloat(Constants.CornerRadius1 / 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        avPlayer?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        avPlayer?.pause()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.WeatherDetailViewControllerIdentifier) {
               let vc = segue.destination as! WeatherViewController
               vc.selectedCity = selectedCity
           }
    }
}

// MARK: - UITableViewDelegate and UITableViewDatasource Methods

extension CityListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        let sectionHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: StandardHeight))
        sectionHeader.backgroundColor = UIColor.systemYellow
        
        let sectionText = UILabel()
        sectionText.frame = CGRect.init(x: 0, y: 0, width: sectionHeader.frame.width, height: sectionHeader.frame.height)
        sectionText.text = Constants.SelectCityTitle
        sectionText.font = .systemFont(ofSize: 18, weight: .medium)
        sectionText.textColor = UIColor.black
        sectionText.textAlignment = .center
        sectionHeader.addSubview(sectionText)
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return StandardHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CityTableViewCellIdentifier) as? CityTableViewCell{
            cell.citiNameLabel.text = citiArray[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCity = citiArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: Constants.WeatherDetailViewControllerIdentifier, sender: self)
    }
}
// MARK: - Video Player Methods

extension CityListViewController {
    
    // AVPlayer Implementation
    private func playVideoInBackground() {
        guard let url = Bundle.main.url(forResource: Constants.BackgroundVideo, withExtension: Constants.VideoExt) else { return }
        avPlayer = AVPlayer(url: url)
        let avPlayerVideoLayer = AVPlayerLayer(player: avPlayer)
        avPlayerVideoLayer.videoGravity = .resizeAspectFill
        
        avPlayer?.volume = 0
        avPlayer?.actionAtItemEnd = .none
        avPlayerVideoLayer.frame = self.view.layer.bounds
        self.view.backgroundColor = .clear
        self.view.layer.insertSublayer(avPlayerVideoLayer, at: 0)
        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: avPlayer?.currentItem)
        avPlayer?.play()
    }
    
    @objc func playerDidEnd(notification: Notification) {
        let playerItem: AVPlayerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: .zero, completionHandler: nil)
    }
}
