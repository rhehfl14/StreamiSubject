//
//  MainViewController.swift
//  StreamiSubject
//
//  Created by 이철우 on 2020/04/30.
//  Copyright © 2020 LeeCheolWoo. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var viewMain: UIView!
    
    var viewModel: MainViewModel = MainViewModel()
    weak var curViewController: BaseViewController? = nil
    
    /**
     * Singleton MainViewController
     */
    static let sharedInstance: MainViewController = {
        var instance = MainViewController.init(nibName: "MainViewController", bundle: nil)
        return instance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coinMasterObserable()
    }
    
    func coinMasterObserable() {
        CoinMaster.sharedInstance
            .coinMasterObservable
            .subscribe({ [weak self] event in
                switch event {
                    
                case .completed:
                    self?.coinMasterComplete()
                    
                default :
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    private func coinMasterComplete() {
        mainScreen()
    }
    
    func mainScreen() {
        mainScreenObserable()
        viewModel.mainScreen()
    }
    
    func mainScreenObserable() {
        viewModel
            .screenObservable
            .subscribe(onNext: { [weak self] viewController in
                
                guard let view = viewController.view else {
                    return
                }
                self?.curViewController = viewController
                self?.addChild(viewController)
                self?.viewMain.addSubview(view)
                
                view.snp.makeConstraints { make in
                    make.leading.equalTo(0)
                    make.trailing.equalTo(0)
                    make.top.equalTo(0)
                    make.bottom.equalTo(0)
                }
                
            }).disposed(by: disposeBag)
    }
}
