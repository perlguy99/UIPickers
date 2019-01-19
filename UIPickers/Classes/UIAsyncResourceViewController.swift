//
//  UIAsyncResourceViewController.swift
//  UIPickers
//
//  Created by Erick Sanchez on 1/19/19.
//

import UIKit

public protocol UIAsyncResourceViewControllerResourcer {
    func fetchResources(completion: @escaping ([Resource]) -> Void)
}

class Resourcer: UIResourceViewControllerResourcer {
    
    // MARK: - VARS
    
    var predicateSearch: (Resource, String) -> Bool {
        return { _,_ in true }
    }
    
    var resources: [Resource] = []
    
    private var asyncResourcer: UIAsyncResourceViewControllerResourcer
    
    init(asyncResourcer: UIAsyncResourceViewControllerResourcer) {
        self.asyncResourcer = asyncResourcer
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    func fetch(completion: @escaping () -> Void) {
        self.asyncResourcer.fetchResources { [weak self] (fetchedResources) in
            guard let unwrappedSelf = self else { return }
            
            unwrappedSelf.resources = fetchedResources
            completion()
        }
    }
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
}

open class UIAsyncResourceViewController: UIResourceViewController {
    
    var internalResourcer: Resourcer

    // MARK: - VARS
    
    public init(headerText: String?, messageText: String?, asyncResourcer: UIAsyncResourceViewControllerResourcer) {
        self.internalResourcer = Resourcer(asyncResourcer: asyncResourcer)
        
        super.init(headerText: headerText, messageText: messageText, resourcer: internalResourcer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented") //no value for self.internalResourcer
    }
    
    // MARK: - RETURN VALUES
    
    // MARK: - METHODS
    
    // MARK: - IBACTIONS
    
    // MARK: - LIFE CYCLE
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO: present loading
        internalResourcer.fetch { [weak self] in
            
            //TODO: dismiss loading
            self?.tableView.reloadData()
        }
    }
}