//
//  TableViewUtilities.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 11.07.2024.
//

import UIKit

extension WeatherScreenVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.hours.count - 24 // sadece 24 saatlik olması için 24 azaltıyoruz
        
    }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WACollectionViewCell.identifier, for: indexPath) as! WACollectionViewCell
        let model = viewModel.hours[indexPath.row]
        cell.setup(model: model)
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 12
        cell.layer.borderColor = UIColor(red: 172/255, green: 255/255, blue: 251/255, alpha: 1.0).cgColor

        cell.backgroundColor = .systemBackground

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            let sectionInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) // İlk hücrenin solundan ve son hücrenin sağından 5 birim boşluk
            return sectionInsets
        }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Dark Mode
        let darkModeBackgroundColor = UIColor.black
        
        if let customCell = cell as? WACollectionViewCell {
            customCell.backgroundColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? darkModeBackgroundColor : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
            }
            
            // Border rengi
            customCell.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor(red: 172/255, green: 255/255, blue: 251/255, alpha: 1.0).cgColor
            }
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    }
