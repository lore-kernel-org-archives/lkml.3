Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3CXOZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:25:43 -0400
Received: from norkia.v3.sk ([91.210.183.14]:50038 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3CXOZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:25:42 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH v2] arm: Add Broadcom BCM2835 watchdog timer driver to bcm2835_defconfig
Date: Sun, 24 Mar 2013 15:25:37 +0100
Message-Id: <1364135137-26691-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1364134973-26592-1-git-send-email-lkundrak@v3.sk>
References: <1364134973-26592-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables a driver for watchdog timer hardware present on Broadcom BCM2835 SoC,
used in Raspberry Pi and Roku 2 devices.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-rpi-kernel@lists.infradead.org
---
Changes for v2:
    - Split out from the driver changeset
    - Regenerated with savedefconfig

 arch/arm/configs/bcm2835_defconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index 611bda2..729adf2 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -66,6 +66,8 @@ CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BCM2835=y
 CONFIG_GPIO_SYSFS=y
 # CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+CONFIG_BCM2835_WDT=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_MMC=y
 CONFIG_MMC_SDHCI=y
-- 
1.7.1

