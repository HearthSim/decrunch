#!/usr/bin/env python

from setuptools import setup, Extension

try:
	from Cython.Build import cythonize
except ImportError:
	cythonize = None


extensions = [
	Extension(
		"decrunch",
		[
			"crn_decomp.cpp",
			"decrunch." + ("pyx" if cythonize else "cpp"),
		],
		language="c++", include_dirs=["crunch"],
	)
]
if cythonize:
	extensions = cythonize(extensions)


setup(ext_modules=extensions, name="decrunch")
