#!/usr/bin/env python

import decrunch

buf = open('example.crn', 'rb').read()
fi = decrunch.File(buf)
tex_info = fi.info()
print("texture info: ", tex_info)
for level in range(tex_info['levels']):
	print("level info %d: %r" % (level, fi.info(level)))
open('out.bc1', 'wb').write(fi.decode_level(0))
