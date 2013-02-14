Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586Ab3BNTAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:00:18 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10068 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761584Ab3BNTAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:00:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Feb 2013 10:56:15 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v2 1/4] ARM: tegra20: create a DT header defining CLK IDs
Date: Thu, 14 Feb 2013 20:59:15 +0200
Message-ID: <1360868369-20093-2-git-send-email-hdoyu@nvidia.com>
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
 arch/arm/boot/dts/tegra20-car.h |  114 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)
 create mode 100644 arch/arm/boot/dts/tegra20-car.h

diff --git a/arch/arm/boot/dts/tegra20-car.h b/arch/arm/boot/dts/tegra20-car.h
new file mode 100644
index 0000000..0659414
--- /dev/null
+++ b/arch/arm/boot/dts/tegra20-car.h
@@ -0,0 +1,114 @@
+#define CLK_CPU 0
+#define CLK_AC97 3
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
+#define CLK_TWC 16
+#define CLK_PWM 17
+#define CLK_I2S2 18
+#define CLK_EPP 19
+#define CLK_GR2D 21
+#define CLK_USBD 22
+#define CLK_ISP 23
+#define CLK_GR3D 24
+#define CLK_IDE 25
+#define CLK_DISP2 26
+#define CLK_DISP1 27
+#define CLK_HOST1X 28
+#define CLK_VCP 29
+#define CLK_CACHE2 31
+#define CLK_MEM 32
+#define CLK_AHBDMA 33
+#define CLK_APBDMA 34
+#define CLK_KBC 36
+#define CLK_STAT_MON 37
+#define CLK_PMC 38
+#define CLK_FUSE 39
+#define CLK_KFUSE 40
+#define CLK_SBC1 41
+#define CLK_NOR 42
+#define CLK_SPI 43
+#define CLK_SBC2 44
+#define CLK_XIO 45
+#define CLK_SBC3 46
+#define CLK_DVC 47
+#define CLK_DSI 48
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
+#define CLK_PEX 70
+#define CLK_OWR 71
+#define CLK_AFI 72
+#define CLK_CSITE 73
+#define CLK_PCIE_XCLK 74
+#define CLK_AVPUCQ 75
+#define CLK_LA 76
+#define CLK_IRAMA 84
+#define CLK_IRAMB 85
+#define CLK_IRAMC 86
+#define CLK_IRAMD 87
+#define CLK_CRAM2 88
+#define CLK_AUDIO_2X 89
+#define CLK_CLK_D 90
+#define CLK_CSUS 92
+#define CLK_CDEV1 93
+#define CLK_CDEV2 94
+#define CLK_UARTB 96
+#define CLK_VFIR 97
+#define CLK_SPDIF_IN 98
+#define CLK_SPDIF_OUT 99
+#define CLK_VI 100
+#define CLK_VI_SENSOR 101
+#define CLK_TVO 102
+#define CLK_CVE 103
+#define CLK_OSC 104
+#define CLK_CLK_32K 105
+#define CLK_CLK_M 106
+#define CLK_SCLK 107
+#define CLK_CCLK 108
+#define CLK_HCLK 109
+#define CLK_PCLK 110
+#define CLK_BLINK 111
+#define CLK_PLL_A 112
+#define CLK_PLL_A_OUT0 113
+#define CLK_PLL_C 114
+#define CLK_PLL_C_OUT1 115
+#define CLK_PLL_D 116
+#define CLK_PLL_D_OUT0 117
+#define CLK_PLL_E 118
+#define CLK_PLL_M 119
+#define CLK_PLL_M_OUT1 120
+#define CLK_PLL_P 121
+#define CLK_PLL_P_OUT1 122
+#define CLK_PLL_P_OUT2 123
+#define CLK_PLL_P_OUT3 124
+#define CLK_PLL_P_OUT4 125
+#define CLK_PLL_U 126
+#define CLK_PLL_X 127
+#define CLK_AUDIO 128
+#define CLK_PLL_REF 129
+#define CLK_TWD 130
+#define CLK_CLK_MAX 131
-- 
1.7.9.5

