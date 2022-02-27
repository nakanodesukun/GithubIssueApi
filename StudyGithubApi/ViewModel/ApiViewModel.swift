//
//  UserListViewModel.swift
//  StudyGithubApi
//
//  Created by 中野翔太 on 2022/02/15.
//


import UIKit

/* MVVMを意識するとModelとViewは直接の依存関係を持ってはいけない。ViewModelはViewとModelの仲介役。
 ViewとViewModleのデータバインディングを行うには、CombineやRXSwiftを用いればMVVMらしくなると気付いた。
 現状のスキルだとMVCやMVPアーキテクチャで書いた方が良い。しかし、変更してMVCやMVPで記述するとFatViewControllerになってしまう。
 */
final class ApiViewModel {

    private let apiModel = ApiModel()
//    private let imageViewModel = ImageViewModel()
    
//    weak var delegate: IssueApiDelegate?

    enum urlString {
        static let TodoAppUrl = "https://api.github.com/repos/app-dojo-salon/ToDoAppEx/issues"
    }
    
    func getApi(sucessIssue: @escaping([Issue]) -> Void, sucessDate: @escaping ([String]) -> Void, failure: @escaping (ApiModel.ApiError) -> Void) {
        apiModel.fetchData(urlString: urlString.TodoAppUrl) { [weak self] result in
            // 成功と失敗の処理を分岐させ、結果をNotificationCenterでViewContorllerに渡す
            switch result {
            case .success(let issue):
            
                // インジケータを表示させるために処理遅延させる
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                   //  時刻の変換
//                    issue.forEach { time in
//                        guard let date =  self?.dateFromString(string: time.updatedAt) else { return }
//
//                        guard let dateString = self?.stringFromDate(date: date) else { return }
//
//                        sucessDate([dateString])
//                    }
                   let updateAt = issue.map{$0.updatedAt}
                    print(updateAt)

                    sucessIssue(issue)
                }
            case .failure(let error):
                failure(error)
            }

        }
    }
    // UpdateAtをString型で取得しているのでDate型に変換する
    private func dateFromString(string: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return formatter.date(from: string)!
    }
    // Data型の値をString型に再変換し
    private func stringFromDate(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        return formatter.string(from: date)
    }
}


