#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

ext = Extension(
	"decrunch",
	["decrunch.pyx"],
	language="c++",
)

setup(ext_modules=cythonize([ext]))
