//
//  PhotoViewController.swift
//  SDSquareAssignment
//
//  Created by Amit Pant on 03/07/17.
//  Copyright © 2017 Amit Pant. All rights reserved.
//
import UIKit

class PhotoViewController: UIViewController {
    
    // MARK: - Injections
    internal var networkClient = NetworkClient.shared
    
    // MARK: - Instance Properties
    internal var users: [User] = []
    
    weak var pageViewController: UIPageViewController!
    
    internal func loadUsers() {
        networkClient.getUsers(offset: 10,
                               limit: 10,
                               success: {[weak self] users in
                                guard let strongSelf = self else {return}
                                strongSelf.users = users
                                strongSelf.configurePageView()},
                               failure: { error in
                                print("Product download failed: \(error)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUsers()
    }
    
    // MARK: - Private functions
    private func configurePageView()  {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.backgroundColor = UIColor.white
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewContoller") as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        let startingViewController = self.viewControllerAtIndex(index: 0)
        self.pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    fileprivate func viewControllerAtIndex(index:Int) -> PageContentViewController {
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        pageContentViewController.user = users[index]
        pageContentViewController.index = index;
        return pageContentViewController;
    }
}

extension PhotoViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        index += 1
        if (index == self.users.count) {
            return nil
        }
        return self.viewControllerAtIndex(index: index);
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).index
        if index == 0 {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index: index);
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.users.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
