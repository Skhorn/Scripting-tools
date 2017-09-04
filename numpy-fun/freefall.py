#!/usr/bin/python

from pylab import *

g = 9.8     # We are on Earth.
dt = 0.1    # 1/10 second time step
N = 100     # I'd like to see 100 points in the answer array
vi = 50.0    # initial velocity
xi = 25.0    # initial position

# first, set up variables and almost-empty arrays to hold our answers:
t = 0
x = xi
v = vi
time = array([0])       # initial value of time is zero!
height = array([xi])    # initial height is xi
velocity = array([vi])  # initial velocity is vi
# Note that 't', 'x' and 'v' are the current time, position and velocity, but
# 'time', 'height' and 'velocity' are arrays that will contain all the positions
# and velocities at all values of 'time'.

# Now let's use Euler's method to find the position and velocity.
for j in range(N):
    # here are the calculations:
    t = t + dt
    x = x + v * dt
    v = v - g * dt
    # And here we put those calculations in the arrays to plot later:
    time = append(time,t)
    height = append(height,x)
    velocity = append(velocity,v)

# Now that the calculations are done, plot the position:
plot(time, height, 'ro')
xlabel("Time (s)")
ylabel("Height (m)")

# just for comparison, I'll also plot the known solution!
plot(time, xi + vi*time - 0.5*g*time**2, 'b-')
show()
