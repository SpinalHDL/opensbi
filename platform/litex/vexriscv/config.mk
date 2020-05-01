#
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright (c) 2019 Western Digital Corporation or its affiliates.
#
# Authors:
#   Anup Patel <anup.patel@wdc.com>
#

# Compiler flags
platform-cppflags-y =
platform-cflags-y =
platform-asflags-y =
platform-ldflags-y =

# Command for platform specific "make run"
platform-runcmd = echo Miaouuuuu

PLATFORM_RISCV_XLEN = 32
PLATFORM_RISCV_ABI = ilp32
PLATFORM_RISCV_ISA = rv32ima
PLATFORM_RISCV_CODE_MODEL = medany

# Blobs to build
FW_TEXT_START=0x40F00000
FW_DYNAMIC=y
FW_JUMP=y
FW_JUMP_ADDR=0x40000000
FW_JUMP_FDT_ADDR=0x40EF0000
FW_PAYLOAD=y
FW_PAYLOAD_OFFSET=0x40000000
FW_PAYLOAD_FDT_ADDR=0x40EF0000
