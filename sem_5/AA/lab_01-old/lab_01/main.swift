//
//  main.swift
//  lab_01
//
//  Created by Dmitriy Dudyrev on 13.09.2026.
//

import Foundation

struct Main {
    typealias Algorithm = ([Int], Int) -> Int

    /// Описание алгоритма: имя для меню, сама функция и то,
    /// по какому из двух массивов она должна работать.
    struct AlgorithmInfo {
        let name: String
        let run: Algorithm
        let requiresSorted: Bool
    }

    static let algorithms: [AlgorithmInfo] = [
        AlgorithmInfo(name: "Полный перебор",
                      run: brute_force_search,
                      requiresSorted: false),
        AlgorithmInfo(name: "Бинарный поиск",
                      run: bin_search_1,
                      requiresSorted: true),
        AlgorithmInfo(name: "Бинарный поиск (без предварительного выхода)",
                      run: bin_search_2,
                      requiresSorted: true),
        AlgorithmInfo(name: "Бинарный поиск (рекурсия)",
                      run: bin_search_recursion,
                      requiresSorted: true)
    ]

    static let notFound = -1

    /// Исходный массив в порядке ввода — для полного перебора.
    private let source: [Int]
    /// Отсортированный дубликат — для бинарных поисков.
    private let sorted: [Int]

    private var selectedIndex: Int = 0
    private var isRunning: Bool = true

    private var selected: AlgorithmInfo { Main.algorithms[selectedIndex] }

    init(array: [Int]) {
        source = array
        sorted = array.sorted()
    }

    // MARK: - Ввод

    /// Результат чтения строки: EOF (Ctrl+D) отличается от неверного ввода.
    private enum ReadResult<T> {
        case value(T)
        case invalid
        case eof
    }

    private static func read<T: LosslessStringConvertible>(_ msg: String = "") -> ReadResult<T> {
        print(msg, terminator: "")
        guard let line = readLine() else { return .eof }

        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = T(trimmed) else { return .invalid }

        return .value(value)
    }

    private func read<T: LosslessStringConvertible>(_ msg: String = "") -> ReadResult<T> {
        Main.read(msg)
    }

    /// Запрашивает массив одной строкой, пока ввод не окажется корректным.
    /// Возвращает nil, если поток ввода закончился.
    static func readArray() -> [Int]? {
        while true {
            let line: String
            switch read("Введите элементы массива через пробел: ") as ReadResult<String> {
            case .value(let text):
                line = text
            case .invalid:
                continue
            case .eof:
                return nil
            }

            let tokens = line.split(whereSeparator: { $0.isWhitespace || $0 == "," })

            guard !tokens.isEmpty else {
                print("Массив не может быть пустым")
                continue
            }

            var values: [Int] = []
            values.reserveCapacity(tokens.count)

            var hasError = false
            for token in tokens {
                guard let value = Int(token) else {
                    print("«\(token)» — не целое число")
                    hasError = true
                    break
                }
                values.append(value)
            }
            if hasError { continue }

            guard Set(values).count == values.count else {
                print("Элементы массива должны быть различными")
                continue
            }

            return values
        }
    }

    // MARK: - Поиск

    /// Запрашивает x. Возвращает nil, если значение не введено.
    private mutating func readTarget() -> Int? {
        switch read("Введите искомое значение x: ") as ReadResult<Int> {
        case .value(let value):
            return value
        case .invalid:
            print("Некорректное значение")
            return nil
        case .eof:
            isRunning = false
            return nil
        }
    }

    /// Единая точка запуска: выбирает массив по требованию алгоритма.
    private func search(_ algorithm: AlgorithmInfo, _ target: Int) -> (array: [Int], index: Int) {
        let array = algorithm.requiresSorted ? sorted : source
        return (array, algorithm.run(array, target))
    }

    /// Соглашение: функции поиска возвращают -1, если элемент не найден.
    private func describe(_ array: [Int], _ index: Int) -> String {
        if index == Main.notFound {
            return "не найден"
        }

        guard array.indices.contains(index) else {
            return "некорректный индекс \(index) — ошибка в реализации алгоритма"
        }

        return "индекс \(index), значение \(array[index])"
    }

    private mutating func findElement() {
        guard let target = readTarget() else { return }

        let (array, index) = search(selected, target)

        print("Алгоритм: \(selected.name)")
        print("Массив:   \(selected.requiresSorted ? "отсортированный дубликат" : "исходный")")
        print("Результат: \(describe(array, index))")
    }

    private mutating func findWithAllAlgorithms() {
        guard let target = readTarget() else { return }

        let width = Main.algorithms.map(\.name.count).max() ?? 0

        print("\nПоиск значения \(target):")
        for algorithm in Main.algorithms {
            let (array, index) = search(algorithm, target)
            let padding = String(repeating: " ", count: width - algorithm.name.count)
            print("  \(algorithm.name)\(padding)  —  \(describe(array, index))")
        }
        print("\nИндексы бинарных поисков относятся к отсортированному дубликату.")
    }

    // MARK: - Меню

    private mutating func selectAlgorithm() {
        print("")
        for (i, algorithm) in Main.algorithms.enumerated() {
            let mark = i == selectedIndex ? " (текущий)" : ""
            print("\(i + 1). \(algorithm.name)\(mark)")
        }

        switch read("Выберите: ") as ReadResult<Int> {
        case .value(let choice) where (1...Main.algorithms.count).contains(choice):
            selectedIndex = choice - 1
            print("Выбран алгоритм: \(selected.name)")
        case .value, .invalid:
            print("Некорректный выбор")
        case .eof:
            isRunning = false
        }
    }

    func showArrays() {
        print("Исходный  (\(source.count) эл.): \(source)")
        print("Сортиров. (\(sorted.count) эл.): \(sorted)")
    }

    private func runTests() {
        print("")
        if Tester().runTests() {
            print("\nВсе тесты пройдены")
        }
    }

    private mutating func showMenu() {
        print(
            """

            Текущий алгоритм: \(selected.name)
            1. Найти элемент текущим алгоритмом
            2. Найти элемент всеми алгоритмами
            3. Выбрать алгоритм
            4. Показать массивы
            5. Запустить тесты
            0. Выход
            """
        )

        switch read("Выберите: ") as ReadResult<Int> {
        case .value(1): findElement()
        case .value(2): findWithAllAlgorithms()
        case .value(3): selectAlgorithm()
        case .value(4): showArrays()
        case .value(5): runTests()
        case .value(0): isRunning = false
        case .value, .invalid: print("Некорректный пункт меню")
        case .eof: isRunning = false
        }
    }

    mutating func run() {
        while isRunning {
            showMenu()
        }
        print("\nЗавершение работы")
    }
}

guard let array = Main.readArray() else {
    print("\nВвод прерван")
    exit(0)
}

var app = Main(array: array)
app.showArrays()
app.run()
