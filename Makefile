export THEOS = $(HOME)/theos

ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TiktokCleaner
TiktokCleaner_FILES = TiktokCleaner.xm
TiktokCleaner_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
