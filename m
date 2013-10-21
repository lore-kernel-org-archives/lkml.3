Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3JUITT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:19:19 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36000 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752614Ab3JUITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:19:17 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] serial: sirf: remove duplicate defines
Date: Mon, 21 Oct 2013 10:19:14 +0200
Message-Id: <1382343554-3320-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes duplicate defines in drivers/tty/serial/sirfsoc_uart.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/tty/serial/sirfsoc_uart.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/tty/serial/sirfsoc_uart.h b/drivers/tty/serial/sirfsoc_uart.h
index fb8d0a0..b7d679c 100644
--- a/drivers/tty/serial/sirfsoc_uart.h
+++ b/drivers/tty/serial/sirfsoc_uart.h
@@ -368,15 +368,6 @@ struct sirfsoc_uart_register sirfsoc_uart = {
 #define SIRFSOC_UART_NR				6
 #define SIRFSOC_PORT_TYPE			0xa5
 
-/* Baud Rate Calculation */
-#define SIRF_MIN_SAMPLE_DIV			0xf
-#define SIRF_MAX_SAMPLE_DIV			0x3f
-#define SIRF_IOCLK_DIV_MAX			0xffff
-#define SIRF_SAMPLE_DIV_SHIFT			16
-#define SIRF_IOCLK_DIV_MASK			0xffff
-#define SIRF_SAMPLE_DIV_MASK			0x3f0000
-#define SIRF_BAUD_RATE_SUPPORT_NR		18
-
 /* Uart Common Use Macro*/
 #define SIRFSOC_RX_DMA_BUF_SIZE	256
 #define BYTES_TO_ALIGN(dma_addr)	((unsigned long)(dma_addr) & 0x3)
@@ -453,9 +444,6 @@ struct sirfsoc_uart_port {
 	int				rx_issued;
 };
 
-/* Hardware Flow Control */
-#define SIRFUART_AFC_CTRL_RX_THD	0x70
-
 /* Register Access Control */
 #define portaddr(port, reg)		((port)->membase + (reg))
 #define rd_regb(port, reg)		(__raw_readb(portaddr(port, reg)))
-- 
1.8.1.2

