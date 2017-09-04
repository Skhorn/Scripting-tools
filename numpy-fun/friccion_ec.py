#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt

# Parametros de la simulacion
m = 20
Kv = 0.5
g = 9.8

# Condiciones iniciales
xo = 0
vox = 14.14
yo = 200
voy = 14.14
# Variables de movimiento
x = xo
y = yo
vx = vox
vy = voy
t = 0
dt = 0.01

# Variables vectores para guardar coordenadas
xi = [x]
yi = [y]
ti = [t]
while(y >= 0):
    if(y < 150):
        Kv = 0.1
    xn = x + dt * vx
    vxn = vx + dt * (-Kv/m*vx)
    yn = y + dt * vy
    vyn = vy + dt * (-Kv/m*vy-g)
    t = t + dt
    x = xn
    y = yn
    vx = vxn
    vy = vyn
    ti.append(t)
    xi.append(x)
    yi.append(y)

plt.figure(1)
plt.plot(xi, yi, '-k')
plt.show()

