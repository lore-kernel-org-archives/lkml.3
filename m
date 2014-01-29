Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaA2STs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:19:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46037 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbaA2STp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:19:45 -0500
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] clk: ti: am335x: remove unecessary cpu0 clk node
Date: Wed, 29 Jan 2014 12:19:16 -0600
Message-ID: <1391019557-22313-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391019557-22313-1-git-send-email-nm@ti.com>
References: <1391019557-22313-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu0 clock node has no functionality, since cpufreq-cpu0 is already
capable of picking up the clock from dts.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/clk/ti/clk-33xx.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/ti/clk-33xx.c b/drivers/clk/ti/clk-33xx.c
index 776ee45..028b337 100644
--- a/drivers/clk/ti/clk-33xx.c
+++ b/drivers/clk/ti/clk-33xx.c
@@ -34,7 +34,6 @@ static struct ti_dt_clk am33xx_clks[] = {
 	DT_CLK(NULL, "dpll_core_m5_ck", "dpll_core_m5_ck"),
 	DT_CLK(NULL, "dpll_core_m6_ck", "dpll_core_m6_ck"),
 	DT_CLK(NULL, "dpll_mpu_ck", "dpll_mpu_ck"),
-	DT_CLK("cpu0", NULL, "dpll_mpu_ck"),
 	DT_CLK(NULL, "dpll_mpu_m2_ck", "dpll_mpu_m2_ck"),
 	DT_CLK(NULL, "dpll_ddr_ck", "dpll_ddr_ck"),
 	DT_CLK(NULL, "dpll_ddr_m2_ck", "dpll_ddr_m2_ck"),
-- 
1.7.9.5

