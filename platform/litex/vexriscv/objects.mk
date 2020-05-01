#
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright (c) 2019 Western Digital Corporation or its affiliates.
#
# Authors:
#   Anup Patel <anup.patel@wdc.com>
#

platform-objs-y += platform.o
platform-objs-y += litex.o
platform-genflags-y += -I$(LITEX_INCLUDE)
platform-genflags-y += -I$(LITEX_INSTALL)/litex/soc/software/include

