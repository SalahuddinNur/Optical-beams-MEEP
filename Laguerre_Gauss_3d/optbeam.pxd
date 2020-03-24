# -*- coding: utf-8 -*-
"""
file:    optbeam.pxd
brief:   ...
author:  Daniel Kotik
version: 1.5-beta
release date: xx.xx.2020
creation date: 22.02.2020
"""
cimport cython
from cpython.pycapsule cimport PyCapsule_New
from cpython cimport bool

# declare C functions as "cpdef" to export them to the module
cdef extern from "stdlib.h":
    cpdef int _abs "abs" (int n) nogil

cdef extern from "math.h":
    cpdef double _sin "sin" (double x) nogil
    cpdef double _cos "cos" (double x) nogil
    cpdef double _exp "exp" (double x) nogil

cdef extern from "complex.h":
    cpdef double complex _cexp "cexp" (double complex z) nogil


# function declarations
cdef double _imag_2d_func_c(int n, double *arr, void *func_ptr)
cdef double _real_2d_func_c(int n, double *arr, void *func_ptr)

@cython.locals(real=cython.double, imag=cython.double, real_tol=cython.double,
               imag_tol=cython.double)
cdef (double complex, double, double) _complex_dblquad(Beam3d func,
                                                       double a, double b,
                                                       double gfun, double hfun)

@cython.locals(W_y=cython.double, k=cython.double)
cdef double complex f_Gauss_spherical(double sin_theta, double W_y, double k) nogil

@cython.locals(m=cython.int)
cdef double complex f_Laguerre_Gauss_spherical(double sin_theta, double theta,
                                               double phi, double W_y, double k, int m) nogil

# class declarations
cdef class Beam3d:
    cdef double complex integrand(self, double x, double y) nogil

cdef class PsiSpherical(Beam3d):
    cdef:
        readonly dict params
        int m
        double x, k, W_y
        double ry, rz
        bool called

    cdef double phase(self, double sin_theta, double cos_theta, double phi,
                      double x, double y, double z) nogil
    cdef double complex integrand(self, double theta, double phi) nogil
    cdef double complex f_spectrum(self, double sin_theta, double theta, double phi) nogil