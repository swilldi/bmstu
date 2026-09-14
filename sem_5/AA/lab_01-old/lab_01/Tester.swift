//
//  Tester.swift
//  lab_01
//
//  Created by Dmitriy on 14.09.2026.
//

import Foundation

struct Tester {
    struct TestCase {
        let name: String
        let array: [Int]
        let target: Int
        let expected: Int
    }

    struct Failure {
        let test: TestCase
        let actual: Int
    }

    static let notFound = -1

    let algorithms: [(name: String, f: ([Int], Int) -> Int)] = [
        ("brute_force_search", brute_force_search),
        ("bin_search_1", bin_search_1),
        ("bin_search_2", bin_search_2),
        ("bin_search_recursion", bin_search_recursion)
    ]

    // Все массивы отсортированы: иначе бинарные поиски тестировать нельзя.
    let tests: [TestCase] = [
        // Элемент есть
        TestCase(name: "первый элемент",
                 array: [1, 2, 3, 4, 5, 6, 7, 8], target: 1, expected: 0),
        TestCase(name: "последний элемент",
                 array: [1, 2, 3, 4, 5, 6, 7, 8], target: 8, expected: 7),
        TestCase(name: "середина, чётная длина",
                 array: [1, 2, 3, 4, 5, 6, 7, 8], target: 5, expected: 4),
        TestCase(name: "середина, нечётная длина",
                 array: [1, 2, 3, 4, 5, 6, 7], target: 4, expected: 3),

        // Элемента нет
        TestCase(name: "больше максимума",
                 array: [1, 2, 3, 4, 5, 6, 7, 8], target: 10, expected: notFound),
        TestCase(name: "меньше минимума",
                 array: [3, 4, 5, 6, 7, 8, 9, 10], target: 1, expected: notFound),
        TestCase(name: "пропуск в середине",
                 array: [1, 2, 3, 4, 7, 8, 9, 10], target: 5, expected: notFound),
        TestCase(name: "между соседними значениями",
                 array: [10, 20, 30, 40], target: 25, expected: notFound),

        // Граничные размеры
        TestCase(name: "один элемент, найден",
                 array: [42], target: 42, expected: 0),
        TestCase(name: "один элемент, не найден",
                 array: [42], target: 7, expected: notFound),
        TestCase(name: "два элемента, первый",
                 array: [1, 2], target: 1, expected: 0),
        TestCase(name: "два элемента, второй",
                 array: [1, 2], target: 2, expected: 1),
        TestCase(name: "два элемента, не найден",
                 array: [1, 2], target: 3, expected: notFound),

        // Отрицательные значения и разреженный массив
        TestCase(name: "отрицательные значения",
                 array: [-10, -5, -1, 0, 3], target: -5, expected: 1),
        TestCase(name: "разреженный массив",
                 array: [1, 100, 1000, 10_000], target: 1000, expected: 2)
    ]

    /// Возвращает true, если все алгоритмы прошли все тесты.
    @discardableResult
    func runTests() -> Bool {
        var allPassed = true

        for (name, f) in algorithms {
            var failures: [Failure] = []

            for test in tests {
                let actual = f(test.array, test.target)
                if actual != test.expected {
                    failures.append(Failure(test: test, actual: actual))
                }
            }

            let passed = tests.count - failures.count
            let status = failures.isEmpty ? "OK" : "FAIL"
            print("\(name): \(passed)/\(tests.count) — \(status)")

            for failure in failures {
                report(failure)
                allPassed = false
            }
        }

        return allPassed
    }

    /// Подробности только по упавшим тестам: что подали, что ждали, что получили.
    private func report(_ failure: Failure) {
        let test = failure.test

        print("    ✗ \(test.name)")
        print("      массив:    \(test.array)")
        print("      x:         \(test.target)")
        print("      ожидалось: \(describe(test.expected, in: test.array))")
        print("      получено:  \(describe(failure.actual, in: test.array))")
    }

    private func describe(_ index: Int, in array: [Int]) -> String {
        if index == Tester.notFound {
            return "-1 (не найден)"
        }
        guard array.indices.contains(index) else {
            return "\(index) (индекс вне границ массива)"
        }
        return "\(index) (значение \(array[index]))"
    }
}
