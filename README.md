## decrunch

decrunch is a Python wrapper around [crunch's](https://github.com/BinomialLLC/crunch) decompressor.

### Setup

```sh
python setup.py install
```

### Usage

```py
import decrunch

buf = open('example.crn', 'rb').read()
fi = decrunch.File(buf)
print("texture info:", fi.info())
open('out.bc1', 'wb').write(fi.decode_level(0))
```

Further image decoding requires a DXTn decompressor, such as the one that
can be found in [Pillow](https://github.com/python-pillow/Pillow) as `bcn`.
