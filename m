Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab3CXOlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:41:20 -0400
Received: from norkia.v3.sk ([91.210.183.14]:37552 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab3CXOlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:41:19 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH v2] arm: Add Broadcom BCM2835 RNG driver to bcm2835_defconfig
Date: Sun, 24 Mar 2013 15:41:14 +0100
Message-Id: <1364136074-27884-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1364135980-27750-1-git-send-email-lkundrak@v3.sk>
References: <1364135980-27750-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables a driver for random number generator present on Broadcom BCM2835 SoC,
used in Raspberry Pi and Roku 2 devices.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-rpi-kernel@lists.infradead.org
---
Changes for v2:
    - Split out from the driver changeset

 arch/arm/configs/bcm2835_defconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index af472e4..611bda2 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -59,7 +59,8 @@ CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
 CONFIG_TTY_PRINTK=y
-# CONFIG_HW_RANDOM is not set
+CONFIG_HW_RANDOM=y
+CONFIG_HW_RANDOM_BCM2835=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_BCM2835=y
-- 
1.7.1

