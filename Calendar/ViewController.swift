//
//  ViewController.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    var calendarCollectionView: UICollectionView!
    var fromDate: Date!
    var fromFirstDayMonth: Date!
    var collectionMonthLayout: MonthCollectionViewLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionMonthLayout = MonthCollectionViewLayout().initWithWidth(width: self.view.bounds.width)
        collectionMonthLayout.scrollDirection = .vertical
        
        calendarCollectionView = CalendarCollectionView(frame: self.view.frame, collectionViewLayout: self.collectionMonthLayout)
        calendarCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.alwaysBounceVertical = false
        
        self.view.addSubview(calendarCollectionView)
        
        createDateFrom()
        reloadContent()
    }
    
    override func viewDidLayoutSubviews() {
        self.refreshLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scrollToLastItem()
    }
    
    func scrollToLastItem() {
        let section = calendarCollectionView.numberOfSections - 1
        let item = calendarCollectionView.numberOfItems(inSection: section) - 1
        let indexPath = IndexPath.init(item: item, section: section)
        calendarCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
    func refreshLayout() {
        self.collectionMonthLayout.scrollDirection = .vertical
        self.calendarCollectionView.setCollectionViewLayout(self.collectionMonthLayout, animated: true)
        self.calendarCollectionView.reloadData()
    }
    
    func reloadContent() {
        self.fromFirstDayMonth = fromDate.firstDayOfTheMonth()
        self.calendarCollectionView.reloadData()
    }
    
    private func createDateFrom() {
        var calendar = Date().calendar()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let day = dateAtIndexPath(indexPath)?.dayComponents() {
            cell.setDay("\(day)")
        } else {
            cell.setDay("")
        }
        
        cell.clipsToBounds = true
        
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
            guard let monthHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: monthHeaderViewId, for: indexPath) as? MonthHeaderView else {
                return UICollectionReusableView()
            }
            monthHeaderView.monthLabel.text = month(at: indexPath)

            return monthHeaderView
        }

        return UICollectionReusableView()
    }
}

