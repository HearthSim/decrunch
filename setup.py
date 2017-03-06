#!/usr/bin/env python

from setuptools import setup
from setuptools.extension import Extension
from Cython.Build import cythonize


ext = Extension(
	"decrunch",
	["decrunch.pyx"],
	language="c++",
)

setup(ext_modules=cythonize([ext]))
