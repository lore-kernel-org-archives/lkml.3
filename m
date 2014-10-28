Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaJ1XQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:16:36 -0400
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:3848 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaJ1XPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:15:30 -0400
X-IronPort-AV: E=Sophos;i="5.04,805,1406617200"; 
   d="scan'208";a="49582143"
From: Scott Branden <sbranden@broadcom.com>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <bcm-kernel-feedback-list@broadcom.com>,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
CC: JD Zheng <jdzheng@broadcom.com>, Ray Jui <rjui@broadcom.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Scott Branden <sbranden@broadcom.com>
Subject: [PATCH v9 8/8] ARM: multi_v7_defconfig: Enable Broadcom Cygnus
Date: Tue, 28 Oct 2014 16:15:11 -0700
Message-ID: <1414538111-11668-9-git-send-email-sbranden@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414538111-11668-1-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
 <1414538111-11668-1-git-send-email-sbranden@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ray Jui <rjui@broadcom.com>

Enable Broadcom Cygnus platform support in multi_v7_defconfig

Signed-off-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Scott Branden <sbranden@broadcom.com>
---
 arch/arm/configs/multi_v7_defconfig |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 6e0d7cb..c72afb1 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -17,6 +17,7 @@ CONFIG_MACH_ARMADA_38X=y
 CONFIG_MACH_ARMADA_XP=y
 CONFIG_MACH_DOVE=y
 CONFIG_ARCH_BCM=y
+CONFIG_ARCH_BCM_CYGNUS=y
 CONFIG_ARCH_BCM_21664=y
 CONFIG_ARCH_BCM_281XX=y
 CONFIG_ARCH_BCM_5301X=y
@@ -125,8 +126,12 @@ CONFIG_DMA_CMA=y
 CONFIG_CMA_SIZE_MBYTES=64
 CONFIG_OMAP_OCP2SCP=y
 CONFIG_MTD=y
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_BLOCK=y
 CONFIG_MTD_M25P80=y
+CONFIG_MTD_NAND=y
 CONFIG_MTD_SPI_NOR=y
+CONFIG_MTD_UBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_AD525X_DPOT=y
 CONFIG_AD525X_DPOT_I2C=y
@@ -161,6 +166,7 @@ CONFIG_TI_CPSW=y
 CONFIG_XILINX_EMACLITE=y
 CONFIG_AT803X_PHY=y
 CONFIG_MARVELL_PHY=y
+CONFIG_BROADCOM_PHY=y
 CONFIG_ICPLUS_PHY=y
 CONFIG_USB_PEGASUS=y
 CONFIG_USB_USBNET=y
@@ -234,6 +240,7 @@ CONFIG_SPI_TEGRA114=y
 CONFIG_SPI_TEGRA20_SFLASH=y
 CONFIG_SPI_TEGRA20_SLINK=y
 CONFIG_SPI_XILINX=y
+CONFIG_SPI_SPIDEV=y
 CONFIG_PINCTRL_AS3722=y
 CONFIG_PINCTRL_PALMAS=y
 CONFIG_GPIO_SYSFS=y
@@ -260,6 +267,7 @@ CONFIG_ST_THERMAL_SYSCFG=y
 CONFIG_ST_THERMAL_MEMMAP=y
 CONFIG_WATCHDOG=y
 CONFIG_XILINX_WATCHDOG=y
+CONFIG_ARM_SP805_WATCHDOG=y
 CONFIG_ORION_WATCHDOG=y
 CONFIG_SUNXI_WATCHDOG=y
 CONFIG_MESON_WATCHDOG=y
@@ -307,6 +315,8 @@ CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
 CONFIG_SOUND=y
 CONFIG_SND=y
+CONFIG_SND_DYNAMIC_MINORS=y
+CONFIG_SND_USB_AUDIO=y
 CONFIG_SND_SOC=y
 CONFIG_SND_SOC_TEGRA=y
 CONFIG_SND_SOC_TEGRA_RT5640=y
@@ -429,7 +439,12 @@ CONFIG_TI_PIPE3=y
 CONFIG_PHY_MIPHY365X=y
 CONFIG_PHY_SUN4I_USB=y
 CONFIG_EXT4_FS=y
+CONFIG_AUTOFS4_FS=y
+CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
+CONFIG_NTFS_FS=y
+CONFIG_TMPFS_POSIX_ACL=y
+CONFIG_UBIFS_FS=y
 CONFIG_TMPFS=y
 CONFIG_SQUASHFS=y
 CONFIG_SQUASHFS_LZO=y
@@ -438,6 +453,9 @@ CONFIG_NFS_FS=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_UTF8=y
 CONFIG_PRINTK_TIME=y
 CONFIG_DEBUG_FS=y
 CONFIG_MAGIC_SYSRQ=y
-- 
1.7.9.5

