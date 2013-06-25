Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3FYLUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:20:46 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:42175 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752471Ab3FYLUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:20:44 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@stlinux.com,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v5 4/7] ARM:multi_v7_defconfig: rerun savedefconfig
Date: Tue, 25 Jun 2013 12:15:41 +0100
Message-Id: <1372158942-19768-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
References: <1372158822-19160-1-git-send-email-srinivas.kandagatla@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch is generated after re-running savedefconfig on top of
multi_v7_defconfig which gets rid of some of the options, as they are
now slected by mach level or other Kconfigs.

The reason to generate this patch is because, it becomes confusing when
some of these options dissapear as part of new SOC addition to
multi_v7_defconfig.
I wanted this to be in a seperate patch, as these options are not
related any of the new SOC support.

Already some discussion at:https://patchwork.kernel.org/patch/2696481

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 arch/arm/configs/multi_v7_defconfig |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 2e67a27..f2b4957 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1,23 +1,20 @@
-CONFIG_EXPERIMENTAL=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_ARCH_MVEBU=y
 CONFIG_MACH_ARMADA_370=y
-CONFIG_ARCH_SIRF=y
 CONFIG_MACH_ARMADA_XP=y
 CONFIG_ARCH_HIGHBANK=y
 CONFIG_ARCH_SOCFPGA=y
-CONFIG_ARCH_SUNXI=y
-CONFIG_ARCH_WM8850=y
-# CONFIG_ARCH_VEXPRESS_CORTEX_A5_A9_ERRATA is not set
-CONFIG_ARCH_ZYNQ=y
-CONFIG_ARM_ERRATA_754322=y
 CONFIG_PLAT_SPEAR=y
 CONFIG_ARCH_SPEAR13XX=y
 CONFIG_MACH_SPEAR1310=y
 CONFIG_MACH_SPEAR1340=y
+CONFIG_ARCH_SUNXI=y
+CONFIG_ARCH_SIRF=y
+CONFIG_ARCH_WM8850=y
+CONFIG_ARCH_ZYNQ=y
+CONFIG_ARM_ERRATA_754322=y
 CONFIG_SMP=y
-CONFIG_ARM_ARCH_TIMER=y
 CONFIG_AEABI=y
 CONFIG_HIGHMEM=y
 CONFIG_HIGHPTE=y
@@ -27,25 +24,25 @@ CONFIG_NEON=y
 CONFIG_NET=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_ATA=y
+CONFIG_SATA_AHCI_PLATFORM=y
 CONFIG_SATA_HIGHBANK=y
 CONFIG_SATA_MV=y
-CONFIG_SATA_AHCI_PLATFORM=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_CALXEDA_XGMAC=y
 CONFIG_SMSC911X=y
 CONFIG_STMMAC_ETH=y
+CONFIG_KEYBOARD_SPEAR=y
 CONFIG_SERIO_AMBAKMI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_DW=y
-CONFIG_KEYBOARD_SPEAR=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
-CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_SERIAL_SIRFSOC=y
 CONFIG_SERIAL_SIRFSOC_CONSOLE=y
 CONFIG_SERIAL_VT8500=y
 CONFIG_SERIAL_VT8500_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_IPMI_HANDLER=y
 CONFIG_IPMI_SI=y
 CONFIG_I2C=y
@@ -54,7 +51,6 @@ CONFIG_I2C_SIRF=y
 CONFIG_SPI=y
 CONFIG_SPI_PL022=y
 CONFIG_SPI_SIRF=y
-CONFIG_GPIO_PL061=y
 CONFIG_FB=y
 CONFIG_FB_ARMCLCD=y
 CONFIG_FB_WM8505=y
@@ -67,7 +63,6 @@ CONFIG_MMC_ARMMMCI=y
 CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SDHCI_PLTFM=y
 CONFIG_MMC_SDHCI_SPEAR=y
-CONFIG_MMC_WMT=y
 CONFIG_EDAC=y
 CONFIG_EDAC_MM_EDAC=y
 CONFIG_EDAC_HIGHBANK_MC=y
@@ -75,9 +70,9 @@ CONFIG_EDAC_HIGHBANK_L2=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PL031=y
 CONFIG_RTC_DRV_VT8500=y
-CONFIG_PWM=y
-CONFIG_PWM_VT8500=y
 CONFIG_DMADEVICES=y
-CONFIG_PL330_DMA=y
-CONFIG_SIRF_DMA=y
 CONFIG_DW_DMAC=y
+CONFIG_SIRF_DMA=y
+CONFIG_PL330_DMA=y
+CONFIG_PWM=y
+CONFIG_PWM_VT8500=y
-- 
1.7.6.5

