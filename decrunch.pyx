from enum import IntEnum


class Format(IntEnum):
	"""
	Crunch format (what block-compressed texture format this decodes to)
	"""

	Invalid = -1
	DXT1 = 0
	DXT3 = 1
	DXT5 = 2

	# Various DXT5 derivatives
	DXT5_CCxY = 3 # Luma-chroma
	DXT5_xGxR = 4 # Swizzled 2-component
	DXT5_xGBR = 5 # Swizzled 3-component
	DXT5_AGBR = 6 # Swizzled 4-component

	# ATI 3DC and X360 DXN
	DXN_XY = 7
	DXN_YX = 8

	# DXT5 Alpha block only
	DXT5A = 9

	ETC1 = 10
	ETC2 = 11
	ETC2A = 12
	ETC1S = 13
	ETC2AS = 14


cdef extern from "crunch.h":
	ctypedef int crn_format


cdef extern from "crunch.h" namespace "crnd":
	ctypedef unsigned int uint32

	uint32 crnd_crn_format_to_fourcc(crn_format fmt)
	uint32 crnd_get_crn_format_bits_per_texel(crn_format fmt)
	uint32 crnd_get_bytes_per_dxt_block(crn_format fmt)

	struct crn_texture_info:
		uint32      m_struct_size
		uint32      m_width
		uint32      m_height
		uint32      m_levels
		uint32      m_faces
		uint32      m_bytes_per_block
		uint32      m_userdata0
		uint32      m_userdata1
		crn_format  m_format

	int crnd_get_texture_info(const void* pData, uint32 data_size, crn_texture_info* pTexture_info)

	struct crn_level_info:
		uint32      m_struct_size
		uint32      m_width
		uint32      m_height
		uint32      m_faces
		uint32      m_blocks_x
		uint32      m_blocks_y
		uint32      m_bytes_per_block
		crn_format  m_format

	int crnd_get_level_info(const void* pData, uint32 data_size, uint32 level_index, crn_level_info* pLevel_info)

	ctypedef void *crnd_unpack_context
	crnd_unpack_context crnd_unpack_begin(const void* pData, uint32 data_size)
	int crnd_unpack_level(crnd_unpack_context pContext, void** ppDst, uint32 dst_size_in_bytes, uint32 row_pitch_in_bytes, uint32 level_index)
	int crnd_unpack_end(crnd_unpack_context pContext)


cdef class UnpackContext:
	cdef crnd_unpack_context ctx

	def __cinit__(self):
		self.ctx = NULL

	def __dealloc__(self):
		crnd_unpack_end(self.ctx)

	def begin(self, buf):
		self.ctx = crnd_unpack_begin(<unsigned char *>buf, <uint32>len(buf))

	def unpack_level(self, dst, row_pitch_in_bytes, level_index):
		cdef void *ppDst[6]
		ppDst[0] = <unsigned char *>dst
		return crnd_unpack_level(self.ctx, ppDst, <uint32>len(dst), row_pitch_in_bytes, level_index)


class File:
	def __init__(self, buf):
		self.buf = buf
		self.ctx = UnpackContext()
		self.ctx.begin(buf)

	def info(self, level=None):
		if level is not None:
			return self.level_info(level)
		else:
			return self.texture_info()

	def texture_info(self):
		cdef crn_texture_info texture_info
		if crnd_get_texture_info(<unsigned char *>self.buf, <uint32>len(self.buf), &texture_info) == 0:
			return

		return {
			"width": texture_info.m_width,
			"height": texture_info.m_height,
			"levels": texture_info.m_levels,
			"faces": texture_info.m_faces,
			"bytes_per_block": texture_info.m_bytes_per_block,
			"userdata0": texture_info.m_userdata0,
			"userdata1": texture_info.m_userdata1,
			"format": Format(texture_info.m_format),
		}

	def level_info(self, level):
		cdef crn_level_info level_info
		if crnd_get_level_info(<unsigned char *>self.buf, <uint32>len(self.buf), <uint32>int(level), &level_info) == 0:
			return

		return {
			"width": level_info.m_width,
			"height": level_info.m_height,
			"faces": level_info.m_faces,
			"blocks_x": level_info.m_blocks_x,
			"blocks_y": level_info.m_blocks_y,
			"bytes_per_block": level_info.m_bytes_per_block,
			"format": Format(level_info.m_format),
		}

	def decode_level(self, level):
		info = self.level_info(level)
		blocks_x = info["blocks_x"]
		blocks_y = info["blocks_y"]
		bpb = info["bytes_per_block"]
		dst = bytearray(bpb * blocks_x * blocks_y)

		if self.ctx.unpack_level(dst, blocks_x * bpb, level) == 0:
			return

		return dst
