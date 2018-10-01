# decrunch
[![Build Status](https://api.travis-ci.org/HearthSim/decrunch.svg?branch=master)](https://travis-ci.org/HearthSim/decrunch)

decrunch is a Python wrapper around [crunch's](https://github.com/BinomialLLC/crunch) decompressor.


## Setup

- To install directly from PyPI: `pip install decrunch`
- To install from source: `pip install Cython`, then `./setup.py install`


## Usage

```py
import decrunch

with open("example.crn", "rb") as f:
	buf = f.read()

fi = decrunch.File(buf)
tex_info = fi.info()

for level in range(tex_info["levels"]):
	print("Level info %i: %r" % (level, fi.info(level)))

with open("out.bc1", "wb") as f:
	f.write(fi.decode_level(0))
```

Further image decoding requires a DXTn decompressor, such as the one that
can be found in [Pillow](https://github.com/python-pillow/Pillow) as `bcn`.

## License

The full license text is available in the `LICENSE` file.
See crunch/license.txt for the license of files in the `crunch/` subdirectory.

The files in `crunch/` are an unaltered subset of the original code; the
entirety of crunch may be obtained at <https://github.com/BinomialLLC/crunch>.
