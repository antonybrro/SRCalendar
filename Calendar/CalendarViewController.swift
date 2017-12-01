//
//  ViewController.swift
//  Calendar
//
//  Created by Antony Yurchenko on 11/28/17.
//  Copyright © 2017 Antony Yurchenko. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendarView: UIView!
    
    var calendarCollectionView: UICollectionView!
    var monthCollectionLayout: MonthCollectionViewLayout!
    
    var fromDate: Date!
    var fromFirstDayMonth: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        self.refreshLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutIfNeeded()
        self.scrollToLastItem()
    }
    
    func setup() {
        monthCollectionLayout = MonthCollectionViewLayout()
        monthCollectionLayout.scrollDirection = .vertical
        
        calendarCollectionView = CalendarCollectionView(frame: self.calendarView.bounds, collectionViewLayout: self.monthCollectionLayout)
        calendarCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.alwaysBounceVertical = false
        
        self.calendarView.addSubview(calendarCollectionView)
        
        createDateFrom()
        reloadContent()
    }
    
    func scrollToLastItem() {
        let section = calendarCollectionView.numberOfSections - 2
        let indexPath = IndexPath.init(item: 10, section: section)
        calendarCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
    
    func refreshLayout() {
        self.monthCollectionLayout.setupWidth(self.calendarView.frame.width)
        self.calendarCollectionView.frame = self.calendarView.bounds
        self.monthCollectionLayout.scrollDirection = .vertical
        self.calendarCollectionView.setCollectionViewLayout(self.monthCollectionLayout, animated: true)
        self.calendarCollectionView.reloadData()
    }
    
    func reloadContent() {
        self.fromFirstDayMonth = fromDate.firstDayOfTheMonth()
        self.calendarCollectionView.reloadData()
    }
    
    private func createDateFrom() {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.day = 1
        components.month = 1
        components.year = 2017
        
        fromDate = Calendar.current.date(from: components)
    }
    
    private func nameOfMonth(at indexPath: IndexPath) -> String {
        let date = dateForFirstDayInSection(indexPath.section)
        let components = Calendar.current.dateComponents([.month, .year], from: date)
        var monthName = Date().monthSymbol(at: components.month!)
        if components.month! == 1 {
            monthName = monthName + " \(components.year!)"
        }
        
        return monthName
    }
}

extension CalendarViewController: UICollectionViewDataSource {
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
        
        return Calendar.current.date(byAdding: dateComponents, to: fromFirstDayMonth)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        let date = dateAtIndexPath(indexPath)

        if let day = date?.dayComponents() {
            cell.setupCell("\(day)", date!.getDayType())
        } else {
            cell.setupCell("")
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
            return Calendar.current.date(byAdding: components, to: fromFirstDayMonth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            guard let monthHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: monthHeaderViewId, for: indexPath) as? MonthHeaderView else {
                return UICollectionReusableView()
            }
            
            monthHeaderView.monthLabel.text = nameOfMonth(at: indexPath)
            
            return monthHeaderView
        }
        
        return UICollectionReusableView()
    }
}
