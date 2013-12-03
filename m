Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3LCNTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:19:21 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:6163 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3LCNTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:19:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Dec 2013 05:16:07 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>
CC: <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <thierry.reding@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/2] ARM: tegra: convert device tree file of Dalmore to use pinctrl defines
Date: Tue, 3 Dec 2013 18:46:07 +0530
Message-ID: <1386076567-14283-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1386076567-14283-1-git-send-email-ldewangan@nvidia.com>
References: <1386076567-14283-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Changes as per new macros.

 arch/arm/boot/dts/tegra114-dalmore.dts |  549 ++++++++++++++++----------------
 1 files changed, 275 insertions(+), 274 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
index cb5ec23..5930a2d 100644
--- a/arch/arm/boot/dts/tegra114-dalmore.dts
+++ b/arch/arm/boot/dts/tegra114-dalmore.dts
@@ -1,6 +1,7 @@
 /dts-v1/;
 
 #include <dt-bindings/input/input.h>
+#include <dt-bindings/pinctrl/pinctrl-tegra.h>
 #include "tegra114.dtsi"
 
 / {
@@ -19,41 +20,41 @@
 			clk1_out_pw4 {
 				nvidia,pins = "clk1_out_pw4";
 				nvidia,function = "extperiph1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			dap1_din_pn1 {
 				nvidia,pins = "dap1_din_pn1";
 				nvidia,function = "i2s0";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			dap1_dout_pn2 {
 				nvidia,pins = "dap1_dout_pn2",
 						"dap1_fs_pn0",
 						"dap1_sclk_pn3";
 				nvidia,function = "i2s0";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			dap2_din_pa4 {
 				nvidia,pins = "dap2_din_pa4";
 				nvidia,function = "i2s1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			dap2_dout_pa5 {
 				nvidia,pins = "dap2_dout_pa5",
 						"dap2_fs_pa2",
 						"dap2_sclk_pa3";
 				nvidia,function = "i2s1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			dap4_din_pp5 {
 				nvidia,pins = "dap4_din_pp5",
@@ -61,17 +62,17 @@
 						"dap4_fs_pp4",
 						"dap4_sclk_pp7";
 				nvidia,function = "i2s3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			dvfs_pwm_px0 {
 				nvidia,pins = "dvfs_pwm_px0",
 						"dvfs_clk_px2";
 				nvidia,function = "cldvfs";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			ulpi_clk_py0 {
 				nvidia,pins = "ulpi_clk_py0",
@@ -84,128 +85,128 @@
 						"ulpi_data6_po7",
 						"ulpi_data7_po0";
 				nvidia,function = "ulpi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			ulpi_dir_py1 {
 				nvidia,pins = "ulpi_dir_py1",
 						"ulpi_nxt_py2";
 				nvidia,function = "ulpi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			ulpi_stp_py3 {
 				nvidia,pins = "ulpi_stp_py3";
 				nvidia,function = "ulpi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			cam_i2c_scl_pbb1 {
 				nvidia,pins = "cam_i2c_scl_pbb1",
 						"cam_i2c_sda_pbb2";
 				nvidia,function = "i2c3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
-				nvidia,open-drain = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
 			};
 			cam_mclk_pcc0 {
 				nvidia,pins = "cam_mclk_pcc0",
 						"pbb0";
 				nvidia,function = "vi_alt3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
-				nvidia,lock = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
 			};
 			gen2_i2c_scl_pt5 {
 				nvidia,pins = "gen2_i2c_scl_pt5",
 						"gen2_i2c_sda_pt6";
 				nvidia,function = "i2c2";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
-				nvidia,open-drain = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
 			};
 			gmi_a16_pj7 {
 				nvidia,pins = "gmi_a16_pj7";
 				nvidia,function = "uartd";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gmi_a17_pb0 {
 				nvidia,pins = "gmi_a17_pb0",
 						"gmi_a18_pb1";
 				nvidia,function = "uartd";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gmi_a19_pk7 {
 				nvidia,pins = "gmi_a19_pk7";
 				nvidia,function = "uartd";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gmi_ad5_pg5 {
 				nvidia,pins = "gmi_ad5_pg5",
 						"gmi_cs6_n_pi3",
 						"gmi_wr_n_pi0";
 				nvidia,function = "spi4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gmi_ad6_pg6 {
 				nvidia,pins = "gmi_ad6_pg6",
 						"gmi_ad7_pg7";
 				nvidia,function = "spi4";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gmi_ad12_ph4 {
 				nvidia,pins = "gmi_ad12_ph4";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gmi_ad9_ph1 {
 				nvidia,pins = "gmi_ad9_ph1";
 				nvidia,function = "pwm1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gmi_cs1_n_pj2 {
 				nvidia,pins = "gmi_cs1_n_pj2",
 						"gmi_oe_n_pi1";
 				nvidia,function = "soc";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			clk2_out_pw5 {
 				nvidia,pins = "clk2_out_pw5";
 				nvidia,function = "extperiph2";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc1_clk_pz0 {
 				nvidia,pins = "sdmmc1_clk_pz0";
 				nvidia,function = "sdmmc1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			sdmmc1_cmd_pz1 {
 				nvidia,pins = "sdmmc1_cmd_pz1",
@@ -214,23 +215,23 @@
 						"sdmmc1_dat2_py5",
 						"sdmmc1_dat3_py4";
 				nvidia,function = "sdmmc1";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			sdmmc1_wp_n_pv3 {
 				nvidia,pins = "sdmmc1_wp_n_pv3";
 				nvidia,function = "spi4";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc3_clk_pa6 {
 				nvidia,pins = "sdmmc3_clk_pa6";
 				nvidia,function = "sdmmc3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			sdmmc3_cmd_pa7 {
 				nvidia,pins = "sdmmc3_cmd_pa7",
@@ -242,16 +243,16 @@
 						"sdmmc3_clk_lb_out_pee4",
 						"sdmmc3_clk_lb_in_pee5";
 				nvidia,function = "sdmmc3";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			sdmmc4_clk_pcc4 {
 				nvidia,pins = "sdmmc4_clk_pcc4";
 				nvidia,function = "sdmmc4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			sdmmc4_cmd_pt7 {
 				nvidia,pins = "sdmmc4_cmd_pt7",
@@ -264,16 +265,16 @@
 						"sdmmc4_dat6_paa6",
 						"sdmmc4_dat7_paa7";
 				nvidia,function = "sdmmc4";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			clk_32k_out_pa0 {
 				nvidia,pins = "clk_32k_out_pa0";
 				nvidia,function = "blink";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			kb_col0_pq0 {
 				nvidia,pins = "kb_col0_pq0",
@@ -283,265 +284,265 @@
 						"kb_row1_pr1",
 						"kb_row2_pr2";
 				nvidia,function = "kbc";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			dap3_din_pp1 {
 				nvidia,pins = "dap3_din_pp1",
 						"dap3_sclk_pp3";
 				nvidia,function = "displayb";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			pv0 {
 				nvidia,pins = "pv0";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			kb_row7_pr7 {
 				nvidia,pins = "kb_row7_pr7";
 				nvidia,function = "rsvd2";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			kb_row10_ps2 {
 				nvidia,pins = "kb_row10_ps2";
 				nvidia,function = "uarta";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			kb_row9_ps1 {
 				nvidia,pins = "kb_row9_ps1";
 				nvidia,function = "uarta";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			pwr_i2c_scl_pz6 {
 				nvidia,pins = "pwr_i2c_scl_pz6",
 						"pwr_i2c_sda_pz7";
 				nvidia,function = "i2cpwr";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
-				nvidia,open-drain = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
 			};
 			sys_clk_req_pz5 {
 				nvidia,pins = "sys_clk_req_pz5";
 				nvidia,function = "sysclk";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			core_pwr_req {
 				nvidia,pins = "core_pwr_req";
 				nvidia,function = "pwron";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			cpu_pwr_req {
 				nvidia,pins = "cpu_pwr_req";
 				nvidia,function = "cpu";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			pwr_int_n {
 				nvidia,pins = "pwr_int_n";
 				nvidia,function = "pmi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			reset_out_n {
 				nvidia,pins = "reset_out_n";
 				nvidia,function = "reset_out_n";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			clk3_out_pee0 {
 				nvidia,pins = "clk3_out_pee0";
 				nvidia,function = "extperiph3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gen1_i2c_scl_pc4 {
 				nvidia,pins = "gen1_i2c_scl_pc4",
 						"gen1_i2c_sda_pc5";
 				nvidia,function = "i2c1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
-				nvidia,open-drain = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
 			};
 			uart2_cts_n_pj5 {
 				nvidia,pins = "uart2_cts_n_pj5";
 				nvidia,function = "uartb";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			uart2_rts_n_pj6 {
 				nvidia,pins = "uart2_rts_n_pj6";
 				nvidia,function = "uartb";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			uart2_rxd_pc3 {
 				nvidia,pins = "uart2_rxd_pc3";
 				nvidia,function = "irda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			uart2_txd_pc2 {
 				nvidia,pins = "uart2_txd_pc2";
 				nvidia,function = "irda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			uart3_cts_n_pa1 {
 				nvidia,pins = "uart3_cts_n_pa1",
 						"uart3_rxd_pw7";
 				nvidia,function = "uartc";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			uart3_rts_n_pc0 {
 				nvidia,pins = "uart3_rts_n_pc0",
 						"uart3_txd_pw6";
 				nvidia,function = "uartc";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			owr {
 				nvidia,pins = "owr";
 				nvidia,function = "owr";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			hdmi_cec_pee3 {
 				nvidia,pins = "hdmi_cec_pee3";
 				nvidia,function = "cec";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
-				nvidia,open-drain = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_DISABLE>;
 			};
 			ddc_scl_pv4 {
 				nvidia,pins = "ddc_scl_pv4",
 						"ddc_sda_pv5";
 				nvidia,function = "i2c4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
-				nvidia,rcv-sel = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,rcv-sel = <TEGRA_PIN_ENABLE>;
 			};
 			spdif_in_pk6 {
 				nvidia,pins = "spdif_in_pk6";
 				nvidia,function = "usb";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
 			};
 			usb_vbus_en0_pn4 {
 				nvidia,pins = "usb_vbus_en0_pn4";
 				nvidia,function = "usb";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
-				nvidia,lock = <0>;
-				nvidia,open-drain = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
+				nvidia,lock = <TEGRA_PIN_DISABLE>;
+				nvidia,open-drain = <TEGRA_PIN_ENABLE>;
 			};
 			gpio_x6_aud_px6 {
 				nvidia,pins = "gpio_x6_aud_px6";
 				nvidia,function = "spi6";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gpio_x4_aud_px4 {
 				nvidia,pins = "gpio_x4_aud_px4",
 						"gpio_x7_aud_px7";
 				nvidia,function = "rsvd1";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gpio_x5_aud_px5 {
 				nvidia,pins = "gpio_x5_aud_px5";
 				nvidia,function = "rsvd1";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gpio_w2_aud_pw2 {
 				nvidia,pins = "gpio_w2_aud_pw2";
 				nvidia,function = "rsvd2";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gpio_w3_aud_pw3 {
 				nvidia,pins = "gpio_w3_aud_pw3";
 				nvidia,function = "spi6";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gpio_x1_aud_px1 {
 				nvidia,pins = "gpio_x1_aud_px1";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gpio_x3_aud_px3 {
 				nvidia,pins = "gpio_x3_aud_px3";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			dap3_fs_pp0 {
 				nvidia,pins = "dap3_fs_pp0";
 				nvidia,function = "i2s2";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			dap3_dout_pp2 {
 				nvidia,pins = "dap3_dout_pp2";
 				nvidia,function = "i2s2";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			pv1 {
 				nvidia,pins = "pv1";
 				nvidia,function = "rsvd1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			pbb3 {
 				nvidia,pins = "pbb3",
@@ -549,25 +550,25 @@
 						"pbb6",
 						"pbb7";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			pcc1 {
 				nvidia,pins = "pcc1",
 						"pcc2";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gmi_ad0_pg0 {
 				nvidia,pins = "gmi_ad0_pg0",
 						"gmi_ad1_pg1";
 				nvidia,function = "gmi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gmi_ad10_ph2 {
 				nvidia,pins = "gmi_ad10_ph2",
@@ -576,17 +577,17 @@
 						"gmi_ad8_ph0",
 						"gmi_clk_pk1";
 				nvidia,function = "gmi";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			gmi_ad2_pg2 {
 				nvidia,pins = "gmi_ad2_pg2",
 						"gmi_ad3_pg3";
 				nvidia,function = "gmi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gmi_adv_n_pk0 {
 				nvidia,pins = "gmi_adv_n_pk0",
@@ -598,39 +599,39 @@
 						"gmi_iordy_pi5",
 						"gmi_wp_n_pc7";
 				nvidia,function = "gmi";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			gmi_cs3_n_pk4 {
 				nvidia,pins = "gmi_cs3_n_pk4";
 				nvidia,function = "gmi";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			clk2_req_pcc5 {
 				nvidia,pins = "clk2_req_pcc5";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			kb_col3_pq3 {
 				nvidia,pins = "kb_col3_pq3",
 						"kb_col6_pq6",
 						"kb_col7_pq7";
 				nvidia,function = "kbc";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			kb_col5_pq5 {
 				nvidia,pins = "kb_col5_pq5";
 				nvidia,function = "kbc";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			kb_row3_pr3 {
 				nvidia,pins = "kb_row3_pr3",
@@ -638,77 +639,77 @@
 						"kb_row6_pr6",
 						"kb_row8_ps0";
 				nvidia,function = "kbc";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			clk3_req_pee1 {
 				nvidia,pins = "clk3_req_pee1";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			pu4 {
 				nvidia,pins = "pu4";
 				nvidia,function = "displayb";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 			pu5 {
 				nvidia,pins = "pu5",
 						"pu6";
 				nvidia,function = "displayb";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			hdmi_int_pn7 {
 				nvidia,pins = "hdmi_int_pn7";
 				nvidia,function = "rsvd1";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
-				nvidia,enable-input = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
+				nvidia,enable-input = <TEGRA_PIN_ENABLE>;
 			};
 			clk1_req_pee2 {
 				nvidia,pins = "clk1_req_pee2",
 						"usb_vbus_en1_pn5";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
-				nvidia,enable-input = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
+				nvidia,enable-input = <TEGRA_PIN_DISABLE>;
 			};
 
 			drive_sdio1 {
 				nvidia,pins = "drive_sdio1";
-				nvidia,high-speed-mode = <1>;
-				nvidia,schmitt = <0>;
-				nvidia,low-power-mode = <3>;
+				nvidia,high-speed-mode = <TEGRA_PIN_ENABLE>;
+				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
+				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <36>;
 				nvidia,pull-up-strength = <20>;
-				nvidia,slew-rate-rising = <2>;
-				nvidia,slew-rate-falling = <2>;
+				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_SLOW>;
+				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_SLOW>;
 			};
 			drive_sdio3 {
 				nvidia,pins = "drive_sdio3";
-				nvidia,high-speed-mode = <1>;
-				nvidia,schmitt = <0>;
-				nvidia,low-power-mode = <3>;
+				nvidia,high-speed-mode = <TEGRA_PIN_ENABLE>;
+				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
+				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <22>;
 				nvidia,pull-up-strength = <36>;
-				nvidia,slew-rate-rising = <0>;
-				nvidia,slew-rate-falling = <0>;
+				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_FASTEST>;
+				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_FASTEST>;
 			};
 			drive_gma {
 				nvidia,pins = "drive_gma";
-				nvidia,high-speed-mode = <1>;
-				nvidia,schmitt = <0>;
-				nvidia,low-power-mode = <3>;
+				nvidia,high-speed-mode = <TEGRA_PIN_ENABLE>;
+				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
+				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <2>;
 				nvidia,pull-up-strength = <1>;
-				nvidia,slew-rate-rising = <0>;
-				nvidia,slew-rate-falling = <0>;
+				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_FASTEST>;
+				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_FASTEST>;
 				nvidia,drive-type = <1>;
 			};
 		};
-- 
1.7.1.1

