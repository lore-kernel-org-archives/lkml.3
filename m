Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3LEKsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:48:00 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3666 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3LEKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:47:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Dec 2013 02:44:48 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 3/4] ARM: tegra: convert dts files of Tegra20 platforms to use pinctrl defines
Date: Thu, 5 Dec 2013 16:14:08 +0530
Message-ID: <1386240249-30786-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
References: <1386240249-30786-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use Tegra pinconrol dt-binding macro to set the values of different pinmux
properties of Tegra20 platforms.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
- New patch on this series.

 arch/arm/boot/dts/tegra20-colibri-512.dtsi |  104 ++++++++++++++--------------
 arch/arm/boot/dts/tegra20-harmony.dts      |   30 ++++----
 arch/arm/boot/dts/tegra20-iris-512.dts     |   10 ++--
 arch/arm/boot/dts/tegra20-paz00.dts        |   30 ++++----
 arch/arm/boot/dts/tegra20-seaboard.dts     |   44 ++++++------
 arch/arm/boot/dts/tegra20-tamonten.dtsi    |   30 ++++----
 arch/arm/boot/dts/tegra20-trimslice.dts    |   34 +++++-----
 arch/arm/boot/dts/tegra20-ventana.dts      |   44 ++++++------
 arch/arm/boot/dts/tegra20-whistler.dts     |   40 +++++-----
 arch/arm/boot/dts/tegra20.dtsi             |    1 +
 10 files changed, 184 insertions(+), 183 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index d5c9bca..6ae66ad 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -27,20 +27,20 @@
 			audio_refclk {
 				nvidia,pins = "cdev1";
 				nvidia,function = "plla_out";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			crt {
 				nvidia,pins = "crtp";
 				nvidia,function = "crt";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			dap3 {
 				nvidia,pins = "dap3";
 				nvidia,function = "dap3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			displaya {
 				nvidia,pins = "ld0", "ld1", "ld2", "ld3",
@@ -50,151 +50,151 @@
 					"lhs", "lpw0", "lpw2", "lsc0",
 					"lsc1", "lsck", "lsda", "lspi", "lvs";
 				nvidia,function = "displaya";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			gpio_dte {
 				nvidia,pins = "dte";
 				nvidia,function = "rsvd1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			gpio_gmi {
 				nvidia,pins = "ata", "atc", "atd", "ate",
 					"dap1", "dap2", "dap4", "gpu", "irrx",
 					"irtx", "spia", "spib", "spic";
 				nvidia,function = "gmi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			gpio_pta {
 				nvidia,pins = "pta";
 				nvidia,function = "rsvd4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			gpio_uac {
 				nvidia,pins = "uac";
 				nvidia,function = "rsvd2";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			hdint {
 				nvidia,pins = "hdint";
 				nvidia,function = "hdmi";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			i2c1 {
 				nvidia,pins = "rm";
 				nvidia,function = "i2c1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			i2c3 {
 				nvidia,pins = "dtf";
 				nvidia,function = "i2c3";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			i2cddc {
 				nvidia,pins = "ddc";
 				nvidia,function = "i2c2";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			i2cp {
 				nvidia,pins = "i2cp";
 				nvidia,function = "i2cp";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			irda {
 				nvidia,pins = "uad";
 				nvidia,function = "irda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			nand {
 				nvidia,pins = "kbca", "kbcc", "kbcd",
 					"kbce", "kbcf";
 				nvidia,function = "nand";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			owc {
 				nvidia,pins = "owc";
 				nvidia,function = "owr";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			pmc {
 				nvidia,pins = "pmc";
 				nvidia,function = "pwr_on";
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			pwm {
 				nvidia,pins = "sdb", "sdc", "sdd";
 				nvidia,function = "pwm";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			sdio4 {
 				nvidia,pins = "atb", "gma", "gme";
 				nvidia,function = "sdio4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			spi1 {
 				nvidia,pins = "spid", "spie", "spif";
 				nvidia,function = "spi1";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			spi4 {
 				nvidia,pins = "slxa", "slxc", "slxd", "slxk";
 				nvidia,function = "spi4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			uarta {
 				nvidia,pins = "sdio1";
 				nvidia,function = "uarta";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			uartd {
 				nvidia,pins = "gmc";
 				nvidia,function = "uartd";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			ulpi {
 				nvidia,pins = "uaa", "uab", "uda";
 				nvidia,function = "ulpi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			ulpi_refclk {
 				nvidia,pins = "cdev2";
 				nvidia,function = "pllp_out4";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			usb_gpio {
 				nvidia,pins = "spig", "spih";
 				nvidia,function = "spi2_alt";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			vi {
 				nvidia,pins = "dta", "dtb", "dtc", "dtd";
 				nvidia,function = "vi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			vi_sc {
 				nvidia,pins = "csus";
 				nvidia,function = "vi_sensor_clk";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index e156ab3..6bd304e 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -184,50 +184,50 @@
 					"gmb", "gmc", "gmd", "gme", "gpu7",
 					"gpv", "i2cp", "pta", "rm", "slxa",
 					"slxk", "spia", "spib", "uac";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ck32 {
 				nvidia,pins = "ck32", "ddrc", "pmca", "pmcb",
 					"pmcc", "pmcd", "pmce", "xm2c", "xm2d";
-				nvidia,pull = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 			};
 			conf_csus {
 				nvidia,pins = "csus", "spid", "spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "dap2", "dap3", "dap4",
 					"dtc", "dte", "dtf", "gpu", "sdio1",
 					"slxc", "slxd", "spdi", "spdo", "spig",
 					"uda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ddc {
 				nvidia,pins = "ddc", "dta", "dtd", "kbca",
 					"kbcb", "kbcc", "kbcd", "kbce", "kbcf",
 					"sdc";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_hdint {
 				nvidia,pins = "hdint", "lcsn", "ldc", "lm1",
 					"lpw1", "lsc1", "lsck", "lsda", "lsdi",
 					"lvp0", "owc", "sdb";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_irrx {
 				nvidia,pins = "irrx", "irtx", "sdd", "spic",
 					"spie", "spih", "uaa", "uab", "uad",
 					"uca", "ucb";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_lc {
 				nvidia,pins = "lc", "ls";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			conf_ld0 {
 				nvidia,pins = "ld0", "ld1", "ld2", "ld3", "ld4",
@@ -237,12 +237,12 @@
 					"lhp1", "lhp2", "lhs", "lm0", "lpp",
 					"lpw0", "lpw2", "lsc0", "lspi", "lvp1",
 					"lvs", "pmc";
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ld17_0 {
 				nvidia,pins = "ld17_0", "ld19_18", "ld21_20",
 					"ld23_22";
-				nvidia,pull = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-iris-512.dts b/arch/arm/boot/dts/tegra20-iris-512.dts
index f2222bd..44bde98 100644
--- a/arch/arm/boot/dts/tegra20-iris-512.dts
+++ b/arch/arm/boot/dts/tegra20-iris-512.dts
@@ -15,23 +15,23 @@
 	pinmux {
 		state_default: pinmux {
 			hdint {
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 
 			i2cddc {
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 
 			sdio4 {
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 
 			uarta {
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 
 			uartd {
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 8d71fc9..3d53140 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -177,39 +177,39 @@
 					"gpu", "gpu7", "gpv", "i2cp", "pta",
 					"rm", "sdio1", "slxk", "spdo", "uac",
 					"uda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ck32 {
 				nvidia,pins = "ck32", "ddrc", "pmca", "pmcb",
 					"pmcc", "pmcd", "pmce", "xm2c", "xm2d";
-				nvidia,pull = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "dap3", "dap4", "dtb",
 					"dtc", "dte", "slxa", "slxc", "slxd",
 					"spdi";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_csus {
 				nvidia,pins = "csus", "spia", "spib", "spid",
 					"spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ddc {
 				nvidia,pins = "ddc", "irrx", "irtx", "kbca",
 					"kbcb", "kbcc", "kbcd", "kbce", "kbcf",
 					"spic", "spig", "uaa", "uab";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_dta {
 				nvidia,pins = "dta", "dtd", "owc", "sdc", "sdd",
 					"spie", "spih", "uad", "uca", "ucb";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_hdint {
 				nvidia,pins = "hdint", "ld0", "ld1", "ld2",
@@ -218,23 +218,23 @@
 					"ld13", "ld14", "ld15", "ld16", "ld17",
 					"ldc", "ldi", "lhs", "lsc0", "lspi",
 					"lvs", "pmc";
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_lc {
 				nvidia,pins = "lc", "ls";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			conf_lcsn {
 				nvidia,pins = "lcsn", "lhp0", "lhp1", "lhp2",
 					"lm0", "lm1", "lpp", "lpw0", "lpw1",
 					"lpw2", "lsc1", "lsck", "lsda", "lsdi",
 					"lvp0", "lvp1", "sdb";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ld17_0 {
 				nvidia,pins = "ld17_0", "ld19_18", "ld21_20",
 					"ld23_22";
-				nvidia,pull = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 315aae2..def7795 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -189,53 +189,53 @@
 					"irtx", "pta", "rm", "sdc", "sdd",
 					"slxd", "slxk", "spdi", "spdo", "uac",
 					"uad", "uca", "ucb", "uda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ate {
 				nvidia,pins = "ate", "csus", "dap3",
 					"gpv", "owc", "slxc", "spib", "spid",
 					"spie";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ck32 {
 				nvidia,pins = "ck32", "ddrc", "pmca", "pmcb",
 					"pmcc", "pmcd", "pmce", "xm2c", "xm2d";
-				nvidia,pull = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "gmb", "slxa", "spia",
 					"spig", "spih";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_dta {
 				nvidia,pins = "dta", "dtb", "dtc", "dtd";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_dte {
 				nvidia,pins = "dte", "spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_hdint {
 				nvidia,pins = "hdint", "lcsn", "ldc", "lm1",
 					"lpw1", "lsc1", "lsck", "lsda", "lsdi",
 					"lvp0";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_kbca {
 				nvidia,pins = "kbca", "kbcb", "kbcc", "kbcd",
 					"kbce", "kbcf", "sdio1", "spic", "uaa",
 					"uab";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_lc {
 				nvidia,pins = "lc", "ls";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			conf_ld0 {
 				nvidia,pins = "ld0", "ld1", "ld2", "ld3", "ld4",
@@ -245,22 +245,22 @@
 					"lhp1", "lhp2", "lhs", "lm0", "lpp",
 					"lpw0", "lpw2", "lsc0", "lspi", "lvp1",
 					"lvs", "pmc", "sdb";
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ld17_0 {
 				nvidia,pins = "ld17_0", "ld19_18", "ld21_20",
 					"ld23_22";
-				nvidia,pull = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
 			};
 			drive_sdio1 {
 				nvidia,pins = "drive_sdio1";
-				nvidia,high-speed-mode = <0>;
-				nvidia,schmitt = <0>;
-				nvidia,low-power-mode = <3>;
+				nvidia,high-speed-mode = <TEGRA_PIN_DISABLE>;
+				nvidia,schmitt = <TEGRA_PIN_DISABLE>;
+				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <31>;
 				nvidia,pull-up-strength = <31>;
-				nvidia,slew-rate-rising = <3>;
-				nvidia,slew-rate-falling = <3>;
+				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_SLOWEST>;
+				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_SLOWEST>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 7726dab..0da4dac 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -176,50 +176,50 @@
 					"gmb", "gmc", "gmd", "gme", "gpu7",
 					"gpv", "i2cp", "pta", "rm", "slxa",
 					"slxk", "spia", "spib", "uac";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ck32 {
 				nvidia,pins = "ck32", "ddrc", "pmca", "pmcb",
 					"pmcc", "pmcd", "pmce", "xm2c", "xm2d";
-				nvidia,pull = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 			};
 			conf_csus {
 				nvidia,pins = "csus", "spid", "spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "dap2", "dap3", "dap4",
 					"dtc", "dte", "dtf", "gpu", "sdio1",
 					"slxc", "slxd", "spdi", "spdo", "spig",
 					"uda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ddc {
 				nvidia,pins = "ddc", "dta", "dtd", "kbca",
 					"kbcb", "kbcc", "kbcd", "kbce", "kbcf",
 					"sdc";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_hdint {
 				nvidia,pins = "hdint", "lcsn", "ldc", "lm1",
 					"lpw1", "lsc1", "lsck", "lsda", "lsdi",
 					"lvp0", "owc", "sdb";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_irrx {
 				nvidia,pins = "irrx", "irtx", "sdd", "spic",
 					"spie", "spih", "uaa", "uab", "uad",
 					"uca", "ucb";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_lc {
 				nvidia,pins = "lc", "ls";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			conf_ld0 {
 				nvidia,pins = "ld0", "ld1", "ld2", "ld3", "ld4",
@@ -229,12 +229,12 @@
 					"lhp1", "lhp2", "lhs", "lm0", "lpp",
 					"lpw0", "lpw2", "lsc0", "lspi", "lvp1",
 					"lvs", "pmc";
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ld17_0 {
 				nvidia,pins = "ld17_0", "ld19_18", "ld21_20",
 					"ld23_22";
-				nvidia,pull = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 78deea5..7d651a6 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -191,49 +191,49 @@
 					"dtb", "dtc", "dtd", "dte", "gmb",
 					"gme", "i2cp", "pta", "slxc", "slxd",
 					"spdi", "spdo", "uda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_atb {
 				nvidia,pins = "atb", "cdev1", "cdev2", "dap1",
 					"gma", "gmc", "gmd", "gpu", "gpu7",
 					"gpv", "sdio1", "slxa", "slxk", "uac";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ck32 {
 				nvidia,pins = "ck32", "ddrc", "pmca", "pmcb",
 					"pmcc", "pmcd", "pmce", "xm2c", "xm2d";
-				nvidia,pull = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 			};
 			conf_csus {
 				nvidia,pins = "csus", "spia", "spib",
 					"spid", "spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ddc {
 				nvidia,pins = "ddc", "dtf", "rm", "sdc", "sdd";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_hdint {
 				nvidia,pins = "hdint", "lcsn", "ldc", "lm1",
 					"lpw1", "lsc1", "lsck", "lsda", "lsdi",
 					"lvp0", "pmc";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_irrx {
 				nvidia,pins = "irrx", "irtx", "kbca", "kbcb",
 					"kbcc", "kbcd", "kbce", "kbcf", "owc",
 					"spic", "spie", "spig", "spih", "uaa",
 					"uab", "uad", "uca", "ucb";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_lc {
 				nvidia,pins = "lc", "ls";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			conf_ld0 {
 				nvidia,pins = "ld0", "ld1", "ld2", "ld3", "ld4",
@@ -243,17 +243,17 @@
 					"lhp1", "lhp2", "lhs", "lm0", "lpp",
 					"lpw0", "lpw2", "lsc0", "lspi", "lvp1",
 					"lvs", "sdb";
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ld17_0 {
 				nvidia,pins = "ld17_0", "ld19_18", "ld21_20",
 					"ld23_22";
-				nvidia,pull = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
 			};
 			conf_spif {
 				nvidia,pins = "spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index aab872c..81d0fc4 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -189,50 +189,50 @@
 					"irtx", "pta", "rm", "sdc", "sdd",
 					"slxc", "slxd", "slxk", "spdi", "spdo",
 					"uac", "uad", "uca", "ucb", "uda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ate {
 				nvidia,pins = "ate", "csus", "dap3", "gmd",
 					"gpv", "owc", "spia", "spib", "spic",
 					"spid", "spie", "spig";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ck32 {
 				nvidia,pins = "ck32", "ddrc", "pmca", "pmcb",
 					"pmcc", "pmcd", "pmce", "xm2c", "xm2d";
-				nvidia,pull = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 			};
 			conf_crtp {
 				nvidia,pins = "crtp", "gmb", "slxa", "spih";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_dta {
 				nvidia,pins = "dta", "dtb", "dtc", "dtd";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_dte {
 				nvidia,pins = "dte", "spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_hdint {
 				nvidia,pins = "hdint", "lcsn", "ldc", "lm1",
 					"lpw1", "lsck", "lsda", "lsdi", "lvp0";
-				nvidia,tristate = <1>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_kbca {
 				nvidia,pins = "kbca", "kbcb", "kbcc", "kbcd",
 					"kbce", "kbcf", "sdio1", "uaa", "uab";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_lc {
 				nvidia,pins = "lc", "ls";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			conf_ld0 {
 				nvidia,pins = "ld0", "ld1", "ld2", "ld3", "ld4",
@@ -242,22 +242,22 @@
 					"lhp1", "lhp2", "lhs", "lm0", "lpp",
 					"lpw0", "lpw2", "lsc0", "lsc1", "lspi",
 					"lvp1", "lvs", "pmc", "sdb";
-				nvidia,tristate = <0>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_ld17_0 {
 				nvidia,pins = "ld17_0", "ld19_18", "ld21_20",
 					"ld23_22";
-				nvidia,pull = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
 			};
 			drive_sdio1 {
 				nvidia,pins = "drive_sdio1";
-				nvidia,high-speed-mode = <0>;
-				nvidia,schmitt = <1>;
-				nvidia,low-power-mode = <3>;
+				nvidia,high-speed-mode = <TEGRA_PIN_DISABLE>;
+				nvidia,schmitt = <TEGRA_PIN_ENABLE>;
+				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_1>;
 				nvidia,pull-down-strength = <31>;
 				nvidia,pull-up-strength = <31>;
-				nvidia,slew-rate-rising = <3>;
-				nvidia,slew-rate-falling = <3>;
+				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_SLOWEST>;
+				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_SLOWEST>;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index d33a73c..d26cfcf 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -189,8 +189,8 @@
 					"kbcf", "sdc", "sdd", "spie", "spig",
 					"spih", "uaa", "uab", "uad", "uca",
 					"ucb";
-				nvidia,pull = <2>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_atd {
 				nvidia,pins = "atd", "ate", "cdev1", "csus",
@@ -198,54 +198,54 @@
 					"dtf", "gpu", "gpu7", "gpv", "i2cp",
 					"rm", "sdio1", "slxa", "slxc", "slxd",
 					"slxk", "spdi", "spdo", "uac", "uda";
-				nvidia,pull = <0>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_cdev2 {
 				nvidia,pins = "cdev2", "spia", "spib";
-				nvidia,pull = <1>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ck32 {
 				nvidia,pins = "ck32", "ddrc", "lc", "pmca",
 					"pmcb", "pmcc", "pmcd", "xm2c",
 					"xm2d";
-				nvidia,pull = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 			};
 			conf_crtp {
 				nvidia,pins = "crtp";
-				nvidia,pull = <0>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_dta {
 				nvidia,pins = "dta", "dtb", "dtc", "dtd",
 					"spid", "spif";
-				nvidia,pull = <1>;
-				nvidia,tristate = <0>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
+				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			conf_gme {
 				nvidia,pins = "gme", "owc", "pta", "spic";
-				nvidia,pull = <2>;
-				nvidia,tristate = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
+				nvidia,tristate = <TEGRA_PIN_ENABLE>;
 			};
 			conf_ld17_0 {
 				nvidia,pins = "ld17_0", "ld19_18", "ld21_20",
 					"ld23_22";
-				nvidia,pull = <1>;
+				nvidia,pull = <TEGRA_PIN_PULL_DOWN>;
 			};
 			conf_ls {
 				nvidia,pins = "ls", "pmce";
-				nvidia,pull = <2>;
+				nvidia,pull = <TEGRA_PIN_PULL_UP>;
 			};
 			drive_dap1 {
 				nvidia,pins = "drive_dap1";
-				nvidia,high-speed-mode = <0>;
-				nvidia,schmitt = <1>;
-				nvidia,low-power-mode = <0>;
+				nvidia,high-speed-mode = <TEGRA_PIN_DISABLE>;
+				nvidia,schmitt = <TEGRA_PIN_ENABLE>;
+				nvidia,low-power-mode = <TEGRA_PIN_LP_DRIVE_DIV_8>;
 				nvidia,pull-down-strength = <0>;
 				nvidia,pull-up-strength = <0>;
-				nvidia,slew-rate-rising = <0>;
-				nvidia,slew-rate-falling = <0>;
+				nvidia,slew-rate-rising = <TEGRA_PIN_SLEW_RATE_FASTEST>;
+				nvidia,slew-rate-falling = <TEGRA_PIN_SLEW_RATE_FASTEST>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index df40b54..1de4171 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -1,5 +1,6 @@
 #include <dt-bindings/clock/tegra20-car.h>
 #include <dt-bindings/gpio/tegra-gpio.h>
+#include <dt-bindings/pinctrl/pinctrl-tegra.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
 
 #include "skeleton.dtsi"
-- 
1.7.1.1

