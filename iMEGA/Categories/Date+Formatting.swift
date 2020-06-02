//
//  Date+Formatting.swift
//  MEGA
//
//  Created by Jun Meng on 1/6/20.
//  Copyright © 2020 MEGA. All rights reserved.
//

import Foundation

extension DateFormatter {

    // MARK: - Date Formatter

    /// Monday Jun 1, 2020
    static let dateMediumWithWeekday = DateFormatterPool.shared.dateFormatter(of: .dateMediumWithWeekday)
    /// Jun 1, 2020
    static let dateMedium = DateFormatterPool.shared.dateFormatter(of: .dateMedium)

    // MARK: - Relative date formatter, e.g. date in the next day will be "Tomorrow" etc.

    /// Jun 1, 2020 or "Tomorrow", "Today", "Yesterday"
    static let dateMediumRelative = DateFormatterPool.shared.dateFormatter(of: .dateMediumRelative)
}

enum DateTemplateFormatting {
    /// Monday Jun 1, 2020
    case dateMediumWithWeekday

    fileprivate var style: StringTemplateStyle {
        switch self {
        case .dateMediumWithWeekday:
            return StringTemplateStyle(dateFormat: "EEEE MMM dd, yyyy")
        }
    }
}

enum DateStyleFormatting {
    /// Jun 1, 2020
    case dateMedium
    /// Jun 1, 2020 or "Tomorrow", "Today", "Yesterday"
    case dateMediumRelative

    fileprivate var style: DateFormatStyle {
        switch self {
        case .dateMedium:
            return DateFormatStyle(dateStyle: .medium, timeStyle: .none, relativeDateFormatting: false)
        case .dateMediumRelative:
            return DateFormatStyle(dateStyle: .medium, timeStyle: .none, relativeDateFormatting: true)
        }
    }
}

/// A  date formatter pool that holds date formatter used in MEGA. As `DateFormatter` is a heavy object, so making a  cache pool to hold popular
/// date formatters saving time.
final class DateFormatterPool {

    // MARK: - Cache for date formatter

    private lazy var stringTemplateFormatterCache: [StringTemplateStyle: DateFormatter] = [:]

    private lazy var styleFormatterCache: [DateFormatStyle: DateFormatter] = [:]

    static var shared: Self { return self.init() }

    private init() {}

    // MARK: - Getting a date formatter by `styles`

    /// Returns a date formatter with given string template formatting. It search for cache by given `formatting`, and return immediatly. If not found,
    /// create a new one and save to cache.
    /// NOTE: As `DateFormatter` is an reference object, do *NOT* modify any property while using.
    /// - Parameter formattingStyle: A struct that holds date formatting template.
    /// - Returns: A date formatter.
    func dateFormatter(of formattingStyle: DateTemplateFormatting) -> DateFormatter {
        if let cachedStyle = stringTemplateFormatterCache[formattingStyle.style] {
            return cachedStyle
        }
        return formattingStyle.style.dateFormatter
    }

    /// Returns a date formatter with given string formatting style. It search for cache by given `style`, and return immediatly. If not found,
    /// create a new one and save to cache.
    /// NOTE: As `DateFormatter` is an reference object, do *NOT* modify any property while using.
    /// - Parameter formattingStyle: A struct that holds date formatting styles.
    /// - Returns: A date formatter.
    func dateFormatter(of formattingStyle: DateStyleFormatting) -> DateFormatter {
        if let cachedStyle = styleFormatterCache[formattingStyle.style] {
            return cachedStyle
        }
        return formattingStyle.style.dateFormatter
    }
}

// MARK: - `DateFormatter` creating configurations

/// A protocol tells who implements this should be able to provide `DateFormatter`
private protocol DateFormatterProvidable {
    var dateFormatter: DateFormatter { get }
}

/// A template string style configuration
fileprivate struct StringTemplateStyle: Hashable {
    typealias FormatString = String

    let calendar: Calendar = .current
    let dateFormat: FormatString
}

extension StringTemplateStyle: DateFormatterProvidable {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.calendar = calendar
        return formatter
    }
}

/// A formatter provided style configuration
fileprivate struct DateFormatStyle: Hashable {

    let calendar: Calendar = .current
    let dateStyle: DateFormatter.Style
    let timeStyle: DateFormatter.Style

    /// If a date formatter uses relative date formatting, where possible it replaces the date component of its output with a phrase—such as
    ///  “today” or “tomorrow”—that indicates a relative date. The available phrases depend on the locale for the date formatter; whereas,
    ///  for dates in the future, English may only allow “tomorrow,” French may allow “the day after the day after tomorrow,”
    let relativeDateFormatting: Bool
}

extension DateFormatStyle: DateFormatterProvidable {
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter
    }
}
