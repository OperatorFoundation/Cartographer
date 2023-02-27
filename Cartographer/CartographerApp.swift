//
//  CartographerApp.swift
//  Cartographer
//
//  Created by Dr. Brandon Wiley on 2/23/23.
//

import SwiftUI

import Gardener

@main
struct CartographerApp: App
{
    @ObservedObject var github: GithubModel

    public init()
    {
        let clientId: String = Environment.getEnvironmentVariable(key: "CLIENT_ID") ?? ""
        let clientSecret: String = Environment.getEnvironmentVariable(key: "CLIENT_SECRET") ?? ""

        self.github = GithubModel(clientId: clientId, clientSecret: clientSecret)
    }

    var body: some Scene
    {
        WindowGroup
        {
            RepositoryView(github: github).body
            .onOpenURL
            {
                url in

                github.setCode(from: url)
            }
        }
    }
}
