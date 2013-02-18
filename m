Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab3BRNVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:21:09 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:37417 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab3BRNVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:21:07 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: linux@arm.linux.org.uk, tony@atomide.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] ARM: OMAP2+: omap2plus_defconfig: Add support for BMP085 pressure sensor
Date: Mon, 18 Feb 2013 15:20:52 +0200
Message-Id: <1361193652-25313-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables BMP085 pressure sensor that can be
found on OMAP4 Blaze Tablet development platform

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/configs/omap2plus_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
index b16bae2..6a4e9a2 100644
--- a/arch/arm/configs/omap2plus_defconfig
+++ b/arch/arm/configs/omap2plus_defconfig
@@ -93,6 +93,7 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_SENSORS_LIS3LV02D=m
 CONFIG_SENSORS_TSL2550=m
 CONFIG_SENSORS_LIS3_I2C=m
+CONFIG_BMP085_I2C=m
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_MULTI_LUN=y
-- 
1.7.9.5

