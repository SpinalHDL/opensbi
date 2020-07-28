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
platform-genflags-y += -I$(LITEX_BUILD)/software/include
platform-genflags-y += -I$(LITEX_INSTALL)/litex/litex/soc/software/include
platform-genflags-y += -I$(LITEX_INSTALL)/litex/litex/soc/cores/cpu/vexriscv_smp

