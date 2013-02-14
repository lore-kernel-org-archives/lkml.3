Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197Ab3BNTA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:00:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10232 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965181Ab3BNTA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:00:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 14 Feb 2013 10:59:49 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v2 3/4] ARM: tegra30: create a DT header defining CLK IDs
Date: Thu, 14 Feb 2013 20:59:17 +0200
Message-ID: <1360868369-20093-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com>
References: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com>
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
 arch/arm/boot/dts/tegra30-car.h |  171 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 171 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra30-car.h

diff --git a/arch/arm/boot/dts/tegra30-car.h b/arch/arm/boot/dts/tegra30-car.h
new file mode 100644
index 0000000..96af7b3
--- /dev/null
+++ b/arch/arm/boot/dts/tegra30-car.h
@@ -0,0 +1,171 @@
+#define CLK_CPU 0
+#define CLK_RTC 4
+#define CLK_TIMER 5
+#define CLK_UARTA 6
+#define CLK_GPIO 8
+#define CLK_SDMMC2 9
+#define CLK_I2S1 11
+#define CLK_I2C1 12
+#define CLK_NDFLASH 13
+#define CLK_SDMMC1 14
+#define CLK_SDMMC4 15
+#define CLK_PWM 17
+#define CLK_I2S2 18
+#define CLK_EPP 19
+#define CLK_GR2D 21
+#define CLK_USBD 22
+#define CLK_ISP 23
+#define CLK_GR3D 24
+#define CLK_DISP2 26
+#define CLK_DISP1 27
+#define CLK_HOST1X 28
+#define CLK_VCP 29
+#define CLK_I2S0 30
+#define CLK_COP_CACHE 31
+#define CLK_MC 32
+#define CLK_AHBDMA 33
+#define CLK_APBDMA 34
+#define CLK_KBC 36
+#define CLK_STATMON 37
+#define CLK_PMC 38
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
+#define CLK_TVDAC 53
+#define CLK_I2C2 54
+#define CLK_UARTC 55
+#define CLK_EMC 57
+#define CLK_USB2 58
+#define CLK_USB3 59
+#define CLK_MPE 60
+#define CLK_VDE 61
+#define CLK_BSEA 62
+#define CLK_BSEV 63
+#define CLK_SPEEDO 64
+#define CLK_UARTD 65
+#define CLK_UARTE 66
+#define CLK_I2C3 67
+#define CLK_SBC4 68
+#define CLK_SDMMC3 69
+#define CLK_PCIE 70
+#define CLK_OWR 71
+#define CLK_AFI 72
+#define CLK_CSITE 73
+#define CLK_PCIEX 74
+#define CLK_AVPUCQ 75
+#define CLK_LA 76
+#define CLK_DTV 79
+#define CLK_NDSPEED 80
+#define CLK_I2C_SLOW 81
+#define CLK_DSIB 82
+#define CLK_IRAMA 84
+#define CLK_IRAMB 85
+#define CLK_IRAMC 86
+#define CLK_IRAMD 87
+#define CLK_CRAM2 88
+#define CLK_AUDIO_2X 90
+#define CLK_CSUS 92
+#define CLK_CDEV1 93
+#define CLK_CDEV2 94
+#define CLK_CPU_G 96
+#define CLK_CPU_LP 97
+#define CLK_GR3D2 98
+#define CLK_MSELECT 99
+#define CLK_TSENSOR 100
+#define CLK_I2S3 101
+#define CLK_I2S4 102
+#define CLK_I2C4 103
+#define CLK_SBC5 104
+#define CLK_SBC6 105
+#define CLK_D_AUDIO 106
+#define CLK_APBIF 107
+#define CLK_DAM0 108
+#define CLK_DAM1 109
+#define CLK_DAM2 110
+#define CLK_HDA2CODEC_2X 111
+#define CLK_ATOMICS 112
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
+#define CLK_SATA_OOB 123
+#define CLK_SATA 124
+#define CLK_HDA 125
+#define CLK_SE 127
+#define CLK_HDA2HDMI 128
+#define CLK_SATA_COLD 129
+#define CLK_UARTB 160
+#define CLK_VFIR 161
+#define CLK_SPDIF_OUT 162
+#define CLK_SPDIF_IN 163
+#define CLK_VI 164
+#define CLK_VI_SENSOR 165
+#define CLK_FUSE 166
+#define CLK_FUSE_BURN 167
+#define CLK_CVE 168
+#define CLK_TVO 169
+#define CLK_CLK_32K 170
+#define CLK_CLK_M 171
+#define CLK_CLK_M_DIV2 172
+#define CLK_CLK_M_DIV4 173
+#define CLK_PLL_REF 174
+#define CLK_PLL_C 175
+#define CLK_PLL_C_OUT1 176
+#define CLK_PLL_M 177
+#define CLK_PLL_M_OUT1 178
+#define CLK_PLL_P 179
+#define CLK_PLL_P_OUT1 180
+#define CLK_PLL_P_OUT2 181
+#define CLK_PLL_P_OUT3 182
+#define CLK_PLL_P_OUT4 183
+#define CLK_PLL_A 184
+#define CLK_PLL_A_OUT0 185
+#define CLK_PLL_D 186
+#define CLK_PLL_D_OUT0 187
+#define CLK_PLL_D2 188
+#define CLK_PLL_D2_OUT0 189
+#define CLK_PLL_U 190
+#define CLK_PLL_X 191
+#define CLK_PLL_X_OUT0 192
+#define CLK_PLL_E 193
+#define CLK_SPDIF_IN_SYNC 194
+#define CLK_I2S0_SYNC 195
+#define CLK_I2S1_SYNC 196
+#define CLK_I2S2_SYNC 197
+#define CLK_I2S3_SYNC 198
+#define CLK_I2S4_SYNC 199
+#define CLK_VIMCLK_SYNC 200
+#define CLK_AUDIO0 201
+#define CLK_AUDIO1 202
+#define CLK_AUDIO2 203
+#define CLK_AUDIO3 204
+#define CLK_AUDIO4 205
+#define CLK_SPDIF 206
+#define CLK_CLK_OUT_1 207
+#define CLK_CLK_OUT_2 208
+#define CLK_CLK_OUT_3 209
+#define CLK_SCLK 210
+#define CLK_BLINK 211
+#define CLK_CCLK_G 212
+#define CLK_CCLK_LP 213
+#define CLK_TWD 214
+#define CLK_CML0 215
+#define CLK_CML1 216
+#define CLK_I2CSLOW 217
+#define CLK_HCLK 218
+#define CLK_PCLK 219
+#define CLK_CLK_OUT_1_MUX 300
+#define CLK_CLK_MAX 301
-- 
1.7.9.5

