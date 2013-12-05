Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3LEKsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:48:10 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3797 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3LEKsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:48:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Dec 2013 02:45:04 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 4/4] ARM: tegra: convert dts files of Tegra30 platforms to use pinctrl defines
Date: Thu, 5 Dec 2013 16:14:09 +0530
Message-ID: <1386240249-30786-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
References: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use Tegra pinconrol dt-binding macro to set the values of different pinmux
properties of Tegra30 platforms.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
- New patch on this series.

 arch/arm/boot/dts/tegra30-beaver.dts  |   34 ++++++++++++++--------------
 arch/arm/boot/dts/tegra30-cardhu.dtsi |   40 ++++++++++++++++----------------
 arch/arm/boot/dts/tegra30.dtsi        |    1 +
 3 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-beaver.dts b/arch/arm/boot/dts/tegra30-beaver.dts
index 08cad69..48b89a4 100644
--- a/arch/arm/boot/dts/tegra30-beaver.dts
+++ b/arch/arm/boot/dts/tegra30-beaver.dts
@@ -52,8 +52,8 @@
 			sdmmc1_clk_pz0 {
 				nvidia,pins = "sdmmc1_clk_pz0";
 				nvidia,function = "sdmmc1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc1_cmd_pz1 {
 				nvidia,pins =	"sdmmc1_cmd_pz1",
@@ -62,14 +62,14 @@
 						"sdmmc1_dat2_py5",
 						"sdmmc1_dat3_py4";
 				nvidia,function = "sdmmc1";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc3_clk_pa6 {
 				nvidia,pins = "sdmmc3_clk_pa6";
 				nvidia,function = "sdmmc3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc3_cmd_pa7 {
 				nvidia,pins =	"sdmmc3_cmd_pa7",
@@ -78,15 +78,15 @@
 						"sdmmc3_dat2_pb5",
 						"sdmmc3_dat3_pb4";
 				nvidia,function = "sdmmc3";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc4_clk_pcc4 {
 				nvidia,pins =	"sdmmc4_clk_pcc4",
 						"sdmmc4_rst_n_pcc3";
 				nvidia,function = "sdmmc4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc4_dat0_paa0 {
 				nvidia,pins =	"sdmmc4_dat0_paa0",
@@ -98,8 +98,8 @@
 						"sdmmc4_dat6_paa6",
 						"sdmmc4_dat7_paa7";
 				nvidia,function = "sdmmc4";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			dap2_fs_pa2 {
 				nvidia,pins =	"dap2_fs_pa2",
@@ -107,18 +107,18 @@
 						"dap2_din_pa4",
 						"dap2_dout_pa5";
 				nvidia,function = "i2s1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			pex_l1_prsnt_n_pdd4 {
 				nvidia,pins =	"pex_l1_prsnt_n_pdd4",
 						"pex_l1_clkreq_n_pdd6";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			sdio3 {
 				nvidia,pins = "drive_sdio3";
-				nvidia,high-speed-mode = <0>;
-				nvidia,schmitt = <0>;
+				nvidia,high-speed-mode = <TEGRA_PIN_DISABLE>;
+				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
 				nvidia,pull-down-strength = <46>;
 				nvidia,pull-up-strength = <42>;
 				nvidia,slew-rate-rising = <1>;
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index 5ea7dfa..afe5c6a 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -59,8 +59,8 @@
 			sdmmc1_clk_pz0 {
 				nvidia,pins = "sdmmc1_clk_pz0";
 				nvidia,function = "sdmmc1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc1_cmd_pz1 {
 				nvidia,pins =	"sdmmc1_cmd_pz1",
@@ -69,14 +69,14 @@
 						"sdmmc1_dat2_py5",
 						"sdmmc1_dat3_py4";
 				nvidia,function = "sdmmc1";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc3_clk_pa6 {
 				nvidia,pins = "sdmmc3_clk_pa6";
 				nvidia,function = "sdmmc3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc3_cmd_pa7 {
 				nvidia,pins =	"sdmmc3_cmd_pa7",
@@ -85,15 +85,15 @@
 						"sdmmc3_dat2_pb5",
 						"sdmmc3_dat3_pb4";
 				nvidia,function = "sdmmc3";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc4_clk_pcc4 {
 				nvidia,pins =	"sdmmc4_clk_pcc4",
 						"sdmmc4_rst_n_pcc3";
 				nvidia,function = "sdmmc4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc4_dat0_paa0 {
 				nvidia,pins =	"sdmmc4_dat0_paa0",
@@ -105,8 +105,8 @@
 						"sdmmc4_dat6_paa6",
 						"sdmmc4_dat7_paa7";
 				nvidia,function = "sdmmc4";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			dap2_fs_pa2 {
 				nvidia,pins =	"dap2_fs_pa2",
@@ -114,17 +114,17 @@
 						"dap2_din_pa4",
 						"dap2_dout_pa5";
 				nvidia,function = "i2s1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdio3 {
 				nvidia,pins = "drive_sdio3";
-				nvidia,high-speed-mode = <0>;
-				nvidia,schmitt = <0>;
+				nvidia,high-speed-mode = <TEGRA_PIN_DISABLE>;
+				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
 				nvidia,pull-down-strength = <46>;
 				nvidia,pull-up-strength = <42>;
-				nvidia,slew-rate-rising = <1>;
-				nvidia,slew-rate-falling = <1>;
+				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_FAST>;
+				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_FAST>;
 			};
 			uart3_txd_pw6 {
 				nvidia,pins =	"uart3_txd_pw6",
@@ -132,8 +132,8 @@
 						"uart3_rts_n_pc0",
 						"uart3_rxd_pw7";
 				nvidia,function = "uartc";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra30.dtsi b/arch/arm/boot/dts/tegra30.dtsi
index 2bd55cf..9a9980f 100644
--- a/arch/arm/boot/dts/tegra30.dtsi
+++ b/arch/arm/boot/dts/tegra30.dtsi
@@ -1,5 +1,6 @@
 #include <dt-bindings/clock/tegra30-car.h>
 #include <dt-bindings/gpio/tegra-gpio.h>
+#include <dt-bindings/pinctrl/pinctrl-tegra.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
-- 
1.7.1.1

