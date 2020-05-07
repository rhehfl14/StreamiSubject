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
    
    /// 마켓 구분 Segment
    @IBOutlet weak var segCoin: UISegmentedControl!
    
    /// 화면 표시할 테이블
    @IBOutlet weak var tableView: UITableView!
    
    /// 가격 정렬 버튼
    @IBOutlet weak var btnPriceSort: UIButton!
    
    /// 거래량 정렬 버튼
    @IBOutlet weak var btnVolumeSort: UIButton!
    
    /// ViewModel
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// nib  등록
        let nib = UINib(nibName: "HomeCellTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCellTableViewCell")
        
        /// 테이블뷰 delegate등록
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.estimatedRowHeight = 60
        
        /// TableView에 표시할 데이터 옵저버 등록 및 TableView Bind
        dataObserable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        /// Segment 옵저버 등록
        segmentObserable()
        
        /// 버튼 옵저버 등록
        buttonObservable()
    }
}

// MARK: - Observable
extension HomeViewController {
    private func dataObserable() {
        /// ViewModel의 데이터를 옵저버로 전달받아 테이블에 표시한다.
        viewModel.receiveDataObservable.asObserver()
            .bind(to: tableView.rx.items(cellIdentifier: "HomeCellTableViewCell", cellType: HomeCellTableViewCell.self))
            { [weak self] (row, model, cell) in
                
                let coinData = model
                
                /// 통화쌍 표시
                cell.labelCoinName.text = coinData.name.replacingOccurrences(of: "-", with: "/")
                
                /// 가격 콤마
                var strComponentsPrice = "\(coinData.price.decimalValue)".components(separatedBy: ".")
                if strComponentsPrice.count > 1 {
                    if Int(strComponentsPrice[1]) == 0 {
                        strComponentsPrice.removeLast()
                    }
                }
                let dot = strComponentsPrice.count == 1 ? 0 : strComponentsPrice[1].count
                let convertPrice = self?.returunCommaDecimalString(strData: "\(coinData.price.decimalValue)", dot: dot, dotYN: dot == 0 ? false : true)
                cell.labelCoinPrice.text = convertPrice
                
                /// 거래량 콤마
                var strComponentsVolume = "\(coinData.volume.decimalValue)".components(separatedBy: ".")
                if strComponentsVolume.count > 1 {
                    if Int(strComponentsVolume[1]) == 0 {
                        strComponentsVolume.removeLast()
                    }
                }
                let dotVolume = strComponentsVolume.count == 1 ? 0 : strComponentsVolume[1].count
                let convertVolume = self?.returunCommaDecimalString(strData: "\(coinData.volume.decimalValue)", dot: dotVolume, dotYN: dotVolume == 0 ? false : true)
                cell.labelCoinVolume.text = convertVolume
                
                /// 각 통화 표시
                cell.labelQuote.text = coinData.quoteAsset
                cell.labelBase.text = coinData.baseAsset
                
        }.disposed(by: disposeBag)
    }
    
    /// 버튼 옵저버
    private func buttonObservable() {
        
        /// 가격정렬
        btnPriceSort.rx.tap.bind { [weak self] in
            let title = self?.btnPriceSort.titleLabel?.text
            if title?.contains("▲") == true {
                self?.viewModel.sortPrice(high: true)
                self?.btnPriceSort.setTitle("현재가▼", for: .normal)
            } else {
                self?.viewModel.sortPrice(high: false)
                self?.btnPriceSort.setTitle("현재가▲", for: .normal)
            }
            self?.btnVolumeSort.setTitleColor(.black, for: .normal)
            self?.btnPriceSort.setTitleColor(.red, for: .normal)
            
        }.disposed(by: disposeBag)
        
        /// 거래량 정렬
        btnVolumeSort.rx.tap.bind { [weak self] in
            let title = self?.btnVolumeSort.titleLabel?.text
            if title?.contains("▲") == true {
                self?.viewModel.sortVolume(high: true)
                self?.btnVolumeSort.setTitle("거래량▼", for: .normal)
            } else {
                self?.viewModel.sortVolume(high: false)
                self?.btnVolumeSort.setTitle("거래량▲", for: .normal)
            }
            self?.btnPriceSort.setTitleColor(.black, for: .normal)
            self?.btnVolumeSort.setTitleColor(.red, for: .normal)
        }.disposed(by: disposeBag)
    }
    
    
    /// Segment 옵저버
    private func segmentObserable() {
        segCoin.rx.selectedSegmentIndex
            .asObservable()
            .subscribe(onNext: { [weak self] index in
                
                self?.btnPriceSort.setTitleColor(.black, for: .normal)
                self?.btnPriceSort.setTitle("현재가▲", for: .normal)
                
                self?.btnVolumeSort.setTitleColor(.black, for: .normal)
                self?.btnVolumeSort.setTitle("거래량▲", for: .normal)
                
                let quoteAsset = self?.segCoin.titleForSegment(at: index)
                
                self?.viewModel.requestData(quoteAsset: quoteAsset ?? "")
            }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - CommaFormatting
extension HomeViewController {
    /// Comma formatting and whether to specify and display decimal places
    ///
    /// - Parameters:
    ///   - strData: The value te be formatted
    ///   - dot: Decimal places
    ///   - dotYN: Whether to display decimal point
    /// - Returns: Formatted value
    func returunCommaDecimalString(strData: String, dot: Int, dotYN: Bool) -> String {
        
        var str : String = strData
        if str.count == 0 {
            str = "0"
        }
        
        var isMinus = false
        if str.contains("-") {
            isMinus = true
            str.removeFirst()
        }
        
        let floatArray : Array = str.components(separatedBy: ".")
        let fixedPart : String = floatArray[0]
        var decimalPart : String = ""
        if floatArray.count > 1 {
            let decimalPartWhole = floatArray[1]
            if decimalPartWhole.count > dot {
                if dot != 0 {
                    decimalPart = decimalPartWhole.subString(to: dot-1)
                } else {
                    decimalPart = decimalPartWhole
                }
            } else {
                decimalPart = decimalPartWhole
            }
        }
        var wholeNumber : String = ""
        
        let numberFormatter = NumberFormatter()
        var stringFormatter : String = "#,##0"
        
        if dotYN {
            wholeNumber = "\(fixedPart).\(decimalPart)"
            for i in 0..<dot {
                if i == 0 {
                    stringFormatter = "\(stringFormatter)."
                }
                stringFormatter = "\(stringFormatter)0"
            }
        } else {
            wholeNumber = "\(fixedPart)"
        }
        
        let tempData : NSDecimalNumber = NSDecimalNumber.init(string: wholeNumber)
        
        numberFormatter.positiveFormat = stringFormatter
        numberFormatter.roundingMode = .down
        
        var tempStr : String = numberFormatter.string(from: tempData)!
        if isMinus  && !tempStr.contains("-") {
            tempStr = "-\(tempStr)"
        }
        return tempStr
    }
}

// MARK: - extension String
extension String {
    
    public func subString(from index: Int, length: Int) -> String {
        guard !isEmpty else { return self }
        
        let startIndex = self.index(self.startIndex, offsetBy: index)
        let endIndex   = self.index(self.startIndex, offsetBy: index + length)
        
        let subString = self[startIndex..<endIndex]
        
        return String(subString)
    }
    
    
    public func subString(from: Int, to: Int) -> String {
        if to >= from { return self }
        guard !isEmpty else { return self }
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to)
        
        let subString = self[startIndex...endIndex]
        
        return String(subString)
    }
    
    
    public func subString(to: Int) -> String {
        return subString(from: 0, to: to)
    }
    
    
    public func subString(from: Int) -> String {
        return subString(from: from, to: self.count-1)
    }
    
    subscript(start: Int, end: Int) -> String {
        return self.slice(start: start, end: end)
    }
    
    public func slice(start: Int, end: Int? = nil, trim:CharacterSet? = nil) -> String {
        let len = self.count
        var start = start
        var end =  end == nil ? len : end!
        if start < 0 {
            start = len + start
        }
        if start > len {
            return ""
        }
        if end < 0 {
            end = len + end
        }
        if end > len - 1 {
            end = len
        }
        let start_index = self.index(self.startIndex, offsetBy: start)
        let end_index = self.index(self.startIndex, offsetBy: end)
        let ref = self[start_index ..< end_index]
        if trim != nil {
            return ref.trimmingCharacters(in: trim!)
        }
        
        return String(ref)
    }
    
    
    func height(constraintBy width: CGFloat, with font: UIFont) -> CGFloat {
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(constraintBy height: CGFloat, with font: UIFont) -> CGFloat {
        let constraintSize = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func size(ofFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [.font : font])
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font : font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
       let fontAttributes = [NSAttributedString.Key.font : font]
       let size = self.size(withAttributes: fontAttributes)
       return size.height
    }
}
