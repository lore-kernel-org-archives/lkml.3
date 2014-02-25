Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaBYKea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:34:30 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:59403 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbaBYKa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:30:26 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH v2 11/11] ARM: shmobile: koelsch/lager/multi defconfig: Enable MSIOF
Date: Tue, 25 Feb 2014 11:30:19 +0100
Message-Id: <1393324219-3317-12-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
References: <1393324219-3317-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
v2:
  - No changes

 arch/arm/configs/koelsch_defconfig  |    1 +
 arch/arm/configs/lager_defconfig    |    1 +
 arch/arm/configs/shmobile_defconfig |    1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm/configs/koelsch_defconfig b/arch/arm/configs/koelsch_defconfig
index 86faab565a96..f3f08463e2bc 100644
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
index 58702440472a..5ba857317ca5 100644
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

