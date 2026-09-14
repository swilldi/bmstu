// проверка среднего элемента каждый раз

func bin_search_2(_ array: [Int], target: Int) -> Int {
    var l = 0, r = array.count - 1
    while l <= r {
        let m = l + (r - l) / 2
        if array[m] == target {
            return m
        }
        if array[m] < target {
            l = m
        } else {
            r = m
        }
    }

    return -1
}
