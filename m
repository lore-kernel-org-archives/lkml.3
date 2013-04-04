Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3DDJFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:05:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14178 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab3DDJFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:05:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 04 Apr 2013 02:04:20 -0700
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH] clk: tegra: Fix cdev1 and cdev2 IDs
Date: Thu, 4 Apr 2013 14:35:04 +0530
Message-ID: <1365066304-2327-1-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct IDs for cdev1 and cdev2 are 94 and 93 respectively.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---

Stephen, tested this patch on Ventana and Cardhu, please verify if
I am not missing any platform which uses cdev1/cdev2.

---
 .../bindings/clock/nvidia,tegra20-car.txt          |    4 ++--
 arch/arm/boot/dts/tegra20-colibri-512.dtsi         |    2 +-
 arch/arm/boot/dts/tegra20-harmony.dts              |    2 +-
 arch/arm/boot/dts/tegra20-medcom-wide.dts          |    2 +-
 arch/arm/boot/dts/tegra20-paz00.dts                |    2 +-
 arch/arm/boot/dts/tegra20-plutux.dts               |    2 +-
 arch/arm/boot/dts/tegra20-seaboard.dts             |    2 +-
 arch/arm/boot/dts/tegra20-tec.dts                  |    2 +-
 arch/arm/boot/dts/tegra20-trimslice.dts            |    2 +-
 arch/arm/boot/dts/tegra20-ventana.dts              |    2 +-
 arch/arm/boot/dts/tegra20-whistler.dts             |    2 +-
 arch/arm/boot/dts/tegra20.dtsi                     |    2 +-
 drivers/clk/tegra/clk-tegra20.c                    |    2 +-
 drivers/clk/tegra/clk-tegra30.c                    |    2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
index 0921fac..e885680 100644
--- a/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
+++ b/Documentation/devicetree/bindings/clock/nvidia,tegra20-car.txt
@@ -120,8 +120,8 @@ Required properties :
   90	clk_d
   91	unassigned
   92	sus
-  93	cdev1
-  94	cdev2
+  93	cdev2
+  94	cdev1
   95	unassigned
 
   96	uart2
diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index 79af149..7e96750 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -461,7 +461,7 @@
 
 		nvidia,ac97-controller = <&ac97>;
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 
diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 5fb0888..c108dc8 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -657,7 +657,7 @@
 		nvidia,int-mic-en-gpios = <&gpio 184 0>; /*gpio PX0 */
 		nvidia,ext-mic-en-gpios = <&gpio 185 0>; /* gpio PX1 */
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-medcom-wide.dts b/arch/arm/boot/dts/tegra20-medcom-wide.dts
index 740ba7c..ace2343 100644
--- a/arch/arm/boot/dts/tegra20-medcom-wide.dts
+++ b/arch/arm/boot/dts/tegra20-medcom-wide.dts
@@ -59,7 +59,7 @@
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
 		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 43fd28b..59bd476 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -502,7 +502,7 @@
 		nvidia,i2s-controller = <&tegra_i2s1>;
 		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-plutux.dts b/arch/arm/boot/dts/tegra20-plutux.dts
index 7085ae5..1a17cc3 100644
--- a/arch/arm/boot/dts/tegra20-plutux.dts
+++ b/arch/arm/boot/dts/tegra20-plutux.dts
@@ -53,7 +53,7 @@
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
 		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index 4f810a5..926cc6c 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -809,7 +809,7 @@
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
 		nvidia,hp-det-gpios = <&gpio 185 0>; /* gpio PX1 */
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegra20-tec.dts
index 9be175d..742f0b3 100644
--- a/arch/arm/boot/dts/tegra20-tec.dts
+++ b/arch/arm/boot/dts/tegra20-tec.dts
@@ -53,7 +53,7 @@
 		nvidia,spkr-en-gpios = <&wm8903 2 0>;
 		nvidia,hp-det-gpios = <&gpio 178 0>; /* gpio PW2 */
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-trimslice.dts b/arch/arm/boot/dts/tegra20-trimslice.dts
index 955bf49..e703d73 100644
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@ -364,7 +364,7 @@
 		nvidia,i2s-controller = <&tegra_i2s1>;
 		nvidia,audio-codec = <&codec>;
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index 3f8ae10..02443be 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -608,7 +608,7 @@
 		nvidia,int-mic-en-gpios = <&gpio 184 0>; /* gpio PX0 */
 		nvidia,ext-mic-en-gpios = <&gpio 185 0>; /* gpio PX1 */
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index 87e2d85..988e2d4 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -561,7 +561,7 @@
 		nvidia,i2s-controller = <&tegra_i2s1>;
 		nvidia,audio-codec = <&codec>;
 
-		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 93>;
+		clocks = <&tegra_car 112>, <&tegra_car 113>, <&tegra_car 94>;
 		clock-names = "pll_a", "pll_a_out0", "mclk";
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 26c1134..b788950 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -476,7 +476,7 @@
 		compatible = "nvidia,tegra20-usb-phy";
 		reg = <0xc5004400 0x3c00>;
 		phy_type = "ulpi";
-		clocks = <&tegra_car 94>, <&tegra_car 127>;
+		clocks = <&tegra_car 93>, <&tegra_car 127>;
 		clock-names = "phy", "pll_u";
 	};
 
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index b020beb..b324d3f 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -236,7 +236,7 @@ enum tegra20_clk {
 	dvc, dsi, mipi = 50, hdmi, csi, tvdac, i2c2, uartc, emc = 57, usb2,
 	usb3, mpe, vde, bsea, bsev, speedo, uartd, uarte, i2c3, sbc4, sdmmc3,
 	pex, owr, afi, csite, pcie_xclk, avpucq = 75, la, irama = 84, iramb,
-	iramc, iramd, cram2, audio_2x, clk_d, csus = 92, cdev1, cdev2,
+	iramc, iramd, cram2, audio_2x, clk_d, csus = 92, cdev2, cdev1,
 	uartb = 96, vfir, spdif_in, spdif_out, vi, vi_sensor, tvo, cve,
 	osc, clk_32k, clk_m, sclk, cclk, hclk, pclk, blink, pll_a, pll_a_out0,
 	pll_c, pll_c_out1, pll_d, pll_d_out0, pll_e, pll_m, pll_m_out1,
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index a0c54ad..0681935 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -329,7 +329,7 @@ enum tegra30_clk {
 	usb3, mpe, vde, bsea, bsev, speedo, uartd, uarte, i2c3, sbc4, sdmmc3,
 	pcie, owr, afi, csite, pciex, avpucq, la, dtv = 79, ndspeed, i2cslow,
 	dsib, irama = 84, iramb, iramc, iramd, cram2, audio_2x = 90, csus = 92,
-	cdev1, cdev2, cpu_g = 96, cpu_lp, gr3d2, mselect, tsensor, i2s3, i2s4,
+	cdev2, cdev1, cpu_g = 96, cpu_lp, gr3d2, mselect, tsensor, i2s3, i2s4,
 	i2c4, sbc5, sbc6, d_audio, apbif, dam0, dam1, dam2, hda2codec_2x,
 	atomics, audio0_2x, audio1_2x, audio2_2x, audio3_2x, audio4_2x,
 	spdif_2x, actmon, extern1, extern2, extern3, sata_oob, sata, hda,
-- 
1.7.4.1

