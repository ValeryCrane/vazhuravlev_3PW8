//
//  SortChoiceViewController.swift
//  vazhuravlev_3PW8
//
//  Created by Валерий Журавлев on 21.03.2022.
//

import Foundation
import UIKit

// This view makes choice of sortiong of moview possible.
class SortChoiceViewController: UIViewController {
    public weak var sortingTypeDataStore: SortingTypeDataStore!
    private var picker: UIPickerView?
    private var sortingTitles = ["by popularity", "by revenue", "by date"]
    private var sortingTypes = ["popularity.desc", "revenue.desc", "primary_release_date.desc"]
    
    // MARK: - ViewController's life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurePicker()
    }
    
    // MARK: - setup functions
    private func configurePicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            picker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            picker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
        for i in 0..<sortingTypes.count {
            if sortingTypeDataStore.sortingType == sortingTypes[i] {
                picker.selectRow(i, inComponent: 0, animated: true)
            }
        }
        self.picker = picker
    }
}


// MARK: - UIPickerViewDelegate & DataSource implementation
extension SortChoiceViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sortingTypeDataStore.sortingType = sortingTypes[row]
    }
}

extension SortChoiceViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sortingTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sortingTitles[row]
    }
}
