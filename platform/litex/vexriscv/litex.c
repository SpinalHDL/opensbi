/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2019 Western Digital Corporation or its affiliates.
 *
 * Authors:
 *   Anup Patel <anup.patel@wdc.com>
 *   Nick Kossifidis <mick@ics.forth.gr>
 */


#include <generated/csr.h>
#include <base/uart.h>


void vex_putc(char c){
	while (uart_txfull_read());
	uart_rxtx_write(c);
	uart_ev_pending_write(UART_EV_TX);
}

int vex_getc(void){
	char c = 0;
	if (uart_rxempty_read()) return -1;
	c = uart_rxtx_read();
	uart_ev_pending_write(UART_EV_RX);
	return c;
}
