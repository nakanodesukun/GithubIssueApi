//
//  DetailViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

//    var title: String?
    var detail:[Issue] = []
    var selectedText: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        detail.forEach({print($0.body)})
    
    }

    @IBAction func didTapUrlButton(_ sender: Any) {

    }





}
