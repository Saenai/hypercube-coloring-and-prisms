#!/usr/bin/env python3
"""Exhaustive checks of prism domination on small labelled simple graphs.

Run with Python 3. Each graph is a tuple of open neighbourhoods. Vertices in
the two layers of the prism are numbered 0,...,n-1 and n,...,2n-1.
"""
from argparse import ArgumentParser
from itertools import combinations, product


def make_graph(order, edges):
    neighbours = [set() for _ in range(order)]
    for u, v in edges:
        neighbours[u].add(v)
        neighbours[v].add(u)
    return tuple(frozenset(row) for row in neighbours)


def subsets(vertices):
    for size in range(len(vertices) + 1):
        for group in combinations(vertices, size):
            yield frozenset(group)


def prism(graph):
    n = len(graph)
    return tuple(
        {w + layer * n for w in graph[v]} | {v + (1 - layer) * n}
        for layer in (0, 1)
        for v in range(n)
    )


def independent(graph, chosen):
    return all(not (graph[v] & chosen) for v in chosen)


def bipartite(graph, chosen):
    colour = {}
    for root in chosen:
        if root in colour:
            continue
        colour[root] = 0
        stack = [root]
        while stack:
            v = stack.pop()
            for w in graph[v] & chosen:
                if w not in colour:
                    colour[w] = 1 - colour[v]
                    stack.append(w)
                elif colour[v] == colour[w]:
                    return False
    return True


def base_parameters(graph):
    vertices = frozenset(range(len(graph)))
    gamma = deletion_min = len(graph)
    alpha = 0
    for chosen in subsets(vertices):
        if independent(graph, chosen):
            alpha = max(alpha, len(chosen))
        outside = vertices - chosen
        if all(graph[v] & chosen for v in outside):
            gamma = min(gamma, len(chosen))
            if bipartite(graph, outside):
                deletion_min = min(deletion_min, len(chosen))
    return gamma, alpha, deletion_min


def smallest_total_dominating_cover(graph):
    vertices = frozenset(range(len(graph)))
    for support in subsets(vertices):  # cardinalities are tried in increasing order
        if independent(graph, vertices - support) and all(
            graph[v] & support for v in vertices
        ):
            return support
    raise AssertionError('No total dominating cover exists in this graph.')


def valid_italian_labels(graph, labels):
    for v, row in enumerate(graph):
        neighbour_values = [labels[w] for w in row]
        if not any(neighbour_values):
            return False
        if labels[v] == 0 and (0 in neighbour_values or sum(neighbour_values) < 2):
            return False
    return True


def italian_by_all_labellings(graph):
    return min(
        sum(labels)
        for labels in product(range(3), repeat=len(graph))
        if valid_italian_labels(graph, labels)
    )


def require(condition, description, graph):
    if not condition:
        raise AssertionError(f'{description} failed for adjacency {graph}')


def check_family(all_labels):
    print(' n   graphs   bipartite   lower-tight   upper-tight   nonbipartite upper-tight')
    grand_totals = [0] * 5
    labelled_assignments = 0
    for n in range(2, 6):
        counts = [0] * 5
        vertices = frozenset(range(n))
        for edges in subsets(tuple(combinations(range(n), 2))):
            graph = make_graph(n, edges)
            if not all(graph):
                continue
            graph_prism = prism(graph)
            support = smallest_total_dominating_cover(graph_prism)
            t = len(support)
            gamma, alpha, deletion_min = base_parameters(graph)
            is_bipartite = bipartite(graph, vertices)
            lower_tight = t == n + gamma
            upper_tight = t == 2 * n - alpha
            require(t == n + deletion_min, 'prism formula', graph)
            require(n + gamma <= t <= 2 * n - alpha, 'Italian bounds', graph)
            require(not is_bipartite or lower_tight, 'bipartite equality', graph)
            require(upper_tight == (gamma == n - alpha), 'upper-bound converse', graph)
            # Every Italian labelling's positive support is a total dominating
            # cover and weighs at least T. A valid weight-T witness proves equality.
            labels = tuple(int(v in support) for v in range(2 * n))
            require(valid_italian_labels(graph_prism, labels), 'Italian witness', graph)
            if all_labels:
                require(italian_by_all_labellings(graph_prism) == t, 'ternary minimum', graph)
                labelled_assignments += 3 ** (2 * n)
            hits = (True, is_bipartite, lower_tight, upper_tight, not is_bipartite and upper_tight)
            counts = [a + b for a, b in zip(counts, hits)]
        require(counts[0] == {2: 1, 3: 4, 4: 41, 5: 768}[n], 'graph count', ())
        print(f'{n:2} {counts[0]:8} {counts[1]:11} {counts[2]:13} {counts[3]:13} {counts[4]:25}')
        grand_totals = [a + b for a, b in zip(grand_totals, counts)]
    print('Total:', *grand_totals)
    if all_labels:
        print('Italian labellings checked on the full family:', labelled_assignments)


def check_examples():
    # The first base has a triangle, with one pendant at each of vertices 0 and 1.
    # The second base has a clique on 0,...,3 and the isolated vertex 4.
    examples = [
        ('triangle with two pendants', [(0, 1), (1, 2), (2, 0), (0, 3), (1, 4)],
         (2, 3, 2, 7, 7)),
        ('K4 disjoint union K1', list(combinations(range(4), 2)), (2, 2, 3, 8, 8)),
    ]
    for name, edges, expected in examples:
        graph = make_graph(5, edges)
        graph_prism = prism(graph)
        gamma, alpha, deletion_min = base_parameters(graph)
        t = len(smallest_total_dominating_cover(graph_prism))
        italian = italian_by_all_labellings(graph_prism)
        require((gamma, alpha, deletion_min, t, italian) == expected, name, graph)
        print(f'{name}: gamma={gamma}, alpha={alpha}, deletion={deletion_min}, '
              f'T={t}, gamma_ctI={italian}, 2n-alpha={10-alpha} '
              f'({3**len(graph_prism)} Italian labellings checked)')


if __name__ == '__main__':
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('--all-labels', action='store_true',
                        help='also enumerate all ternary prism labellings for every base graph')
    check_family(parser.parse_args().all_labels)
    check_examples()
