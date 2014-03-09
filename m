Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaCIGnF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 01:43:05 -0500
Received: from nm11-vm3.bullet.mail.gq1.yahoo.com ([98.136.218.158]:44163 "EHLO
	nm11-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbaCIGnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 01:43:03 -0500
X-Yahoo-Newman-Id: 397629.78155.bm@smtp224.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7Kceo.cVM1n_U60PDGOLDwTqCJ_qYGXjUI2WNhObpXkdA7Y
 cyetgnrcdFLql2tDXJJbuXZmmuG2Onouy_eR9QpXeWRIMhkzljHnHJQhUtfp
 Egr1v76wtEoeDJTHFbLQ2O1Abvrvd0zFCm1pDtaUQINkWZV1F4oQxZ5qaDXN
 FfS55cvNcAgBafYCc7JqmgmQNmLLALv5c8.iaNcvM0GMRvw8Wed3qWNAV50N
 v9kDhtU.vLsROhXMh6jfKe7.lj_vXV7QteFKEG8SPyobmngxfz.cuYr17wJ.
 vTyV6ryFTRU_0GAh2v6HCoq4intx7bQb2VT1nmAzM0y_mfuvxqmDzzbdrJzT
 xiLuQ4QOgT59jEzelpKoU76S57UX8HX3OVYZefrq50U6.f0x8TqA.t5SGDSh
 X6Lk0P2q9ta8saX_m2r4WxlKw5lU4i5y2IesnXCp2UfFaOHypJi.bNJdzHM1
 sIzhuaUPyTYf5Grg4460FgphRMVyJoImXob7AYXFeiWEAc0GdM.mlgTzCpX8
 KUzRtykn4CW0O9aiNx93TPISIRd8uz91w0Mo9dw--
X-Yahoo-SMTP: Ua.BYCGswBCLcNpMqiQEtkMTjL08M6XQy5ZdmA--
X-Rocket-Received: from localhost.localdomain (chase.southwood@50.129.102.163 with plain [63.250.193.228])
        by smtp224.mail.gq1.yahoo.com with SMTP; 09 Mar 2014 06:43:02 +0000 UTC
From: Chase Southwood <chase.southwood@yahoo.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@yahoo.com>
Subject: [PATCH] Staging: comedi: addi-data: style cleanups in hwdrv_apci1564.c
Date: Sun,  9 Mar 2014 00:42:47 -0600
Message-Id: <1394347367-1064-1-git-send-email-chase.southwood@yahoo.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up a few trivial style issues, including fixing crazy
indentation problems in the defines near the top of the file, removing a
couple of unneeded braces, and wrapping a couple of long comments onto new
lines to fix lines which were in excess of 80 characters.

Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
---
Despite apply testing all of the patches in my series which cleaned
up all of these defines, and triple checking my tab space settings to
ensure they were correct, somehow after the set was merged, the
indentation STILL ended up messy.  This patch takes care of that
as well as a couple of other trivial style issues, and this will
serve as my last trivial cleanup patch for this file.  After this
I think that this is clean enough to start the more significant
work of trying to move this code out to addi_apci_1564.c

 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 54 +++++++++++-----------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index a31e115..28eaf34 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -72,30 +72,30 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
 /*
  * devpriv->i_IobaseAmcc Register Map
  */
-#define APCI1564_DI_REG						0x04
-#define APCI1564_DI_INT_MODE1_REG				0x08
-#define APCI1564_DI_INT_MODE2_REG				0x0c
-#define APCI1564_DI_INT_STATUS_REG				0x10
-#define APCI1564_DI_IRQ_REG					0x14
-#define APCI1564_DO_REG						0x18
-#define APCI1564_DO_INT_CTRL_REG				0x1c
-#define APCI1564_DO_INT_STATUS_REG				0x20
-#define APCI1564_DO_IRQ_REG					0x24
-#define APCI1564_WDOG_REG						0x28
-#define APCI1564_WDOG_RELOAD_REG				0x2c
-#define APCI1564_WDOG_TIMEBASE_REG				0x30
-#define APCI1564_WDOG_CTRL_REG					0x34
-#define APCI1564_WDOG_STATUS_REG				0x38
-#define APCI1564_WDOG_IRQ_REG					0x3c
+#define APCI1564_DI_REG					0x04
+#define APCI1564_DI_INT_MODE1_REG			0x08
+#define APCI1564_DI_INT_MODE2_REG			0x0c
+#define APCI1564_DI_INT_STATUS_REG			0x10
+#define APCI1564_DI_IRQ_REG				0x14
+#define APCI1564_DO_REG					0x18
+#define APCI1564_DO_INT_CTRL_REG			0x1c
+#define APCI1564_DO_INT_STATUS_REG			0x20
+#define APCI1564_DO_IRQ_REG				0x24
+#define APCI1564_WDOG_REG				0x28
+#define APCI1564_WDOG_RELOAD_REG			0x2c
+#define APCI1564_WDOG_TIMEBASE_REG			0x30
+#define APCI1564_WDOG_CTRL_REG				0x34
+#define APCI1564_WDOG_STATUS_REG			0x38
+#define APCI1564_WDOG_IRQ_REG				0x3c
 #define APCI1564_WDOG_WARN_TIMEVAL_REG			0x40
-#define APCI1564_WDOG_WARN_TIMEBASE_REG		0x44
-#define APCI1564_TIMER_REG						0x48
-#define APCI1564_TIMER_RELOAD_REG				0x4c
+#define APCI1564_WDOG_WARN_TIMEBASE_REG			0x44
+#define APCI1564_TIMER_REG				0x48
+#define APCI1564_TIMER_RELOAD_REG			0x4c
 #define APCI1564_TIMER_TIMEBASE_REG			0x50
 #define APCI1564_TIMER_CTRL_REG				0x54
-#define APCI1564_TIMER_STATUS_REG				0x58
-#define APCI1564_TIMER_IRQ_REG					0x5c
-#define APCI1564_TIMER_WARN_TIMEVAL_REG		0x60
+#define APCI1564_TIMER_STATUS_REG			0x58
+#define APCI1564_TIMER_IRQ_REG				0x5c
+#define APCI1564_TIMER_WARN_TIMEVAL_REG			0x60
 #define APCI1564_TIMER_WARN_TIMEBASE_REG		0x64
 
 /*
@@ -156,11 +156,10 @@ static int i_APCI1564_ConfigDigitalInput(struct comedi_device *dev,
 		data[3] = data[3] << 4;
 		outl(data[2], devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
 		outl(data[3], devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
-		if (data[1] == ADDIDATA_OR) {
+		if (data[1] == ADDIDATA_OR)
 			outl(0x4, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-		} else {
+		else
 			outl(0x6, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
-		}
 	} else {
 		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE1_REG);
 		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DI_INT_MODE2_REG);
@@ -611,14 +610,17 @@ static void v_APCI1564_Interrupt(int irq, void *d)
 		ui_InterruptStatus_1564 =
 			inl(devpriv->i_IobaseAmcc + APCI1564_DI_INT_STATUS_REG);
 		ui_InterruptStatus_1564 = ui_InterruptStatus_1564 & 0X000FFFF0;
-		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
+		/* send signal to the sample */
+		send_sig(SIGIO, devpriv->tsk_Current, 0);
 		/* enable the interrupt */
 		outl(ui_DI, devpriv->i_IobaseAmcc + APCI1564_DI_IRQ_REG);
 		return;
 	}
 
 	if (ui_DO == 1) {
-		/*  Check for Digital Output interrupt Type - 1: Vcc interrupt 2: CC interrupt. */
+		/* Check for Digital Output interrupt Type */
+		/* 1: VCC interrupt			   */
+		/* 2: CC interrupt			   */
 		ui_Type = inl(devpriv->i_IobaseAmcc + APCI1564_DO_INT_STATUS_REG) & 0x3;
 		/* Disable the  Interrupt */
 		outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DO_INT_CTRL_REG);
-- 
1.8.5.3

