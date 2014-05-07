Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbaEGKV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 06:21:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40661 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535AbaEGKV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 06:21:26 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <mturquette@linaro.org>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <t-kristo@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <robh+dt@kernel.org>, <bcousson@baylibre.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 1/4] ARM: dts: dra7xx-clocks: Correct name for atl clkin3 clock
Date: Wed, 7 May 2014 13:20:45 +0300
Message-ID: <1399458048-28213-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399458048-28213-1-git-send-email-peter.ujfalusi@ti.com>
References: <1399458048-28213-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To allign the name with the other atl clock names:
atlclkin3_ck -> atl_clkin3_ck

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/dra7xx-clocks.dtsi | 22 +++++++++++-----------
 drivers/clk/ti/clk-7xx.c             |  2 +-
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/dra7xx-clocks.dtsi b/arch/arm/boot/dts/dra7xx-clocks.dtsi
index cfb8fc753f50..30160348934c 100644
--- a/arch/arm/boot/dts/dra7xx-clocks.dtsi
+++ b/arch/arm/boot/dts/dra7xx-clocks.dtsi
@@ -26,7 +26,7 @@
 		clock-frequency = <0>;
 	};
 
-	atlclkin3_ck: atlclkin3_ck {
+	atl_clkin3_ck: atl_clkin3_ck {
 		#clock-cells = <0>;
 		compatible = "fixed-clock";
 		clock-frequency = <0>;
@@ -730,7 +730,7 @@
 	mcasp1_ahclkr_mux: mcasp1_ahclkr_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <28>;
 		reg = <0x0550>;
 	};
@@ -738,7 +738,7 @@
 	mcasp1_ahclkx_mux: mcasp1_ahclkx_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <24>;
 		reg = <0x0550>;
 	};
@@ -1631,7 +1631,7 @@
 	mcasp2_ahclkr_mux: mcasp2_ahclkr_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <28>;
 		reg = <0x1860>;
 	};
@@ -1639,7 +1639,7 @@
 	mcasp2_ahclkx_mux: mcasp2_ahclkx_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <24>;
 		reg = <0x1860>;
 	};
@@ -1655,7 +1655,7 @@
 	mcasp3_ahclkx_mux: mcasp3_ahclkx_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <24>;
 		reg = <0x1868>;
 	};
@@ -1671,7 +1671,7 @@
 	mcasp4_ahclkx_mux: mcasp4_ahclkx_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <24>;
 		reg = <0x1898>;
 	};
@@ -1687,7 +1687,7 @@
 	mcasp5_ahclkx_mux: mcasp5_ahclkx_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <24>;
 		reg = <0x1878>;
 	};
@@ -1703,7 +1703,7 @@
 	mcasp6_ahclkx_mux: mcasp6_ahclkx_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <24>;
 		reg = <0x1904>;
 	};
@@ -1719,7 +1719,7 @@
 	mcasp7_ahclkx_mux: mcasp7_ahclkx_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <24>;
 		reg = <0x1908>;
 	};
@@ -1735,7 +1735,7 @@
 	mcasp8_ahclk_mux: mcasp8_ahclk_mux {
 		#clock-cells = <0>;
 		compatible = "ti,mux-clock";
-		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atlclkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
+		clocks = <&abe_24m_fclk>, <&abe_sys_clk_div>, <&func_24m_clk>, <&atl_clkin3_ck>, <&atl_clkin2_ck>, <&atl_clkin1_ck>, <&atl_clkin0_ck>, <&sys_clkin2>, <&ref_clkin0_ck>, <&ref_clkin1_ck>, <&ref_clkin2_ck>, <&ref_clkin3_ck>, <&mlb_clk>, <&mlbp_clk>;
 		ti,bit-shift = <22>;
 		reg = <0x1890>;
 	};
diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
index 19a55bf407dd..cb8e6f14e880 100644
--- a/drivers/clk/ti/clk-7xx.c
+++ b/drivers/clk/ti/clk-7xx.c
@@ -24,7 +24,7 @@ static struct ti_dt_clk dra7xx_clks[] = {
 	DT_CLK(NULL, "atl_clkin0_ck", "atl_clkin0_ck"),
 	DT_CLK(NULL, "atl_clkin1_ck", "atl_clkin1_ck"),
 	DT_CLK(NULL, "atl_clkin2_ck", "atl_clkin2_ck"),
-	DT_CLK(NULL, "atlclkin3_ck", "atlclkin3_ck"),
+	DT_CLK(NULL, "atl_clkin3_ck", "atl_clkin3_ck"),
 	DT_CLK(NULL, "hdmi_clkin_ck", "hdmi_clkin_ck"),
 	DT_CLK(NULL, "mlb_clkin_ck", "mlb_clkin_ck"),
 	DT_CLK(NULL, "mlbp_clkin_ck", "mlbp_clkin_ck"),
-- 
1.9.2

