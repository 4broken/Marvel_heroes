//
//  HeroesTableViewCell.swift
//  Test1
//
//  Created by Shamil Mazitov on 29.04.2022.
//

import Foundation
import UIKit
import CoreData

class HeroesTableViewCell: UITableViewCell {
    static let identifier = "HeroesTableViewCell"
    var padding: CGFloat = 30
    lazy var heroesDescription : UILabel = {
    let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    lazy var heroesProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy var nameOfHeroLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupConstraints() {
        let offset: CGFloat = 16
         var constraints = [NSLayoutConstraint]()
        constraints.append(nameOfHeroLabel.rightAnchor.constraint(equalTo: nameOfHeroLabel.rightAnchor))
        constraints.append(nameOfHeroLabel.leftAnchor.constraint(equalTo: heroesProfileImageView.rightAnchor, constant: offset))
        constraints.append(nameOfHeroLabel.bottomAnchor.constraint(equalTo: nameOfHeroLabel.bottomAnchor))
        constraints.append(nameOfHeroLabel.topAnchor.constraint(equalTo: topAnchor, constant: offset))
        
        constraints.append(heroesProfileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20))
        constraints.append(heroesProfileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: .zero))
        constraints.append(heroesProfileImageView.widthAnchor.constraint(equalToConstant: 40))
        constraints.append(heroesProfileImageView.heightAnchor.constraint(equalTo: heroesProfileImageView.widthAnchor, multiplier: 1))

        NSLayoutConstraint.activate(constraints)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(heroesProfileImageView)
        contentView.addSubview(nameOfHeroLabel)
        setupConstraints()
    }
    
    required init?(coder : NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        heroesProfileImageView.layer.cornerRadius = heroesProfileImageView.frame.width / 2
    }
}

extension NSLayoutConstraint {
            func withPriority(_ priority: Float) -> NSLayoutConstraint {
                self.priority = UILayoutPriority(priority)
                return self
            }
        }
