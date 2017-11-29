//
//  ViewController.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fromDate: Date!
    var fromFirstDayMonth: Date!
    var collectionMonthLayout: MonthCollectionViewLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCell")
        collectionView.register(MonthHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "monthHeaderView")
        
        collectionMonthLayout = MonthCollectionViewLayout().initWithWidth(width: self.collectionView!.bounds.width)
        
        collectionMonthLayout.scrollDirection = .vertical
        collectionView.dataSource = self
        
//        self.collectionView.alwaysBounceVertical = false
        
        createDateFrom()
        reloadContent()
    }
    
    override func viewDidLayoutSubviews() {
        self.refreshLayout()
    }
    
    func refreshLayout() {
        self.collectionMonthLayout.scrollDirection = .vertical
        self.collectionView.setCollectionViewLayout(self.collectionMonthLayout, animated: true)
        self.collectionView.reloadData()
    }
    
    func reloadContent() {
        self.fromFirstDayMonth = fromDate.firstDayOfTheMonth()
        self.collectionView.reloadData()
    }
    
    private func createDateFrom() {
        let calendar = Date().calendar()
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.day = 1
        components.month = 1
        components.year = 2017
        
        fromDate = calendar.date(from: components)
    }
    
    private func month(at indexPath: IndexPath) -> String {
        let date = dateForFirstDayInSection(indexPath.section)
        let components = Date().calendar().dateComponents([.month], from: date)
        return Date().monthSymbol(at: components.month!)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fromFirstDayMonth.numberOfMonth()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstDay = dateForFirstDayInSection(section)
        let weekDay = firstDay.weekDay() - 1
        let items = weekDay + firstDay.numberOfDaysInMonth()
        return items
    }
    
    func dateForFirstDayInSection(_ section: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = section
        
        return Date().calendar().date(byAdding: dateComponents, to: fromFirstDayMonth)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        view.backgroundColor = .red
        cell.backgroundView = view
        
        if let day = dateAtIndexPath(indexPath)?.dayComponents() {
            cell.setDay("\(day)")
        } else {
            cell.setDay("")
        }
        
        return cell
    }
    
    func dateAtIndexPath(_ indexPath: IndexPath) -> Date? {
        let firstDay = dateForFirstDayInSection(indexPath.section)
        let weekDay = firstDay.weekDay()
        
        if (indexPath.row < weekDay - 1) {
            return nil
        } else {
            let calendar = Calendar(identifier: .gregorian)
            var components = calendar.dateComponents([.month, .day], from: firstDay)
            components.day = indexPath.row - (weekDay - 1)
            components.month = indexPath.section
            return calendar.date(byAdding: components, to: fromFirstDayMonth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            guard let monthHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "monthHeaderView", for: indexPath) as? MonthHeaderView else {
                return UICollectionReusableView()
            }
            monthHeaderView.monthLabel.text = month(at: indexPath)
            
            return monthHeaderView
        }
        
        return UICollectionReusableView()
    }
}

