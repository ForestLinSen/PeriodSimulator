import Foundation

// 设置多少天以内就算匹配，0表示在同一天
let closeDay = 0

// 设置初始化的时间范围，每位的起始时间会在这个范围里面随机挑选
let date1 = parseDate("2022-05-01")
let date2 = parseDate("2022-05-31")

// 设置总人数，默认为6人
var numberOfPerson = 6

// 设置模拟的月份数，默认为12个月
var simulateMonths = 12

func randomDate(start: Date, end: Date) -> Date{
    let date1 = start
    let date2 = end
    
    let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
    
    return Date(timeIntervalSinceNow: span)
}

func parseDate(_ string: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .current
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: string) ?? Date()
}

func displayDate(from date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = .current
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}

func nextPeriod(_ currentDate: Date, _ days: Int) -> Date{
    return Calendar(identifier: .chinese).date(byAdding: .day, value: days, to: currentDate) ?? Date()
}

func checkCloseDay(_ date1: Date, _ date2: Date) -> Bool{
    
    if closeDay == 0{
        let dayOneComponent = Calendar(identifier: .chinese).dateComponents([.day, .month], from: date1)
        let dayTwoComponent = Calendar(identifier: .chinese).dateComponents([.day, .month], from: date2)
        return dayOneComponent.day == dayTwoComponent.day && dayOneComponent.month == dayTwoComponent.month
    }
    
    let components = Calendar(identifier: .chinese).dateComponents([.day], from: date1, to: date2)
    if let day = components.day{
        return abs(day) < closeDay
    }else{
        return false
    }
}


var peoplePeriods = [Date]()

for _ in 0..<numberOfPerson{
    peoplePeriods.append(randomDate(start: date1, end: date2))
}

var count = 0
for _ in 0..<simulateMonths{
    var found = false
    var printDates = [String]()
    
    // Proceed
    for i in peoplePeriods.indices{
        peoplePeriods[i] = nextPeriod(peoplePeriods[i], Int.random(in: 25...31))
        printDates.append(displayDate(from: peoplePeriods[i]))
    }
    
    for i in peoplePeriods.indices{
        for j in peoplePeriods.indices{
            if i == j{
                break
            }else{
                if checkCloseDay(peoplePeriods[i], peoplePeriods[j]){
                    found = true
                    printDates[i] = "*\(printDates[i])"
                    printDates[j] = "*\(printDates[j])"
                }
            }
        }
    }
    
    for date in printDates{
        print(date)
    }
    print("")
    
    if found{
        count += 1
    }
}

print(String(format: "有百分之%.2f的月份符合条件", (Double(count) / Double(simulateMonths))*100))

