//
//  Utils.swift
//  GymApp
//
//  Created by Juan Carlos Hernandez Castillo on 30/07/23.
//

import Foundation

func getCurrentWeekday() -> DayOfWeek? {
    let date = Date()
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    
    switch weekday {
    case 1:
        return DayOfWeek.sunday
    case 2:
        return DayOfWeek.monday
    case 3:
        return DayOfWeek.tuesday
    case 4:
        return DayOfWeek.wednesday
    case 5:
        return DayOfWeek.thursday
    case 6:
        return DayOfWeek.friday
    case 7:
        return DayOfWeek.saturday
    default:
        return nil
    }
}

func getCurrentDate() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE d MMM"
    dateFormatter.locale = Locale(identifier: "en_US")
    let formattedDate = dateFormatter.string(from: date)
    return formattedDate
}

func getWeekDays() -> [DayOfWeek] {
    return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
}
