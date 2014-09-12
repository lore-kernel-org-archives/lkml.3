Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaILKdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:33:42 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:42761 "EHLO
	vasmtpcom.263.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751950AbaILKdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:33:41 -0400
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: mturquette@linaro.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <8f8728f8664ef36a4c71fe5e16d5c9ae>
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
Subject: [PATCH] clk: rockchip: rk3288: add VOP1 softresets and rename VOP0 softresets
Date: Fri, 12 Sep 2014 18:33:23 +0800
Message-Id: <1410518004-19040-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rk3288 have two vop, and each vop has three softresets were axi_reset,
ahb_reset and dclk_reset.

Signed-off-by: Mark yao <mark.yao@rock-chips.com>
---
 include/dt-bindings/clock/rk3288-cru.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index ebcb460..4d65959 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -235,9 +235,9 @@
 #define SRST_RGA_NIU		97
 #define SRST_VIO0_NIU_AXI	98
 #define SRST_VIO_NIU_AHB	99
-#define SRST_LCDC0_AXI		100
-#define SRST_LCDC0_AHB		101
-#define SRST_LCDC0_DCLK		102
+#define SRST_VOP0_AXI		100
+#define SRST_VOP0_AHB		101
+#define SRST_VOP0_DCLK		102
 #define SRST_VIO1_NIU_AXI	103
 #define SRST_VIP		104
 #define SRST_RGA_CORE		105
@@ -276,3 +276,7 @@
 #define SRST_USBHOST1_CON	140
 #define SRST_USB_ADP		141
 #define SRST_ACC_EFUSE		142
+
+#define SRST_VOP1_AXI		176
+#define SRST_VOP1_AHB		177
+#define SRST_VOP1_DCLK		178
-- 
1.9.1

