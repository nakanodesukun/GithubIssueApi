//
//  ViewController.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/09.
//

import UIKit
import Foundation

struct Issue: Codable {
    let number: Int?
    let title: String // 一覧画面・詳細画面に表示
    let body: String // 詳細画面に表示
    let url: URL // 詳細画面に表示し、それをタップしたらSafariViewControllerで開く
    let updatedAt: String // 一覧画面・詳細画面に表示   // codingkeyが必要！！ここstring?に変更stringで取得してformattoする？？
    let user: User? // 一覧画面にアバター画像と名前を表示

    enum CodingKeys: String, CodingKey {
        case number, title, body, url, user
        case updatedAt = "updated_at"
    }
}
struct User: Codable {
    let login: String // ユーザー名
    let avaterURL: URL?
    enum CodingKeys: String, CodingKey {
        case login
        case avaterURL = "avatar_url"    //   URLが取得されるので対処必要
    }
}



class ViewController: UIViewController {
    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }
    var IssueArry: [Issue]?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tittleLabel: UILabel!
    override func viewDidLoad() {

        super.viewDidLoad()
//        fetchIssues { (Issue) in
//            Issue.forEach {(print($0.number))}
//        }
       // urlStringの引数を列挙にしたい
        // 配列の中に辞書データが入っている
        fetchIssues(urlString: urlString.TodoAppUrl) { (Issues: [Issue]) in
            // 配列に入っている辞書データを用意した空の配列に保持。保持したものをTableViewCellに保存したい
//            Issues.forEach {(print($0.body))}
            self.IssueArry = Issues
//            self.tableView.reloadData() // DispatchQue.main.asnyc{}に書き込めば紫色が消えた
        }

    }

//    func fetchIssues(completion: @escaping ([Issue]) -> ()) {
//        let urlString = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
//        let url = URL(string: urlString)
//        URLSession.shared.dataTask(with: url!) { (data, response, err) in
//            guard let data = data else {
//                print("dataの取得に失敗しました")
//                return
//            }
//            do {
//                let homfeed = try JSONDecoder().decode([Issue].self, from: data)
//                completion(homfeed)
//            } catch let jsonErr {
//                print("dataの取得に失敗しました\(jsonErr)")
//            }
//        }.resume()
//    }

    /*
    ジェネリクスを使ってどんな方でも許容する。汎用性が高い。URLから取得したJSONの型によって配列の有無が異なる。
    その為、関数の内部でdecodeする時に配列にするかどうか切り替えなければならい。よって、ジェネリクスを使い関数内部処理しないようにする。
    */
    func fetchIssues<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        let urlString = urlString
        let url = URL(string: urlString)

        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            if let err = err {
                print(err)
            }
            guard let data = data else {
                print("dataの取得に失敗しました")
                return
            }
            do {
                let obj = try JSONDecoder().decode(T.self, from: data)
                completion(obj)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let jsonErr {
                print("デコードに失敗しました\(jsonErr)")
            }
        }.resume()
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IssueArry?.count ?? 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! CustomCell
        cell.titleLable.numberOfLines = 0
        cell.titleLable.text = IssueArry?[indexPath.row].title
        if let update = IssueArry?[indexPath.row].updatedAt  {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            let date = dateFormatter.date(from: update)
            if let date = date {
                cell.updateDateLabel.text = "更新日\(date)"
                print(update)
                print(date)
            }

        } else {

            cell.updateDateLabel.text = "更新日\(IssueArry?[indexPath.row])"
        }
//        if  let avatarImage = IssueArry?[indexPath.row].user?.avaterURL {
//            print("取得に成功しました\(avatarImage)")
//
//        } else {
//            print("取得に失敗しました")
//        }
        let urlString = "https://avatars.githubusercontent.com/u/72324850?v=4"
        let url = URL(string: urlString)


        do {
            let data = try Data(contentsOf: url!)
            cell.avaterImageView.image = UIImage(data: data)
        } catch {
            print("エラーです")
        }



//        cell .updateDateLabel.text = IssueArry?[indexPath.row].updatedAt

        return cell
    }
}

