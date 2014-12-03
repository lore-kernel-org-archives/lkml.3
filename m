Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaLCVds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:33:48 -0500
Received: from blu004-omc1s21.hotmail.com ([65.55.116.32]:53581 "EHLO
	BLU004-OMC1S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbaLCVdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:33:46 -0500
X-TMN: [PN3gQqYE+aVAfckKTDq55lGxEah220vu]
X-Originating-Email: [seancleator@hotmail.co.uk]
Message-ID: <BLU437-SMTP3735424C7098C20996EFF8E97B0@phx.gbl>
From: Sean Cleator <seancleator@hotmail.co.uk>
To: lidza.louina@gmail.com, markh@compro.net
CC: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sean Cleator <seancleator@hotmail.co.uk>
Subject: [PATCH v2] Staging: dgnc: Fix long line coding style issues in dgnc_cls.h
Date: Wed, 3 Dec 2014 21:30:17 +0000
X-Mailer: git-send-email 2.1.3
X-OriginalArrivalTime: 03 Dec 2014 21:33:44.0296 (UTC) FILETIME=[D06E5680:01D00F40]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A patch to fix the rest of the long line warnings in the dgnc_cls.h file
found by the checkpatch.pl tool

Signed-off-by: Sean Cleator <seancleator@hotmail.co.uk>
---
 drivers/staging/dgnc/dgnc_cls.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.h b/drivers/staging/dgnc/dgnc_cls.h
index 465d79a..ee7814b 100644
--- a/drivers/staging/dgnc/dgnc_cls.h
+++ b/drivers/staging/dgnc/dgnc_cls.h
@@ -36,9 +36,12 @@
  ************************************************************************/
 
 struct cls_uart_struct {
-	u8 txrx;		/* WR  RHR/THR - Holding Reg */
+	u8 txrx;	/* WR  RHR/THR - Holding Reg */
 	u8 ier;		/* WR  IER - Interrupt Enable Reg */
-	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg */
+	u8 isr_fcr;	/*
+			 * WR  ISR/FCR - Interrupt Status Reg/Fifo
+			 * Control Reg
+			 */
 	u8 lcr;		/* WR  LCR - Line Control Reg */
 	u8 mcr;		/* WR  MCR - Modem Control Reg */
 	u8 lsr;		/* WR  LSR - Line Status Reg */
@@ -61,8 +64,9 @@ struct cls_uart_struct {
 #define UART_16654_FCR_RXTRIGGER_56	0x80
 #define UART_16654_FCR_RXTRIGGER_60     0xC0
 
-#define UART_IIR_CTSRTS			0x20	/* Received CTS/RTS change of state */
-#define UART_IIR_RDI_TIMEOUT		0x0C    /* Receiver data TIMEOUT */
+/* Received CTS/RTS change of state */
+#define UART_IIR_CTSRTS			0x20
+#define UART_IIR_RDI_TIMEOUT		0x0C	/* Receiver data TIMEOUT */
 
 /*
  * These are the EXTENDED definitions for the Exar 654's Interrupt
@@ -74,8 +78,10 @@ struct cls_uart_struct {
 #define UART_EXAR654_EFR_RTSDTR   0x40    /* Auto RTS/DTR Flow Control Enable */
 #define UART_EXAR654_EFR_CTSDSR   0x80    /* Auto CTS/DSR Flow COntrol Enable */
 
-#define UART_EXAR654_XOFF_DETECT  0x1     /* Indicates whether chip saw an incoming XOFF char  */
-#define UART_EXAR654_XON_DETECT   0x2     /* Indicates whether chip saw an incoming XON char */
+/* Indicates whether chip saw an incoming XOFF char */
+#define UART_EXAR654_XOFF_DETECT  0x1
+/* Indicates whether chip saw an incoming XON char */
+#define UART_EXAR654_XON_DETECT   0x2
 
 #define UART_EXAR654_IER_XOFF     0x20    /* Xoff Interrupt Enable */
 #define UART_EXAR654_IER_RTSDTR   0x40    /* Output Interrupt Enable */
-- 
2.1.3

