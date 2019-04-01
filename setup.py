#!/usr/bin/env python

from setuptools import Extension, setup

try:
	from Cython.Build import cythonize
except ImportError:
	cythonize = None


extensions = [
	Extension(
		"decrunch",
		["crn_decomp.cpp", "decrunch." + ("pyx" if cythonize else "cpp")],
		language="c++",
		include_dirs=["crunch"],
		extra_compile_args=["-std=c++11"],
	)
]
if cythonize:
	extensions = cythonize(extensions)


setup(ext_modules=extensions)
