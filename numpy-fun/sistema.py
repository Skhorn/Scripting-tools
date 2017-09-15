#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt

class Masa:

    def __init__(self, Kv=0.5, m=1, tipo='movil', r0=np.array([0,0]), v0=np.array([0,0]), sist=0):

        self.sist = sist
        self.Kv = Kv # Coeficiente del viente
        self.m = m # Masa del objeto
        # Si es movil o fija, si esta fija no tiene movimiento
        self.tipo = tipo
        self.r0 = r0 #
        self.v0 = v0 # Velocidad
        self.r = r0 #
        self.v = v0 #
        self.ri = [r0]
        self.F = np.array([0,0])
        self.dR = np.array([0,0])
        self.dV = np.array([0,0])

    def calcularFuerza(self):

        self.F = -self.Kv + self.v + self.m * self.sist.g

    def calcularDerivadas(self):

        self.dR = self.v
        self.dV = self.F/self.m

    def mover(self):
        if(self.tipo == "movil"):
            self.r = self.r + self.sist.dt * self.dR
            self.v = self.v + self.sist.dt * self.dV
            self.ri.append(self.r)

    def graficar(self):

        x = []
        y = []
        for i in range(len(self.ri)):
            x.append(self.ri[i][0])
            y.append(self.ri[i][1])
        plt.plot(x,y,'.k-')


class Resorte:

    def __init__(self, Kr = 100, Lo = 1, m1 = 0, m2 = 0):

        self.Kr = Kr
        self.Lo = Lo
        self.m1 = m1
        self.m2 = m2


    def calcularFuerza(self):
        d = np.linalg.norm(self.m1.r - self.m2.r)
        F = self.Kr * (d - self.Lo) * (self.m2.r - self.m1.r)/d
        self.m1.F = self.m1.F + F
        self.m2.F = self.m2.F - F


class Sistema:


    def __init__(self, g = np.array([0, -9.8]), dt = 0.01):

        self.g = g
        self.dt = dt
        self.t = 0
        self.ti = [0]
        self.masas = []
        self.resortes = []

    def calcularFuerzas(self):

        for i in range(len(self.masas)):
            self.masas[i].calcularFuerza()
        for i in range(len(self.resortes)):
            self.resortes[i].calcularFuerza()


    def calcularDerivadas(self):

        for i in range(len(self.masas)):
            self.masas[i].calcularDerivadas()

    def mover(self):

        for i in range(len(self.masas)):
            self.masas[i].mover()


    def graficar(self):

        plt.figure(1)
        for i in range(len(self.masas)):
            self.masas[i].graficar()
        plt.show()


sist = Sistema()
ma = Masa(m = 500, r0 = np.array([10,0]), sist=sist)
sist.masas.append(ma)
mb = Masa(m = 825, r0 = np.array([10,-2]), sist=sist)
sist.masas.append(mb)
mc = Masa(m = 5780, tipo = 'fija', r0 = np.array([0,0]), sist=sist)
sist.masas.append(mc)

r1 = Resorte(Kr = 1000, Lo = 10, m1 = mc, m2 = ma)
sist.resortes.append(r1)
r2 = Resorte(Kr = 500, Lo = 2, m1 = ma, m2 = mb)
sist.resortes.append(r2)

for i in range(500):
    sist.calcularFuerzas()
    sist.calcularDerivadas()
    sist.mover()

sist.graficar()
