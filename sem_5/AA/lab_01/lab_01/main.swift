//
//  main.swift
//  lab_01
//
//  Created by Dmitriy Dudyrev on 13.09.2026.
//

import Foundation

let algorithms: [(name: String, f: ([Int], Int) -> Int)] = [
    ("brute_force_search", brute_force_search),
    ("bin_search_1", bin_search_1),
    ("bin_search_2", bin_search_2),
    ("bin_search_recursion", bin_search_recursion)
]

let tests: [(in: ([Int], Int), out: Int)] = [
    (([1, 2, 3, 4, 5, 6, 7, 8], 1), 0),
    (([1, 2, 3, 4, 5, 6, 7, 8], 8), 7),
    (([1, 2, 3, 4, 5, 6, 7, 8], 5), 4),
    
    (([1, 2, 3, 4, 5, 6, 7, 8], 10), -1),
    (([3, 4, 5, 6, 7, 8, 9, 10], 1), -1),
    (([1, 2, 3, 4, 7, 8, 9, 10], 5), -1),
]

for (name, f) in algorithms {
    var passed = 0
    for test in tests {
        if f(test.in.0, test.in.1) == test.out {
            passed += 1
        } else {
            print("\(name): \(test) – FAIL | \(f(test.in.0, test.in.1))")
        }
    }
    print("\(name): \(passed)/\(tests.count)")
}
