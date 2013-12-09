Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511Ab3LIEip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:38:45 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60882 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760260Ab3LIEin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:38:43 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: SAMSUNG: remove unused SAMSUNG_GPIOLIB_4BIT Kconfig parameter
Date: Mon,  9 Dec 2013 05:38:27 +0100
Message-Id: <1386563907-18808-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <000001ced94433863209a92960$%han@samsung.com>
References: <000001ced94433863209a92960$%han@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the SAMSUNG_GPIOLIB_4BIT Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/Kconfig              | 1 -
 arch/arm/plat-samsung/Kconfig | 8 --------
 2 files changed, 9 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7eee953..5e227a371401 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -740,7 +740,6 @@ config ARCH_S3C64XX
 	select S3C_DEV_NAND
 	select S3C_GPIO_TRACK
 	select SAMSUNG_ATAGS
-	select SAMSUNG_GPIOLIB_4BIT
 	select SAMSUNG_WAKEMASK
 	select SAMSUNG_WDT_RESET
 	select USB_ARCH_HAS_OHCI
diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 6d95d60276d6..58645a58d0d8 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -24,7 +24,6 @@ config PLAT_S5P
 	select S3C_GPIO_TRACK
 	select S5P_GPIO_DRVSTR
 	select SAMSUNG_CLKSRC if !COMMON_CLK
-	select SAMSUNG_GPIOLIB_4BIT
 	help
 	  Base platform code for Samsung's S5P series SoC.
 
@@ -115,13 +114,6 @@ config S5P_GPIO_INT
 
 # options for gpio configuration support
 
-config SAMSUNG_GPIOLIB_4BIT
-	bool
-	help
-	  GPIOlib file contains the 4 bit modification functions for gpio
-	  configuration. GPIOlib shall be compiled only for S3C64XX and S5P
-	  series of processors.
-
 config S5P_GPIO_DRVSTR
 	bool
 	help
-- 
1.8.3.2

