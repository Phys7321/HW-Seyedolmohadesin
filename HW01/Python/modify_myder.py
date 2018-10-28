# -*- coding: utf-8 -*-
"""
Created on Sun Sep  9 16:50:22 2018

@author: Tom K
"""

def higherdiff(f,a,b,N):
    h = (b-a)/N
    g=np.zeros(N)
    for k in range(0,N):
        slop = ((1/24)*f(a+(k-3/2)*h)-(27/24)*f(a+(k-1/2)*h)+(27/24)*f(a+(k+1/2)*h)-(1/24)*f(a+(k+3/2)*h))/h
        g[k]=slop
    return g

def seconddiff(f,a,b,N):
    h = (b-a)/N
    g=np.zeros(N)
    for k in range(0,N):
        slop = (f(a+(k+1)*h)-2*f(a+k*h)+f(a+(k-1)*h))/h**2
        g[k]=slop
    return g

