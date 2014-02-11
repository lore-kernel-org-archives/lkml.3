Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaBKE2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 23:28:19 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:52820 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaBKE2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 23:28:16 -0500
From: Laszlo Papp <lpapp@kde.org>
To: lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, lpapp@kde.org
Subject: [PATCH] mfd: fix a grammar issue in the Kconfig entries
Date: Tue, 11 Feb 2014 04:27:55 +0000
Message-Id: <1392092875-28776-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"to support for" is incorrect English in here, hence the change to "to add
support".

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/mfd/Kconfig | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 4ad39f4..0bce1ad 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -100,7 +100,7 @@ config PMIC_DA903X
 	bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
 	depends on I2C=y
 	help
-	  Say yes here to support for Dialog Semiconductor DA9030 (a.k.a
+	  Say yes here to add support for Dialog Semiconductor DA9030 (a.k.a
 	  ARAVA) and DA9034 (a.k.a MICCO), these are Power Management IC
 	  usually found on PXA processors-based platforms. This includes
 	  the I2C driver and the core APIs _only_, you have to select
@@ -324,7 +324,7 @@ config MFD_MAX14577
 	select REGMAP_I2C
 	select IRQ_DOMAIN
 	help
-	  Say yes here to support for Maxim Semiconductor MAX14577.
+	  Say yes here to add support for Maxim Semiconductor MAX14577.
 	  This is a Micro-USB IC with Charger controls on chip.
 	  This driver provides common support for accessing the device;
 	  additional drivers must be enabled in order to use the functionality
@@ -337,7 +337,7 @@ config MFD_MAX77686
 	select REGMAP_I2C
 	select IRQ_DOMAIN
 	help
-	  Say yes here to support for Maxim Semiconductor MAX77686.
+	  Say yes here to add support for Maxim Semiconductor MAX77686.
 	  This is a Power Management IC with RTC on chip.
 	  This driver provides common support for accessing the device;
 	  additional drivers must be enabled in order to use the functionality
@@ -349,7 +349,7 @@ config MFD_MAX77693
 	select MFD_CORE
 	select REGMAP_I2C
 	help
-	  Say yes here to support for Maxim Semiconductor MAX77693.
+	  Say yes here to add support for Maxim Semiconductor MAX77693.
 	  This is a companion Power Management IC with Flash, Haptic, Charger,
 	  and MUIC(Micro USB Interface Controller) controls on chip.
 	  This driver provides common support for accessing the device;
@@ -363,7 +363,7 @@ config MFD_MAX8907
 	select REGMAP_I2C
 	select REGMAP_IRQ
 	help
-	  Say yes here to support for Maxim Semiconductor MAX8907. This is
+	  Say yes here to add support for Maxim Semiconductor MAX8907. This is
 	  a Power Management IC. This driver provides common support for
 	  accessing the device; additional drivers must be enabled in order
 	  to use the functionality of the device.
@@ -374,17 +374,17 @@ config MFD_MAX665X
 	depends on I2C
 	select REGMAP_I2C
 	help
-	  Say yes here to support for Maxim Semiconductor MAX6650/MAX6651. This is
-	  a fan speed regulator and monitor IC. This driver provides common support
-	  for accessing the device, additional drivers must be enabled in order to
-	  use the functionality of the device.
+	  Say yes here to add support for Maxim Semiconductor MAX6650/MAX6651. This
+	  is a fan speed regulator and monitor IC. This driver provides common
+	  support for accessing the device, additional drivers must be enabled in
+	  order to use the functionality of the device.
 
 config MFD_MAX8925
 	bool "Maxim Semiconductor MAX8925 PMIC Support"
 	depends on I2C=y
 	select MFD_CORE
 	help
-	  Say yes here to support for Maxim Semiconductor MAX8925. This is
+	  Say yes here to add support for Maxim Semiconductor MAX8925. This is
 	  a Power Management IC. This driver provides common support for
 	  accessing the device, additional drivers must be enabled in order
 	  to use the functionality of the device.
@@ -395,7 +395,7 @@ config MFD_MAX8997
 	select MFD_CORE
 	select IRQ_DOMAIN
 	help
-	  Say yes here to support for Maxim Semiconductor MAX8997/8966.
+	  Say yes here to add support for Maxim Semiconductor MAX8997/8966.
 	  This is a Power Management IC with RTC, Flash, Fuel Gauge, Haptic,
 	  MUIC controls on chip.
 	  This driver provides common support for accessing the device;
@@ -408,7 +408,7 @@ config MFD_MAX8998
 	select MFD_CORE
 	select IRQ_DOMAIN
 	help
-	  Say yes here to support for Maxim Semiconductor MAX8998 and
+	  Say yes here to add support for Maxim Semiconductor MAX8998 and
 	  National Semiconductor LP3974. This is a Power Management IC.
 	  This driver provides common support for accessing the device,
 	  additional drivers must be enabled in order to use the functionality
-- 
1.8.5.4

