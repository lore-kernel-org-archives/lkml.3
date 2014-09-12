Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbaILLpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:45:54 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:44081 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752759AbaILLpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:45:52 -0400
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: mturquette@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <10da94e412ea159179b1a56d74937756>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Mark yao <mark.yao@rock-chips.com>
To: Mike Turquette <mturquette@linaro.org>, heiko@sntech.de,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        djkurtz@chromium.org, dianders@chromium.org, dkl@rock-chips.com,
        eddie.cai@rock-chips.com, xjq@rock-chips.com, kfx@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yxj@rock-chips.com,
        cym@rock-chips.com, zhengsq@rock-chips.com, caesar.wang@rock-chips.com,
        kever.yang@rock-chips.com, Mark yao <mark.yao@rock-chips.com>
Subject: [PATCH] clk: rockchip: rk3288: add reset indices for SOFTRST9-11
Date: Fri, 12 Sep 2014 19:45:27 +0800
Message-Id: <1410522327-23175-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch add the rest of the indices of the additional reset
registers from the updated TRM.

Signed-off-by: Mark yao <mark.yao@rock-chips.com>
---
 include/dt-bindings/clock/rk3288-cru.h | 43 ++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index ebcb460..e65d522 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -276,3 +276,46 @@
 #define SRST_USBHOST1_CON	140
 #define SRST_USB_ADP		141
 #define SRST_ACC_EFUSE		142
+
+#define SRST_CORESIGHT		144
+#define SRST_PD_CORE_AHB_NOC	145
+#define SRST_PD_CORE_APB_NOC	146
+#define SRST_PD_CORE_MP_AXI	147
+#define SRST_GIC		148
+#define SRST_LCDC_PWM0		149
+#define SRST_LCDC_PWM1		150
+#define SRST_VIO0_H2P_BRG	151
+#define SRST_VIO1_H2P_BRG	152
+#define SRST_RGA_H2P_BRG	153
+#define SRST_HEVC		154
+#define SRST_TSADC		159
+
+#define SRST_DDRPHY0		160
+#define SRST_DDRPHY0_APB	161
+#define SRST_DDRCTRL0		162
+#define SRST_DDRCTRL0_APB	163
+#define SRST_DDRPHY0_CTRL	164
+#define SRST_DDRPHY1		165
+#define SRST_DDRPHY1_APB	166
+#define SRST_DDRCTRL1		167
+#define SRST_DDRCTRL1_APB	168
+#define SRST_DDRPHY1_CTRL	169
+#define SRST_DDRMSCH0		170
+#define SRST_DDRMSCH1		171
+#define SRST_CRYPTO		174
+#define SRST_C2C_HOST		175
+
+#define SRST_LCDC1_AXI		176
+#define SRST_LCDC1_AHB		177
+#define SRST_LCDC1_DCLK		178
+#define SRST_UART0		179
+#define SRST_UART1		180
+#define SRST_UART2		181
+#define SRST_UART3		182
+#define SRST_UART4		183
+#define SRST_SIMC		186
+#define SRST_PS2C		187
+#define SRST_TSP		188
+#define SRST_TSP_CLKIN0		189
+#define SRST_TSP_CLKIN1		190
+#define SRST_TSP_27M		191
-- 
1.9.1

