Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaLVB2K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:28:10 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58788 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbaLVB11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:27:27 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] dgnc/dgnc_cls.h: checkpatch: fixed long lines by moving comments
Date: Mon, 22 Dec 2014 02:17:29 +0100
Message-Id: <1419211054-3052-2-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/dgnc_cls.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.h b/drivers/staging/dgnc/dgnc_cls.h
index 465d79a..d1543c1 100644
--- a/drivers/staging/dgnc/dgnc_cls.h
+++ b/drivers/staging/dgnc/dgnc_cls.h
@@ -36,9 +36,9 @@
  ************************************************************************/
 
 struct cls_uart_struct {
-	u8 txrx;		/* WR  RHR/THR - Holding Reg */
+	u8 txrx;	/* WR  RHR/THR - Holding Reg */
 	u8 ier;		/* WR  IER - Interrupt Enable Reg */
-	u8 isr_fcr;		/* WR  ISR/FCR - Interrupt Status Reg/Fifo Control Reg */
+	u8 isr_fcr;	/* WR  ISR/FCR - Interrupt Status Reg/Fifo ControlReg*/
 	u8 lcr;		/* WR  LCR - Line Control Reg */
 	u8 mcr;		/* WR  MCR - Modem Control Reg */
 	u8 lsr;		/* WR  LSR - Line Status Reg */
@@ -61,7 +61,8 @@ struct cls_uart_struct {
 #define UART_16654_FCR_RXTRIGGER_56	0x80
 #define UART_16654_FCR_RXTRIGGER_60     0xC0
 
-#define UART_IIR_CTSRTS			0x20	/* Received CTS/RTS change of state */
+/* Received CTS/RTS change of state */
+#define UART_IIR_CTSRTS			0x20
 #define UART_IIR_RDI_TIMEOUT		0x0C    /* Receiver data TIMEOUT */
 
 /*
@@ -74,8 +75,10 @@ struct cls_uart_struct {
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
1.9.1

