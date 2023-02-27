//
//  GithubModel.swift
//  Cartographer
//
//  Created by Dr. Brandon Wiley on 2/23/23.
//

import Foundation
import SwiftUI

import Chord
import OctoKit

public class GithubModel: ObservableObject
{
    static let scopes: [String] = ["repo", "read:org"]

    @Published public var authenticated: Bool = false
    @Published public var authenticationURL: URL?
    @Published public var repositories: [Repository] = []
    @Published public var username: String? = nil

    public var code: String? = nil

    let oauthConfig: OAuthConfiguration

    var tokenConfig: TokenConfiguration?

    public init(clientId: String, clientSecret: String)
    {
        self.oauthConfig = OAuthConfiguration(token: clientId, secret: clientSecret, scopes: Self.scopes)
        self.authenticationURL = self.oauthConfig.authenticate()
    }

    public func setCode(from url: URL)
    {
        self.oauthConfig.handleOpenURL(url: url)
        {
            config in

            guard let accessToken = config.accessToken else
            {
                return
            }

            self.tokenConfig = config
            self.code = accessToken

            MainThreadEffect.sync
            {
                self.authenticated = true
            }

            self.fetchUser()
            self.fetchRepositories()
        }
    }

    public func fetchUser()
    {
        guard let config = self.tokenConfig else
        {
            return
        }

        Octokit(config).me
        {
            response in

            switch response
            {
                case .success(let user):
                    guard let login = user.login else
                    {
                        return
                    }

                    print(login)

                    MainThreadEffect.sync
                    {
                        self.username = user.login
                    }

                case .failure(let error):
                    print(error)
            }
        }
    }

    public func fetchRepositories()
    {
        guard let config = self.tokenConfig else
        {
            return
        }

        Octokit(config).repositories
        {
            repositoriesResult in

            MainThreadEffect.sync
            {
                switch repositoriesResult
                {
                    case .success(let repositories):
                        print(repositories)
                        for repository in repositories
                        {
                            self.repositories.append(repository)
                        }

                    case .failure(let error):
                        print(error)
                        return
                }
            }
        }
    }
}
