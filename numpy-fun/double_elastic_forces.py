#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt
import random

# Parametros de la simulacion
m1 = 75
m2 = 52
Kv = 5
Kr = 1000
g = 9.8
Lo1 = 10
Lo2 = 2
h = 40

# Condiciones iniciales
xo = 10
vox = 0
yo = 40
voy = 0

xo2 = 10
vox2 = vox
yo2 = h-Lo2
voy2 = voy
# Variables de movimiento
x = xo
y = yo
vx = vox
vy = voy

x2 = xo2
y2 = yo2
vx2 = vox2
vy2 = voy2

t = 0
dt = 0.01

# Variables vectores para guardar coordenadas
xi = [x]
yi = [y]
ti = [t]
xi2 = [x2]
yi2 = [y2]

while( t < 10 ):
    L = np.sqrt(x**2+(h-y)**2)
    xn = x + dt * vx
    vxn = vx + dt * (-Kr*(L-Lo1)*x/(m1*L)-Kv/m1*vx)
    yn = y + dt * vy
    vyn = vy + dt * (Kr*(L-Lo1)*(h-y)/(m1*L)-Kv/m1*vy-g)

    # Almacenando los valores
    x = xn
    y = yn
    vx = vxn
    vy = vyn

    L2 = np.sqrt((x-x2)**2+(y-y2)**2)
    xn2 = x2 + dt * vx2
    vxn2 = vx2 + dt * (-Kr*(L2-Lo2)*x2/(m2*L2)-Kv/m2*vx2)
    yn2 = y2 + dt * vy2
    vyn2 = vy2 + dt * (Kr*(L2-Lo2)*(y-y2)/(m2*L2)-Kv/m2*vy2-g)

    x2 = xn2
    y2 = yn2
    vx2 = vxn2
    vy2 = vyn2

    t = t + dt

    ti.append(t)
    xi.append(x)
    yi.append(y)
    xi2.append(x2)
    yi2.append(y2)

plt.figure(1)
plt.plot(xi ,yi, '-k')
plt.plot(xi2, yi2, '-g')
xm=[-20,0 ,0,-20,40,40 ,40,0,0 ,10,10]
ym=[ 40,40,0,0  ,0 ,-10,0,0,40,40,38]
plt.plot(xm, ym, '-b')
plt.xlabel("X")
plt.ylabel("Y")

#plt.figure(2)
#plt.plot(ti, xi, '-r')
#plt.figure(3)
#plt.plot(ti, yi, '-r')
plt.show()

