//
//  ViewController.swift
//  Test1
//
//  Created by Shamil Mazitov on 07.03.2022.
//

import UIKit
import CoreData
import CryptoKit

class ViewController: UIViewController {
    var container: NSPersistentContainer!
    let connection = DataStoreManager()
    var network = NetworkManager()
    var results = [Result]()
    let imageView = UIImageView()
    var personailities : [Personalities] = []
    var fetchedResultsController: NSFetchedResultsController<Personalities>!
    var fetchingMore : Bool = false
    var indexOfPage = 1
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(HeroesTableViewCell.self, forCellReuseIdentifier: HeroesTableViewCell.identifier)
        return table
    }()
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Heroes"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.addSubview(self.tableView)
        updateLayout(with: view.frame.size)
        network.getAllCharacters()
        loadSavedData()
        
    }
  
    
    public func loadSavedData() {
            let request = Personalities.createFetchRequest()
            let sort = NSSortDescriptor(key: "name", ascending: false)
            request.sortDescriptors = [sort]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: DataStoreManager.shared.persistentContainer.viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
            fetchedResultsController.delegate = self
        request.fetchLimit = 15
        request.fetchOffset = 15
            try? fetchedResultsController.performFetch()
            reloadTableView()
    }
       
        func updateLayout(with size: CGSize) {
                self.tableView.frame = CGRect.init(origin: .zero, size: size)
        }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: {(context) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        tableView.rowHeight = 44
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeroesTableViewCell.identifier, for:indexPath) as! HeroesTableViewCell
        let persona = fetchedResultsController.object(at: indexPath)
        cell.nameOfHeroLabel.text = persona.value(forKey: "name") as? String
        let imageData = persona.value(forKey: "image") as! Data
        cell.heroesProfileImageView.image = UIImage(data: imageData)
        return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let persona = fetchedResultsController.object(at: indexPath)
        let destinationVC = ChatViewController()
        destinationVC.namesOfCharacters = persona.name
        destinationVC.profileImages = UIImage(data: persona.image!)
        destinationVC.navigationItem.title = "Chat"
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        print("Deleted")
            let persona = fetchedResultsController.object(at: indexPath)
            let context = DataStoreManager.shared.persistentContainer.newBackgroundContext()
            context.delete(persona)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DispatchQueue.main.async {
                try? context.save()}
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
        }
    }
    
    public enum NSFetchResultsChangeType: UInt {
        case insert
        case delete
        case move
        case update
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet (index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet (index: sectionIndex) as IndexSet, with: .fade)
        default:
            return
        
    }
}
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: [indexPath], with: .fade)
            }
            }
        case .delete:
            if let indexPath = indexPath {
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        case .update:
            if let indexPath = indexPath {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        case .move:
            if let indexPath = indexPath{
                DispatchQueue.main.async {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            }
            if let newIndexPath = newIndexPath {
                DispatchQueue.main.async {
                    self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            }
        default:
            DispatchQueue.main.async {
                self.tableView.reloadData()

            }        
    }
}
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            self.tableView.endUpdates()
            
        }
}
}
    
extension ViewController: UIScrollViewDelegate {
    
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height
         if offsetY > contentHeight - scrollView.frame.height {
             if !fetchingMore {
                 indexOfPage += 1
                 beginBatchFetch()
             }
         }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        print("BeginBatchFetch")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            if self.indexOfPage > 1 {
                self.network.getAllCharacters()
                self.tableView.reloadData()
            }
        })
    }
}
    
    /* func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if(offsetY>contentHeight-scrollView.frame.height*4) && !isLoading {
            loadMoreData()
        }
    }
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(3)
                self.loadSavedData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }*/

