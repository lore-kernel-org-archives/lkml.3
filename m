Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab3FFM1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:27:34 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:49895 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3FFMRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:17:34 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/33] mfd: dbx500-prcmu: Provide PRCMU numerical clock identifiers
Date: Thu,  6 Jun 2013 13:16:49 +0100
Message-Id: <1370521041-32318-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These will we used to request DBx500 PRCMU clocks from Device Tree. The
numbers used are taken directly from the Hardware Specification document.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/dt-bindings/mfd/dbx500-prcmu.h |   71 ++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100644 include/dt-bindings/mfd/dbx500-prcmu.h

diff --git a/include/dt-bindings/mfd/dbx500-prcmu.h b/include/dt-bindings/mfd/dbx500-prcmu.h
new file mode 100644
index 0000000..e646664
--- /dev/null
+++ b/include/dt-bindings/mfd/dbx500-prcmu.h
@@ -0,0 +1,71 @@
+/*
+ * This header provides constants for the PRCMU bindings.
+ *
+ */
+
+#ifndef _DT_BINDINGS_MFD_PRCMU_H
+#define _DT_BINDINGS_MFD_PRCMU_H
+
+/*
+ * Clock identifiers.
+ */
+
+#define ARMCLK			0
+#define PRCMU_ACLK		1
+#define PRCMU_SVAMMCSPCLK 	2
+#define PRCMU_SIACLK 		3
+#define PRCMU_SGACLK 		4
+#define PRCMU_UARTCLK 		5
+#define PRCMU_MSP02CLK 		6
+#define PRCMU_MSP1CLK 		7
+#define PRCMU_I2CCLK 		8
+#define PRCMU_SDMMCCLK 		9
+#define PRCMU_SLIMCLK 		10
+#define PRCMU_PER1CLK 		11
+#define PRCMU_PER2CLK 		12
+#define PRCMU_PER3CLK 		13
+#define PRCMU_PER5CLK 		14
+#define PRCMU_PER6CLK 		15
+#define PRCMU_PER7CLK 		16
+#define PRCMU_LCDCLK 		17
+#define PRCMU_BMLCLK 		18
+#define PRCMU_HSITXCLK 		19
+#define PRCMU_HSIRXCLK 		20
+#define PRCMU_HDMICLK		21
+#define PRCMU_APEATCLK 		22
+#define PRCMU_APETRACECLK 	23
+#define PRCMU_MCDECLK  	 	24
+#define PRCMU_IPI2CCLK  	25
+#define PRCMU_DSIALTCLK  	26
+#define PRCMU_DMACLK  	 	27
+#define PRCMU_B2R2CLK  	 	28
+#define PRCMU_TVCLK  	 	29
+#define SPARE_UNIPROCLK  	30
+#define PRCMU_SSPCLK  	 	31
+#define PRCMU_RNGCLK  	 	32
+#define PRCMU_UICCCLK  	 	33
+#define SPARE1CLK  	 	34
+#define SPARE2CLK  	 	35
+
+#define PRCMU_NUM_REG_CLOCKS  	39
+
+#define PRCMU_RTCCLK  	 	PRCMU_NUM_REG_CLOCKS
+#define PRCMU_SYSCLK  	 	40
+#define PRCMU_CDCLK  	 	41
+#define PRCMU_TIMCLK  	 	42
+#define PRCMU_PLLSOC0  	 	43
+#define PRCMU_PLLSOC1  	 	44
+#define PRCMU_ARMSS  	 	45
+#define PRCMU_PLLDDR  	 	46
+
+/* DSI Clocks */
+#define PRCMU_PLLDSI  	 	47
+#define PRCMU_DSI0CLK 	  	48
+#define PRCMU_DSI1CLK  	 	49
+#define PRCMU_DSI0ESCCLK  	50
+#define PRCMU_DSI1ESCCLK  	51
+#define PRCMU_DSI2ESCCLK  	52
+
+#define PRCMU_NUM_CLKS  	53
+
+#endif
-- 
1.7.10.4

