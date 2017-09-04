#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt

# Solucion analitica
dt = 0.5
t = np.arange(0.0, 5.0, dt)
N = 2 * np.exp(1.01 * t)
plt.figure(1)
plt.plot(t, N, '-k')

# Solucion numerica
t = 0
N = 2
dt = 0.5
ti = [t]
Ni = [N]
while(t <= 50):
    N = N + dt * 1.01 * N
    t = t + dt
    Ni.append(N)
    ti.append(t)
plt.plot(ti, Ni, 'x-r')
plt.show()
