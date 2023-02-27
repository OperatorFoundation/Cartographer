//
//  ContentView.swift
//  Cartographer
//
//  Created by Dr. Brandon Wiley on 2/23/23.
//

import SwiftUI

import Gardener

struct RepositoryView
{
    @SwiftUI.Environment(\.openURL) var openURL

    @ObservedObject var github: GithubModel

    public init(github: GithubModel)
    {
        self.github = github
    }

    var body: some View
    {
        VStack
        {
            if github.authenticated
            {
                if let username = $github.username.wrappedValue
                {
                    Text("Authenticated \(username)")
                }

                List($github.repositories)
                {
                    Text($0.wrappedValue.name ?? "<Empty>")
                }
            }
            else
            {
                Text("Not Authenticated")

                if let url = $github.authenticationURL.wrappedValue
                {
                    Button(action: { openURL(url); /*exit(0)*/ })
                    {
                        Text("Login")
                    }
                }
            }
        }
        .padding()
    }
}

struct RepositoryView_Previews: PreviewProvider
{
    static var previews: some View
    {
        let clientId: String! = Environment.getEnvironmentVariable(key: "CLIENT_ID")
        let clientSecret: String! = Environment.getEnvironmentVariable(key: "CLIENT_SECRET")

        let github = GithubModel(clientId: clientId, clientSecret: clientSecret)
        return RepositoryView(github: github).body
    }
}
