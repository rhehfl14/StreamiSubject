//
//  HomeViewController.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/04/30.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController {
    @IBOutlet weak var segCoin: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeViewModel = HomeViewModel()
    var receiveData: [CoinRepository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataObserable()
        segmentObserable()
    }
    
    private func dataObserable() {
        viewModel.receiveData.asObserver()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] value in
                self?.receiveData.removeAll()
                self?.receiveData = value
                self?.tableView.reloadData()
                
            }).disposed(by: disposeBag)
    }
    
    private func segmentObserable() {
        segCoin.rx.selectedSegmentIndex
            .asObservable()
            .subscribe(onNext: { [weak self] index in
            self?.viewModel.requestData(index: index)
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        return cell
    }
}
