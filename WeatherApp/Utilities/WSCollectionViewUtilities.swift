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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WSCollectionViewCell.identifier, for: indexPath) as! WSCollectionViewCell
        let model = viewModel.hours[indexPath.row]
        cell.setup(model: model)
        cell.layer.cornerRadius = 12

        cell.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 169/255, green: 222/255, blue: 249/255, alpha: 1.0)}
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.systemBlue.cgColor
   

        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            let sectionInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5) // İlk hücrenin solundan ve son hücrenin sağından 5 birim boşluk
            return sectionInsets
        }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    }
