//
//  Repository+Identifiable.swift
//  Cartographer
//
//  Created by Dr. Brandon Wiley on 2/27/23.
//

import Foundation

import OctoKit

extension Repository: Identifiable
{
    public var id: ObjectIdentifier
    {
        return ObjectIdentifier(self)
    }
}

public class URLClass
{
    public let value: URL

    public init(value: URL)
    {
        self.value = value
    }
}
