#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt
import random

# Parametros de la simulacion
m = 100
Kv = 5
Kr = 50
g = 9.8
Lo = 30

# Condiciones iniciales
xo = 0
vox = 5
yo = 40
voy = 0

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
while( t < 10 ):
    #wind_variation = lambda Kv, yo: Kv*random.random() if yo < 35 else Kv*random.randint(1,5)
    #Kv = wind_variation(Kv, yo)
    #print Kv, yo
    L = np.sqrt(x**2+(70-y)**2)
    xn = x + dt * vx
    vxn = vx + dt * (-Kr*(L-Lo)*x/(m*L)-Kv/m*vx)
    yn = y + dt * vy
    vyn = vy + dt * (Kr*(L-Lo)*(70-y)/(m*L)-Kv/m*vy-g)
    t = t + dt

    hit_the_wall = lambda vxn, xn : np.abs(vxn) * 0.5 if xn < 0 else vxn
    vxn = hit_the_wall(vxn, xn)

    # Almacenando los valores
    x = xn
    y = yn
    vx = vxn
    vy = vyn


    ti.append(t)
    xi.append(x)
    yi.append(y)

plt.figure(1)
plt.plot(xi ,yi, '-k')
xm=[-40,0,0,40,40]
ym=[40,40,0,0,-10]
plt.plot(xm, ym, '-b')
plt.xlabel("X")
plt.ylabel("Y")

plt.figure(2)
plt.plot(ti, xi, '-r')
plt.figure(3)
plt.plot(ti, yi, '-r')
plt.show()

