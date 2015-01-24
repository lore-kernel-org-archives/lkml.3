Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbbAXFTY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 00:19:24 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58621 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbbAXFTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 00:19:22 -0500
From: Sakshi Bansal <sakshi.april5@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Sakshi Bansal <sakshi.april5@gmail.com>
Subject: [PATCH] Staging: dgnc: dgnc_cls.h: fixed four coding style warnings
Date: Sat, 24 Jan 2015 10:49:08 +0530
Message-Id: <1422076748-5927-1-git-send-email-sakshi.april5@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 80 line warning in the code comments.

Signed-off-by: Sakshi Bansal <sakshi.april5@gmail.com>
---
 drivers/staging/dgnc/dgnc_cls.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.h b/drivers/staging/dgnc/dgnc_cls.h
index 465d79a..7444b00 100644
--- a/drivers/staging/dgnc/dgnc_cls.h
+++ b/drivers/staging/dgnc/dgnc_cls.h
@@ -38,7 +38,8 @@
 struct cls_uart_struct {
 	u8 txrx;		/* WR  RHR/THR - Holding Reg */
 	u8 ier;		/* WR  IER - Interrupt Enable Reg */
-	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg */
+	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo
+				   Control Reg */
 	u8 lcr;		/* WR  LCR - Line Control Reg */
 	u8 mcr;		/* WR  MCR - Modem Control Reg */
 	u8 lsr;		/* WR  LSR - Line Status Reg */
@@ -61,7 +62,8 @@ struct cls_uart_struct {
 #define UART_16654_FCR_RXTRIGGER_56	0x80
 #define UART_16654_FCR_RXTRIGGER_60     0xC0
 
-#define UART_IIR_CTSRTS			0x20	/* Received CTS/RTS change of state */
+#define UART_IIR_CTSRTS			0x20	/* Received CTS/RTS change of
+						   state */
 #define UART_IIR_RDI_TIMEOUT		0x0C    /* Receiver data TIMEOUT */
 
 /*
@@ -74,8 +76,10 @@ struct cls_uart_struct {
 #define UART_EXAR654_EFR_RTSDTR   0x40    /* Auto RTS/DTR Flow Control Enable */
 #define UART_EXAR654_EFR_CTSDSR   0x80    /* Auto CTS/DSR Flow COntrol Enable */
 
-#define UART_EXAR654_XOFF_DETECT  0x1     /* Indicates whether chip saw an incoming XOFF char  */
-#define UART_EXAR654_XON_DETECT   0x2     /* Indicates whether chip saw an incoming XON char */
+#define UART_EXAR654_XOFF_DETECT  0x1     /* Indicates whether chip saw an
+					     incoming XOFF char  */
+#define UART_EXAR654_XON_DETECT   0x2     /* Indicates whether chip saw an
+					     incoming XON char */
 
 #define UART_EXAR654_IER_XOFF     0x20    /* Xoff Interrupt Enable */
 #define UART_EXAR654_IER_RTSDTR   0x40    /* Output Interrupt Enable */
-- 
1.9.1

