import os.path
import numpy as np
import matplotlib.pyplot as plt
import csv

# Read data from csv file
sample_data = []
with open("/data/benchmark.2", 'r') as x:
    reader = csv.reader(x, delimiter=",")
    for row in reader:
        row = list(map(lambda x: int(x), row))
        sample_data.append(row)

# Retrieve data for y axis
ypoints1 = np.array([row[4]/1000000000 for row in sample_data])
# Draw
plt.plot(ypoints1)
# Save image
plt.savefig(os.path.join('/data', 'benchmark.2-1.png'))
plt.clf()

# Retrieve data for y axis
ypoints2 = np.array([row[5]/1000000000 for row in sample_data])
# Draw
plt.plot(ypoints2)
# Save image
plt.savefig(os.path.join('/data', 'benchmark.2-2.png'))
plt.clf()

# Draw
plt.plot(ypoints1)
plt.plot(ypoints2)
# Save image
plt.savefig(os.path.join('/data', 'benchmark.2.png'))
plt.clf()
