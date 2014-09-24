Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbaIXNhR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:37:17 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:37391 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIXNhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:37:13 -0400
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, Mike Turquette <mturquette@linaro.org>
Cc: dianders@chromium.org, sonnyrao@chromium.org, addy.ke@rock-chips.com,
        cf@rock-chips.com, xjq@rock-chips.com, hj@rock-chips.com,
        huangtao@rock-chips.com, linux-rockchip@lists.infradead.org,
        Kever Yang <kever.yang@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] clk: rockchip: add some needed clock binding id for rk3288
Date: Wed, 24 Sep 2014 21:36:34 +0800
Message-Id: <1411565795-26966-2-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411565795-26966-1-git-send-email-kever.yang@rock-chips.com>
References: <1411565795-26966-1-git-send-email-kever.yang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add some clock binding id for different modules
that under development and going to send upstream.

Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
---

 include/dt-bindings/clock/rk3288-cru.h | 38 +++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index ebcb460..ee579ff 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -61,6 +61,15 @@
 #define SCLK_LCDC_PWM1		101
 #define SCLK_MAC_RX		102
 #define SCLK_MAC_TX		103
+#define SCLK_EDP_24M		104
+#define SCLK_EDP		105
+#define SCLK_RGA		106
+#define SCLK_ISP		107
+#define SCLK_ISP_JPE		108
+#define SCLK_HDMI_HDCP		109
+#define SCLK_HDMI_CEC		110
+#define SCLK_HEVC_CABAC		111
+#define SCLK_HEVC_CORE		112
 
 #define DCLK_VOP0		190
 #define DCLK_VOP1		191
@@ -75,6 +84,16 @@
 #define ACLK_VOP1		198
 #define ACLK_CRYPTO		199
 #define ACLK_RGA		200
+#define ACLK_RGA_NIU		201
+#define ACLK_IEP		202
+#define ACLK_VIO0_NIU		203
+#define ACLK_VIP		204
+#define ACLK_ISP		205
+#define ACLK_VIO1_NIU		206
+#define ACLK_HEVC		207
+#define ACLK_VCODEC		208
+#define ACLK_CPU		209
+#define ACLK_PERI		210
 
 /* pclk gates */
 #define PCLK_GPIO0		320
@@ -112,6 +131,15 @@
 #define PCLK_PS2C		352
 #define PCLK_TIMER		353
 #define PCLK_TZPC		354
+#define PCLK_EDP_CTRL		355
+#define PCLK_MIPI_DSI0		356
+#define PCLK_MIPI_DSI1		357
+#define PCLK_MIPI_CSI		358
+#define PCLK_LVDS_PHY		359
+#define PCLK_HDMI_CTRL		360
+#define PCLK_VIO2_H2P		361
+#define PCLK_CPU		362
+#define PCLK_PERI		363
 
 /* hclk gates */
 #define HCLK_GPS		448
@@ -137,8 +165,16 @@
 #define HCLK_IEP		468
 #define HCLK_ISP		469
 #define HCLK_RGA		470
+#define HCLK_VIO_AHB_ARBI	471
+#define HCLK_VIO_NIU		472
+#define HCLK_VIP		473
+#define HCLK_VIO2_H2P		474
+#define HCLK_HEVC		475
+#define HCLK_VCODEC		476
+#define HCLK_CPU		477
+#define HCLK_PERI		478
 
-#define CLK_NR_CLKS		(HCLK_RGA + 1)
+#define CLK_NR_CLKS		(HCLK_PERI + 1)
 
 /* soft-reset indices */
 #define SRST_CORE0		0
-- 
1.9.1

