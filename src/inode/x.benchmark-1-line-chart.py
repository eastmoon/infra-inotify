import os.path
import numpy as np
import matplotlib.pyplot as plt
import csv

# Read data from csv file
sample_data = []
with open("/data/benchmark.1", 'r') as x:
    reader = csv.reader(x, delimiter=",")
    for row in reader:
        row = list(map(lambda x: int(x), row))
        sample_data.append(row)

# Retrieve data for y axis
ypoints = np.array([row[4]/1000000000 for row in sample_data])
# Draw
plt.plot(ypoints)
# Save image
plt.savefig(os.path.join('/data', 'benchmark.1.png'))
