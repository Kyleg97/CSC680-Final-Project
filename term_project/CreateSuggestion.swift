//
//  CreateSuggestion.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/9/22.
//

import Foundation

enum Tops {
    case tshirt
    case tanktop
    case longsleeve
}

enum Bottoms {
    case jeans
    case shorts
    case pants
}

enum Outerwear {
    case sweater
    case hoodie
    case windbreaker
    case jacket
}

enum Shoes {
    case sneakers
    case sandals
    case boots
}

enum Accessory {
    case hat
    case scarf
    case beanie
    case gloves
    case socks
    case sunscreen
}

class CreateSuggestion {
    
    class Outfit {
        var top: [Tops]
        var bottom: Bottoms
        var outerwear: [Outerwear]
        var shoes: Shoes
        var accessory: [Accessory]
        
        init() {
            self.top = []
            self.bottom = Bottoms.shorts
            self.outerwear = []
            self.shoes = Shoes.sandals
            self.accessory = []
        }
        
        init(top: [Tops], bottom: Bottoms, outerwear: [Outerwear], shoes: Shoes, accessory: [Accessory]) {
            self.top = top
            self.bottom = bottom
            self.outerwear = outerwear
            self.shoes = shoes
            self.accessory = accessory
        }
    }
    
    func calculateSuggestion(weather: WeatherModel) -> Outfit {
        var temp = weather.main.temp ?? -1
        var tempMin = weather.main.tempMin ?? -1
        var tempMax = weather.main.tempMax ?? -1
        var averageTemp = (tempMin + tempMax) / 2
        var wind = weather.wind.speed ?? -1
        var gust = weather.wind.gust ?? -1
        var humidity = weather.main.humidity ?? -1
        var clouds = weather.clouds.all ?? -1
        
        var outfit = Outfit()
        
        if (temp < 120) {
            outfit.top.append(Tops.tshirt)
            outfit.bottom = Bottoms.shorts
            outfit.shoes = Shoes.sandals
            if (wind > 12) {
                outfit.outerwear.append(Outerwear.windbreaker)
            }
        }
        if (temp < 80) {
            outfit.shoes = Shoes.sneakers
        }
        if (temp < 75) {
            if (wind > 12) {
                outfit.bottom = Bottoms.pants
            } else {
                outfit.bottom = Bottoms.shorts
            }
        }
        if (temp < 65) {
            if (wind > 12) {
                outfit.bottom = Bottoms.jeans
            } else {
                outfit.bottom = Bottoms.pants
            }
            outfit.outerwear.append(Outerwear.hoodie)
        }
        return outfit
    }
}
