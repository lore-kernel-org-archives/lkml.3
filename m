Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621Ab3BNTyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:54:43 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15616 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3BNTym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:54:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 14 Feb 2013 11:53:29 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <pdeschrijver@nvidia.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Simon Glass <sjg@chromium.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/2] ARM: tegra114: create a DT header defining CLK IDs
Date: Thu, 14 Feb 2013 21:54:00 +0200
Message-ID: <1360871650-25771-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To replace magic number in tegra_car:

-               clocks = <&tegra_car 28>;
+               clocks = <&tegra_car CLK_HOST1X>;

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
Depends on:
  [PATCH v6 00/10] Tegra114 clockframework
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/148895.html

Ran the same script with some modification:
  [v2 0/4] ARM: tegra: convert device tree files to use CLK defines
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149816.html
---
 arch/arm/boot/dts/tegra114-car.h |  179 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 179 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra114-car.h

diff --git a/arch/arm/boot/dts/tegra114-car.h b/arch/arm/boot/dts/tegra114-car.h
new file mode 100644
index 0000000..addb0bf
--- /dev/null
+++ b/arch/arm/boot/dts/tegra114-car.h
@@ -0,0 +1,179 @@
+#define CLK_RTC 4
+#define CLK_TIMER 5
+#define CLK_UARTA 6
+#define CLK_SDMMC2 9
+#define CLK_I2S1 11
+#define CLK_I2C1 12
+#define CLK_NDFLASH 13
+#define CLK_SDMMC1 14
+#define CLK_SDMMC4 15
+#define CLK_PWM 17
+#define CLK_I2S2 18
+#define CLK_EPP 19
+#define CLK_GR_2D 21
+#define CLK_USBD 22
+#define CLK_ISP 23
+#define CLK_GR_3D 24
+#define CLK_DISP2 26
+#define CLK_DISP1 27
+#define CLK_HOST1X 28
+#define CLK_VCP 29
+#define CLK_I2S0 30
+#define CLK_APBDMA 34
+#define CLK_KBC 36
+#define CLK_KFUSE 40
+#define CLK_SBC1 41
+#define CLK_NOR 42
+#define CLK_SBC2 44
+#define CLK_SBC3 46
+#define CLK_I2C5 47
+#define CLK_DSIA 48
+#define CLK_MIPI 50
+#define CLK_HDMI 51
+#define CLK_CSI 52
+#define CLK_I2C2 54
+#define CLK_UARTC 55
+#define CLK_MIPI_CAL 56
+#define CLK_USB2 58
+#define CLK_USB3 59
+#define CLK_VDE 61
+#define CLK_BSEA 62
+#define CLK_BSEV 63
+#define CLK_UARTD 65
+#define CLK_UARTE 66
+#define CLK_I2C3 67
+#define CLK_SBC4 68
+#define CLK_SDMMC3 69
+#define CLK_OWR 71
+#define CLK_CSITE 73
+#define CLK_LA 76
+#define CLK_TRACE 77
+#define CLK_SOC_THERM 78
+#define CLK_DTV 79
+#define CLK_NDSPEED 80
+#define CLK_I2CSLOW 81
+#define CLK_DSIB 82
+#define CLK_TSEC 83
+#define CLK_XUSB_HOST 89
+#define CLK_MSENC 91
+#define CLK_CSUS 92
+#define CLK_MSELECT 99
+#define CLK_TSENSOR 100
+#define CLK_I2S3 101
+#define CLK_I2S4 102
+#define CLK_I2C4 103
+#define CLK_SBC5 104
+#define CLK_SBC6 105
+#define CLK_APBIF 107
+#define CLK_D_AUDIO 108
+#define CLK_DAM0 109
+#define CLK_DAM1 110
+#define CLK_DAM2 111
+#define CLK_HDA2CODEC_2X 111
+#define CLK_AUDIO0_2X 113
+#define CLK_AUDIO1_2X 114
+#define CLK_AUDIO2_2X 115
+#define CLK_AUDIO3_2X 116
+#define CLK_AUDIO4_2X 117
+#define CLK_SPDIF_2X 118
+#define CLK_ACTMON 119
+#define CLK_EXTERN1 120
+#define CLK_EXTERN2 121
+#define CLK_EXTERN3 122
+#define CLK_HDA 125
+#define CLK_SE 127
+#define CLK_HDA2HDMI 128
+#define CLK_CILAB 144
+#define CLK_CILCD 145
+#define CLK_CILE 146
+#define CLK_DSIALP 147
+#define CLK_DSIBLP 148
+#define CLK_DDS 150
+#define CLK_DP2 152
+#define CLK_AMX 153
+#define CLK_ADX 154
+#define CLK_XUSB_SS 156
+#define CLK_UARTB 192
+#define CLK_VFIR 193
+#define CLK_SPDIF_IN 194
+#define CLK_SPDIF_OUT 195
+#define CLK_VI 196
+#define CLK_VI_SENSOR 197
+#define CLK_FUSE 198
+#define CLK_FUSE_BURN 199
+#define CLK_CLK_32K 200
+#define CLK_CLK_M 201
+#define CLK_CLK_M_DIV2 202
+#define CLK_CLK_M_DIV4 203
+#define CLK_PLL_REF 204
+#define CLK_PLL_C 205
+#define CLK_PLL_C_OUT1 206
+#define CLK_PLL_C2 207
+#define CLK_PLL_C3 208
+#define CLK_PLL_M 209
+#define CLK_PLL_M_OUT1 210
+#define CLK_PLL_P 211
+#define CLK_PLL_P_OUT1 212
+#define CLK_PLL_P_OUT2 213
+#define CLK_PLL_P_OUT3 214
+#define CLK_PLL_P_OUT4 215
+#define CLK_PLL_A 216
+#define CLK_PLL_A_OUT0 217
+#define CLK_PLL_D 218
+#define CLK_PLL_D_OUT0 219
+#define CLK_PLL_D2 220
+#define CLK_PLL_D2_OUT0 221
+#define CLK_PLL_U 222
+#define CLK_PLL_U_480M 223
+#define CLK_PLL_U_60M 224
+#define CLK_PLL_U_48M 225
+#define CLK_PLL_U_12M 226
+#define CLK_PLL_X 227
+#define CLK_PLL_X_OUT0 228
+#define CLK_PLL_RE_VCO 229
+#define CLK_PLL_RE_OUT 230
+#define CLK_PLL_E_OUT0 231
+#define CLK_SPDIF_IN_SYNC 232
+#define CLK_I2S0_SYNC 233
+#define CLK_I2S1_SYNC 234
+#define CLK_I2S2_SYNC 235
+#define CLK_I2S3_SYNC 236
+#define CLK_I2S4_SYNC 237
+#define CLK_VIMCLK_SYNC 238
+#define CLK_AUDIO0 239
+#define CLK_AUDIO1 240
+#define CLK_AUDIO2 241
+#define CLK_AUDIO3 242
+#define CLK_AUDIO4 243
+#define CLK_SPDIF 244
+#define CLK_CLK_OUT_1 245
+#define CLK_CLK_OUT_2 246
+#define CLK_CLK_OUT_3 247
+#define CLK_BLINK 248
+#define CLK_MIPI_CAL_FAST 214
+#define CLK_DSI1_FIXED 214
+#define CLK_DSI2_FIXED 214
+#define CLK_XUSB_HOST_SRC 215
+#define CLK_XUSB_FALCON_SRC 216
+#define CLK_XUSB_FS_SRC 217
+#define CLK_XUSB_SS_SRC 218
+#define CLK_XUSB_DEV_SRC 219
+#define CLK_XUSB_DEV 220
+#define CLK_XUSB_HS_SRC 221
+#define CLK_SCLK 222
+#define CLK_HCLK 223
+#define CLK_PCLK 224
+#define CLK_CCLK_G 225
+#define CLK_CCLK_LP 226
+#define CLK_AUDIO0_MUX 300
+#define CLK_AUDIO1_MUX 301
+#define CLK_AUDIO2_MUX 302
+#define CLK_AUDIO3_MUX 303
+#define CLK_AUDIO4_MUX 304
+#define CLK_SPDIF_MUX 305
+#define CLK_CLK_OUT_1_MUX 306
+#define CLK_CLK_OUT_2_MUX 307
+#define CLK_CLK_OUT_3_MUX 308
+#define CLK_DSIA_MUX 309
+#define CLK_DSIB_MUX 310
+#define CLK_CLK_MAX 311
-- 
1.7.9.5

