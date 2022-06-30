//
//  Article.swift
//  RxSwiftDemo
//
//  Created by Hiram Castro on 28/06/22.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]
}

extension ArticlesList {
    static var all: Resource<ArticlesList> = {
       let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=2bd9df50a6534aefb255a41f91cafda7")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String?
    let description: String?
}
