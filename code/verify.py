"""Finite certificates for the total dominator coloring note. Run with Python 3.10+."""

from collections import Counter
from itertools import combinations, product


def require(condition, message):
    if not condition:
        raise ValueError(message)


def neighbors(word, dimension):
    return {word ^ (1 << bit) for bit in range(dimension)}


def check_cover(dimension, centers, expected_counts):
    counts = Counter()
    for word in range(1 << dimension):
        ball = {word} | neighbors(word, dimension)
        counts[len(ball & centers)] += 1
    require(counts == expected_counts, f"Q_{dimension} covering multiplicities: {counts}")
    print(f"Q_{dimension} covering code: {len(centers)} centers, {dict(sorted(counts.items()))}")


def length_twelve_code():
    # The four symbols are plain zero, marked zero, 1, and 2 (encoded 0,1,2,3).
    code = {word for word in product((0, 1), repeat=4) if sum(word) % 2 == 0}
    for a, b in product(range(3), repeat=2):
        if (a, b) == (0, 0):
            continue
        ternary = (a, b, (a + b) % 3, (a - b) % 3)
        require(ternary.count(0) == 1, "Wrong ternary weight")
        for mark in (0, 1):
            code.add(tuple(mark if c == 0 else c + 1 for c in ternary))
    require(len(code) == 24, "Wrong quaternary code size")

    quaternary_counts = Counter()
    for word in product(range(4), repeat=4):
        covering = sum(sum(a != b for a, b in zip(word, center)) <= 1 for center in code)
        quaternary_counts[covering] += 1
    require(quaternary_counts == {1: 216, 2: 32, 4: 8}, "Quaternary coverage failed")

    def symbol(block):
        x, y, z = (block >> 2) & 1, (block >> 1) & 1, block & 1
        return ((x ^ z) << 1) | (y ^ z)

    centers = set()
    for word in range(1 << 12):
        symbols = tuple(symbol((word >> (3 * i)) & 7) for i in range(4))
        if symbols in code:
            centers.add(word)
    require(len(centers) == 384, "Wrong binary code size")
    return centers


def check_q5_coloring():
    # Give eight vertices distinct colors; use even/odd colors for the rest.
    singletons = [word for word in range(32) if word >> 2 in (0, 7)]
    classes = [{word} for word in singletons]
    for parity in (0, 1):
        classes.append({word for word in range(32)
                        if word not in singletons and word.bit_count() % 2 == parity})
    require(len(classes) == 10 and all(classes), "Wrong number of colors")
    require(sum(map(len, classes)) == 32 and set.union(*classes) == set(range(32)),
            "The classes must partition all vertices")
    for color in classes:
        for vertex in color:
            hood = neighbors(vertex, 5)
            require(not (hood & color), "Improper coloring")
            require(any(other <= hood for other in classes), "Missing a dominated color class")
    print("Q_5: verified the ten-color construction on all 32 vertices")


def check_q5_lower_bound_data():
    # Each parity side of Q_5 projects onto Q_4, taking open neighborhoods to closed balls.
    words = range(16)
    balls = [{v} | neighbors(v, 4) for v in words]
    totals = []
    for size in range(1, 5):
        count = 0
        for centers in combinations(words, size):
            cover = Counter(v for c in centers for v in balls[c])
            if len(cover) < 16:
                continue
            count += 1
            require(size == 4, "A smaller cover appeared")
            for center in centers:
                private_count = sum(cover[v] == 1 for v in balls[center])
                require(private_count == 3, "Unexpected private neighborhoods")
        totals.append(count)
    require(totals == [0, 0, 0, 40], "Unexpected covering counts")
    print("Q_4: covers of sizes 1-4:", totals, "; each minimum-center private count is 3")


if __name__ == "__main__":
    check_cover(3, {0, 7}, {1: 8})
    check_cover(5, {0, 13, 14, 15, 19, 20, 24}, {1: 24, 2: 6, 3: 2})
    check_cover(6, {0, 3, 13, 17, 22, 26, 37, 41, 46, 50, 60, 63},
                {1: 48, 2: 12, 3: 4})
    check_cover(12, length_twelve_code(), {1: 3456, 2: 512, 4: 128})
    check_q5_coloring()
    check_q5_lower_bound_data()
