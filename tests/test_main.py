"""
Tests for decrunch
"""

import os
from decrunch import File, Format


BASE_DIR = os.path.dirname(os.path.abspath(__file__))


def get_resource(path):
	return os.path.join(BASE_DIR, "res", path)


def test_info_dxt1():
	path = get_resource("dxt1.crn")
	with open(path, "rb") as f:
		cf = File(f.read())

	base_info = {
		"width": 128, "height": 128, "faces": 1,
		"bytes_per_block": 8, "format": Format.DXT1,
	}
	file_info = base_info.copy()
	file_info["levels"] = 8
	file_info["userdata0"] = file_info["userdata1"] = 0
	assert cf.info() == file_info

	info = base_info.copy()
	info["blocks_x"] = info["blocks_y"] = 32
	for level in range(file_info["levels"]):
		assert cf.info(level) == info
		info = info.copy()
		info["blocks_x"] = info["blocks_y"] = max(1, info["blocks_x"] // 2)
		info["width"] = info["height"] = info["width"] // 2


def test_decode_dxt1():
	path = get_resource("dxt1.crn")
	with open(path, "rb") as f:
		cf = File(f.read())

	for level in range(cf.info()["levels"]):
		decoded = cf.decode_level(level)
		decoded_path = get_resource("dxt1-%i.bcn" % (level))
		with open(decoded_path, "rb") as f:
			assert decoded == f.read()
		assert decoded


def test_info_dxt5():
	path = get_resource("dxt5.crn")
	with open(path, "rb") as f:
		cf = File(f.read())

	base_info = {
		"width": 128, "height": 128, "faces": 1,
		"bytes_per_block": 16, "format": Format.DXT5,
	}
	file_info = base_info.copy()
	file_info["levels"] = 8
	file_info["userdata0"] = file_info["userdata1"] = 0
	assert cf.info() == file_info

	info = base_info.copy()
	info["blocks_x"] = info["blocks_y"] = 32
	for level in range(file_info["levels"]):
		assert cf.info(level) == info
		info = info.copy()
		info["blocks_x"] = info["blocks_y"] = max(1, info["blocks_x"] // 2)
		info["width"] = info["height"] = info["width"] // 2


def test_decode_dxt5():
	path = get_resource("dxt5.crn")
	with open(path, "rb") as f:
		cf = File(f.read())

	for level in range(cf.info()["levels"]):
		decoded = cf.decode_level(level)
		decoded_path = get_resource("dxt5-%i.bcn" % (level))
		with open(decoded_path, "rb") as f:
			assert decoded == f.read()
		assert decoded
