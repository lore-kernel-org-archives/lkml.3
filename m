Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaKZANU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:13:20 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:57675 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaKZANS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:13:18 -0500
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, cym@rock-chips.com,
        Mike Turquette <mturquette@linaro.org>
Cc: Derek Basehore <dbasehore@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        kever.yang@rock-chips.com, mark.yao@rock-chips.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] clk: rockchip: add binding ID for DMC (memory controller) clocks on rk3288
Date: Tue, 25 Nov 2014 16:13:02 -0800
Message-Id: <1416960783-25119-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Chen <cym@rock-chips.com>

The DMC clocks need to be turned off at runtime, so we should have IDs
so we can export them.

Signed-off-by: Jeff Chen <cym@rock-chips.com>
[dianders: split into two patches; adjusted commit msg]
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 include/dt-bindings/clock/rk3288-cru.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
index 100a08c..8e19ed5 100644
--- a/include/dt-bindings/clock/rk3288-cru.h
+++ b/include/dt-bindings/clock/rk3288-cru.h
@@ -141,6 +141,10 @@
 #define PCLK_VIO2_H2P		361
 #define PCLK_CPU		362
 #define PCLK_PERI		363
+#define PCLK_DDRUPCTL0		364
+#define PCLK_PUBL0		365
+#define PCLK_DDRUPCTL1		366
+#define PCLK_PUBL1		367
 
 /* hclk gates */
 #define HCLK_GPS		448
-- 
2.1.0.rc2.206.gedb03e5

