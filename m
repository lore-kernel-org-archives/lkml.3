Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbbAWOLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:11:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52300 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbAWOKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:10:22 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Yingjoe=20Chen=20=28=E9=99=B3=E8=8B=B1=E6=B4=B2=29?= 
	<Yingjoe.Chen@mediatek.com>,
        Henry Chen <henryc.chen@mediatek.com>,
        =?UTF-8?q?YH=20Chen=20=28=E9=99=B3=E6=98=B1=E8=B1=AA=29?= 
	<yh.chen@mediatek.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/7] dt: bindings: Add MediaTek MT8135/MT8173 reset controller defines
Date: Fri, 23 Jan 2015 15:09:58 +0100
Message-Id: <1422022202-7526-4-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the reset defines for the MT8135/MT8173 pericfg and infracfg
controllers. Needed for device trees to specify the reset numbers in
pericfg / infracfg reset consumers

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 .../dt-bindings/reset-controller/mt8135-resets.h   | 64 ++++++++++++++++++++++
 .../dt-bindings/reset-controller/mt8173-resets.h   | 63 +++++++++++++++++++++
 2 files changed, 127 insertions(+)
 create mode 100644 include/dt-bindings/reset-controller/mt8135-resets.h
 create mode 100644 include/dt-bindings/reset-controller/mt8173-resets.h

diff --git a/include/dt-bindings/reset-controller/mt8135-resets.h b/include/dt-bindings/reset-controller/mt8135-resets.h
new file mode 100644
index 0000000..1fb6295
--- /dev/null
+++ b/include/dt-bindings/reset-controller/mt8135-resets.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu, MediaTek
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_RESET_CONTROLLER_MT8135
+#define _DT_BINDINGS_RESET_CONTROLLER_MT8135
+
+/* INFRACFG resets */
+#define MT8135_INFRA_EMI_REG_RST        0
+#define MT8135_INFRA_DRAMC0_A0_RST      1
+#define MT8135_INFRA_CCIF0_RST          2
+#define MT8135_INFRA_APCIRQ_EINT_RST    3
+#define MT8135_INFRA_APXGPT_RST         4
+#define MT8135_INFRA_SCPSYS_RST         5
+#define MT8135_INFRA_CCIF1_RST          6
+#define MT8135_INFRA_PMIC_WRAP_RST      7
+#define MT8135_INFRA_KP_RST             8
+#define MT8135_INFRA_EMI_RST            32
+#define MT8135_INFRA_DRAMC0_RST         34
+#define MT8135_INFRA_SMI_RST            35
+#define MT8135_INFRA_M4U_RST            36
+
+/*  PERICFG resets */
+#define MT8135_PERI_UART0_SW_RST        0
+#define MT8135_PERI_UART1_SW_RST        1
+#define MT8135_PERI_UART2_SW_RST        2
+#define MT8135_PERI_UART3_SW_RST        3
+#define MT8135_PERI_IRDA_SW_RST         4
+#define MT8135_PERI_PTP_SW_RST          5
+#define MT8135_PERI_AP_HIF_SW_RST       6
+#define MT8135_PERI_GPCU_SW_RST         7
+#define MT8135_PERI_MD_HIF_SW_RST       8
+#define MT8135_PERI_NLI_SW_RST          9
+#define MT8135_PERI_AUXADC_SW_RST       10
+#define MT8135_PERI_DMA_SW_RST          11
+#define MT8135_PERI_NFI_SW_RST          14
+#define MT8135_PERI_PWM_SW_RST          15
+#define MT8135_PERI_THERM_SW_RST        16
+#define MT8135_PERI_MSDC0_SW_RST        17
+#define MT8135_PERI_MSDC1_SW_RST        18
+#define MT8135_PERI_MSDC2_SW_RST        19
+#define MT8135_PERI_MSDC3_SW_RST        20
+#define MT8135_PERI_I2C0_SW_RST         22
+#define MT8135_PERI_I2C1_SW_RST         23
+#define MT8135_PERI_I2C2_SW_RST         24
+#define MT8135_PERI_I2C3_SW_RST         25
+#define MT8135_PERI_I2C4_SW_RST         26
+#define MT8135_PERI_I2C5_SW_RST         27
+#define MT8135_PERI_I2C6_SW_RST         28
+#define MT8135_PERI_USB_SW_RST          29
+#define MT8135_PERI_SPI1_SW_RST         33
+#define MT8135_PERI_PWRAP_BRIDGE_SW_RST 34
+
+#endif  /* _DT_BINDINGS_RESET_CONTROLLER_MT8135 */
diff --git a/include/dt-bindings/reset-controller/mt8173-resets.h b/include/dt-bindings/reset-controller/mt8173-resets.h
new file mode 100644
index 0000000..9464b37
--- /dev/null
+++ b/include/dt-bindings/reset-controller/mt8173-resets.h
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2014 MediaTek Inc.
+ * Author: Flora Fu, MediaTek
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_RESET_CONTROLLER_MT8173
+#define _DT_BINDINGS_RESET_CONTROLLER_MT8173
+
+/* INFRACFG resets */
+#define MT8173_INFRA_EMI_REG_RST        0
+#define MT8173_INFRA_DRAMC0_A0_RST      1
+#define MT8173_INFRA_APCIRQ_EINT_RST    3
+#define MT8173_INFRA_APXGPT_RST         4
+#define MT8173_INFRA_SCPSYS_RST         5
+#define MT8173_INFRA_KP_RST             6
+#define MT8173_INFRA_PMIC_WRAP_RST      7
+#define MT8173_INFRA_MPIP_RST           8
+#define MT8173_INFRA_CEC_RST            9
+#define MT8173_INFRA_EMI_RST            32
+#define MT8173_INFRA_DRAMC0_RST         34
+#define MT8173_INFRA_APMIXEDSYS_RST     35
+#define MT8173_INFRA_MIPI_DSI_RST       36
+#define MT8173_INFRA_TRNG_RST           37
+#define MT8173_INFRA_SYSIRQ_RST         38
+#define MT8173_INFRA_MIPI_CSI_RST       39
+#define MT8173_INFRA_GCE_FAXI_RST       40
+#define MT8173_INFRA_MMIOMMURST         47
+
+
+/*  PERICFG resets */
+#define MT8173_PERI_UART0_SW_RST        0
+#define MT8173_PERI_UART1_SW_RST        1
+#define MT8173_PERI_UART2_SW_RST        2
+#define MT8173_PERI_UART3_SW_RST        3
+#define MT8173_PERI_IRRX_SW_RST         4
+#define MT8173_PERI_PWM_SW_RST          8
+#define MT8173_PERI_AUXADC_SW_RST       10
+#define MT8173_PERI_DMA_SW_RST          11
+#define MT8173_PERI_I2C6_SW_RST         13
+#define MT8173_PERI_NFI_SW_RST          14
+#define MT8173_PERI_THERM_SW_RST        16
+#define MT8173_PERI_MSDC2_SW_RST        17
+#define MT8173_PERI_MSDC3_SW_RST        18
+#define MT8173_PERI_MSDC0_SW_RST        19
+#define MT8173_PERI_MSDC1_SW_RST        20
+#define MT8173_PERI_I2C0_SW_RST         22
+#define MT8173_PERI_I2C1_SW_RST         23
+#define MT8173_PERI_I2C2_SW_RST         24
+#define MT8173_PERI_I2C3_SW_RST         25
+#define MT8173_PERI_I2C4_SW_RST         26
+#define MT8173_PERI_HDMI_SW_RST         29
+#define MT8173_PERI_SPI0_SW_RST         33
+
+#endif  /* _DT_BINDINGS_RESET_CONTROLLER_MT8173 */
-- 
2.1.4

