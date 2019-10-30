import numpy as np


demand = np.array([8, 15, 18, 10, 12, 16, 6, 4])

shift_names = ["M1", "D1", "D2", "N1", "N2"]
start_period = np.array([1, 3, 4, 7, 8]) - 1
shift_duration = np.array([4, 4, 4, 3, 4])
n_shifts = 5

coverage = np.array([4, 4, 4, 3, 4])


def calc_coverage(period, duration, demand):
    coverage = np.zeros(period.shape[0])

    for i in range(period.shape[0]):
        dist = period[i]
        dur = duration[i]
        slots = np.take(demand, np.arange(dist, dist + dur), mode="wrap")
        coverage[i] = (slots > 0).sum()

    return coverage.astype(np.int)


def update_demand(period, duration, demand, coverage):
    i = coverage.argmax()
    indices = np.arange(demand.shape[0])

    shift_names = ["M1", "D1", "D2", "N1", "N2"]
    print(shift_names[i])

    indices = np.take(
        indices, np.arange(period[i], period[i] + duration[i]), mode="wrap"
    )

    demand[indices] -= 1
    demand[demand < 1] = 0

    return demand, i


res = np.zeros(start_period.shape[0], dtype=np.int)

while coverage.max() > 0:
    demand, i = update_demand(start_period, shift_duration, demand, coverage)
    coverage = calc_coverage(start_period, shift_duration, demand)
    res[i] += 1

