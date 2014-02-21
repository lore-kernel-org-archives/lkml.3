Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaBUIbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 03:31:25 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:34290 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaBUIbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 03:31:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <damm@opensource.se>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH] ARM: shmobile: koelsch/lager/multi defconfig: Enable MSIOF
Date: Fri, 21 Feb 2014 09:31:12 +0100
Message-Id: <1392971472-21679-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
This should have been part of the series "[PATCH 00/11] ARM: shmobile:
MSIOF integration on r8a7790/lager and r8a7791/koelsch"

 arch/arm/configs/koelsch_defconfig  |    1 +
 arch/arm/configs/lager_defconfig    |    1 +
 arch/arm/configs/shmobile_defconfig |    1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm/configs/koelsch_defconfig b/arch/arm/configs/koelsch_defconfig
index 93919e8c92ce..0c3709e81842 100644
--- a/arch/arm/configs/koelsch_defconfig
+++ b/arch/arm/configs/koelsch_defconfig
@@ -69,6 +69,7 @@ CONFIG_I2C=y
 CONFIG_I2C_RCAR=y
 CONFIG_SPI=y
 CONFIG_SPI_RSPI=y
+CONFIG_SPI_SH_MSIOF=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_RCAR=y
 # CONFIG_HWMON is not set
diff --git a/arch/arm/configs/lager_defconfig b/arch/arm/configs/lager_defconfig
index b17fc23ae676..dfb0c21fb767 100644
--- a/arch/arm/configs/lager_defconfig
+++ b/arch/arm/configs/lager_defconfig
@@ -90,6 +90,7 @@ CONFIG_I2C_GPIO=y
 CONFIG_I2C_RCAR=y
 CONFIG_SPI=y
 CONFIG_SPI_RSPI=y
+CONFIG_SPI_SH_MSIOF=y
 CONFIG_GPIO_SH_PFC=y
 CONFIG_GPIOLIB=y
 CONFIG_GPIO_RCAR=y
diff --git a/arch/arm/configs/shmobile_defconfig b/arch/arm/configs/shmobile_defconfig
index 83b07258a385..2a27d4622cc9 100644
--- a/arch/arm/configs/shmobile_defconfig
+++ b/arch/arm/configs/shmobile_defconfig
@@ -78,6 +78,7 @@ CONFIG_I2C_GPIO=y
 CONFIG_I2C_RCAR=y
 CONFIG_SPI=y
 CONFIG_SPI_RSPI=y
+CONFIG_SPI_SH_MSIOF=y
 CONFIG_GPIO_EM=y
 CONFIG_GPIO_RCAR=y
 # CONFIG_HWMON is not set
-- 
1.7.9.5

