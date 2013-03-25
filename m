Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3CYILp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:11:45 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:58157 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab3CYILo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:11:44 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, arnd@arndb.de,
        olof@lixom.net, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH] arm: vt8500: Add wm8850 config options to multi_v7_defconfig
Date: Mon, 25 Mar 2013 21:11:40 +1300
Message-Id: <1364199100-12300-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch finally adds the WM8850 SoC to the multi_v7_defconfig.
We don't have a seperate defconfig for this SoC as it is only
available as a multiplatform option.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/configs/multi_v7_defconfig |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index e31d442..206119c 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -7,6 +7,7 @@ CONFIG_MACH_ARMADA_XP=y
 CONFIG_ARCH_HIGHBANK=y
 CONFIG_ARCH_SOCFPGA=y
 CONFIG_ARCH_SUNXI=y
+CONFIG_ARCH_WM8850=y
 # CONFIG_ARCH_VEXPRESS_CORTEX_A5_A9_ERRATA is not set
 CONFIG_ARCH_ZYNQ=y
 CONFIG_ARM_ERRATA_754322=y
@@ -34,6 +35,8 @@ CONFIG_SERIAL_8250_DW=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_SERIAL_VT8500=y
+CONFIG_SERIAL_VT8500_CONSOLE=y
 CONFIG_IPMI_HANDLER=y
 CONFIG_IPMI_SI=y
 CONFIG_I2C=y
@@ -42,6 +45,7 @@ CONFIG_SPI=y
 CONFIG_SPI_PL022=y
 CONFIG_FB=y
 CONFIG_FB_ARMCLCD=y
+CONFIG_FB_WM8505=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_USB=y
 CONFIG_USB_ISP1760_HCD=y
@@ -50,11 +54,15 @@ CONFIG_MMC=y
 CONFIG_MMC_ARMMMCI=y
 CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SDHCI_PLTFM=y
+CONFIG_MMC_WMT=y
 CONFIG_EDAC=y
 CONFIG_EDAC_MM_EDAC=y
 CONFIG_EDAC_HIGHBANK_MC=y
 CONFIG_EDAC_HIGHBANK_L2=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PL031=y
+CONFIG_RTC_DRV_VT8500=y
+CONFIG_PWM=y
+CONFIG_PWM_VT8500=y
 CONFIG_DMADEVICES=y
 CONFIG_PL330_DMA=y
-- 
1.7.9.5

