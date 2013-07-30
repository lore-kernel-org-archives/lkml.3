Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3G3KxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:53:00 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2684 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3G3Kw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:52:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 30 Jul 2013 03:51:33 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linus.walleij@linaro.org>, <linux-doc@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] pinctrl: tegra: add valid function name on DT document
Date: Tue, 30 Jul 2013 16:34:21 +0530
Message-ID: <1375182261-30946-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add valid property name for the property "nvidia,function" in
DT binding document of Tegra pincontrol.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 .../bindings/pinctrl/nvidia,tegra114-pinmux.txt    |   10 ++++++++++
 .../bindings/pinctrl/nvidia,tegra20-pinmux.txt     |   11 +++++++++++
 .../bindings/pinctrl/nvidia,tegra30-pinmux.txt     |   11 +++++++++++
 3 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra114-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra114-pinmux.txt
index e204d00..b28bdee 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra114-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra114-pinmux.txt
@@ -69,6 +69,16 @@ Valid values for pin and group names are:
     gpio_w2_aud_pw2, gpio_w3_aud_pw3, usb_vbus_en0_pn4, usb_vbus_en1_pn5,
     sdmmc3_clk_lb_in_pee5, sdmmc3_clk_lb_out_pee4, reset_out_n.
 
+The valid names for the nvidia,functions are:
+    blink, cec, cldvfs, clk12, cpu, dap, dap1, dap2, dev3, displaya,
+    displaya_alt, displayb, dtv, emc_dll, extperiph1, extperiph2,
+    extperiph3, gmi, gmi_alt, hda, hsi, i2c1, i2c2, i2c3, i2c4, i2cpwr,
+    i2s0, i2s1, i2s2, i2s3, i2s4, irda, kbc, nand, nand_alt, owr, pmi,
+    pwm0, pwm1, pwm2, pwm3, pwron, reset_out_n, rsvd1, rsvd2, rsvd3,
+    rsvd4, sdmmc1, sdmmc2, sdmmc3, sdmmc4, soc, spdif, spi1, spi2, spi3,
+    spi4, spi5, spi6, sysclk, trace, uarta, uartb, uartc, uartd, ulpi,
+    usb, vgp1, vgp2, vgp3, vgp4, vgp5, vgp6, vi, vi_alt1, vi_alt3
+
   drive groups:
 
     These all support nvidia,pull-down-strength, nvidia,pull-up-strength,
diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
index 683fde9..ba6f2c4 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra20-pinmux.txt
@@ -82,6 +82,7 @@ Valid values for pin and group names are:
     spdo, spia, spib, spic, spid, spie, spif, spig, spih, uaa, uab, uac, uad,
     uca, ucb, uda.
 
+
   tristate groups:
 
     These only support nvidia,pull.
@@ -103,6 +104,16 @@ Valid values for pin and group names are:
     drive_gma, drive_gmb, drive_gmc, drive_gmd, drive_gme, drive_owr,
     drive_uda.
 
+The valid names for the nvidia,functions are:
+    ahb_clk, apb_clk, audio_sync, crt, dap1, dap2, dap3, dap4, dap5,
+    displaya, displayb, emc_test0_dll, emc_test1_dll, gmi, gmi_int,
+    hdmi, i2cp, i2c1, i2c2, i2c3, ide, irda, kbc, mio, mipi_hs, nand,
+    osc, owr, pcie, plla_out, pllc_out1, pllm_out1, pllp_out2, pllp_out3,
+    pllp_out4, pwm, pwr_intr, pwr_on, rsvd1, rsvd2, rsvd3, rsvd4, rtck,
+    sdio1, sdio2, sdio3, sdio4, sflash, spdif, spi1, spi2, spi2_alt,
+    spi3, spi4, trace, twc, uarta, uartb, uartc, uartd, uarte, ulpi,
+    vi, vi_sensor_clk, xio
+
 Example:
 
 	pinctrl@70000000 {
diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
index 6f426ed..909d491 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra30-pinmux.txt
@@ -80,6 +80,17 @@ Valid values for pin and group names are:
     clk1_req_pee2, hdmi_cec_pee3, clk_32k_in, core_pwr_req, cpu_pwr_req, owr,
     pwr_int_n.
 
+The valid names for the nvidia,functions are:
+    blink, cec, clk_12m_out, clk_32k_in, core_pwr_req, cpu_pwr_req, crt,
+    dap, ddr, dev3, displaya, displayb, dtv, extperiph1, extperiph2,
+    extperiph3, gmi, gmi_alt, hda, hdcp, hdmi, hsi, i2c1, i2c2, i2c3,
+    i2c4, i2cpwr, i2s0, i2s1, i2s2, i2s3, i2s4, invalid, kbc, mio, nand,
+    nand_alt, owr, pcie, pwm0, pwm1, pwm2, pwm3, pwr_int_n, rsvd1, rsvd2,
+    rsvd3, rsvd4, rtck, sata, sdmmc1, sdmmc2, sdmmc3, sdmmc4, spdif, spi1,
+    spi2, spi2_alt, spi3, spi4, spi5, spi6, sysclk, test, trace, uarta,
+    uartb, uartc, uartd, uarte, ulpi, vgp1, vgp2, vgp3, vgp4, vgp5, vgp6,
+    vi, vi_alt1, vi_alt2, vi_alt3
+
   drive groups:
 
     These all support nvidia,pull-down-strength, nvidia,pull-up-strength,
-- 
1.7.1.1

