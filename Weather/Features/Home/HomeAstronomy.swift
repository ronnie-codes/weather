//
//  HomeAstronomy.swift
//  Weather
//
//  Created by George Washington on 1/14/25.
//

struct HomeAstronomy: Decodable {
    // swiftlint:disable nesting
    let astronomy: Astronomy

    struct Astronomy: Decodable {
        let astro: Astro

        struct Astro: Decodable {
            let sunrise: String
            let sunset: String
        }
    }
    // swiftlint:enable nesting
}

extension HomeAstronomy {
    /// A mock instance of `Home` for use in previews and testing.
    static let mock = HomeAstronomy(
        astronomy: .init(astro: .init(sunrise: "06:30", sunset: "07:00"))
    )
}
