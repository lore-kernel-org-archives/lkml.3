Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaIRDJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:09:59 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46985 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbaIRDJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:09:58 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, rdunlap@infradead.org
Cc: realmz6@gmail.com, tglx@linutronix.de, jason@lakedaemon.net,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typos in Kconfig
Date: Thu, 18 Sep 2014 12:09:42 +0900
Message-Id: <1411009782-9070-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.238.gce1d3a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typos found in Kconfig.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/blackfin/Kconfig           | 2 +-
 arch/mips/cavium-octeon/Kconfig | 2 +-
 drivers/i2c/busses/Kconfig      | 2 +-
 drivers/irqchip/Kconfig         | 2 +-
 drivers/platform/x86/Kconfig    | 8 ++++----
 drivers/usb/host/Kconfig        | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index ed30699..af76634 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -671,7 +671,7 @@ config TICKSOURCE_CORETMR
 	default y
 endmenu
 
-menu "Clock souce"
+menu "Clock source"
 	depends on GENERIC_CLOCKEVENTS
 config CYCLES_CLOCKSOURCE
 	bool "CYCLES"
diff --git a/arch/mips/cavium-octeon/Kconfig b/arch/mips/cavium-octeon/Kconfig
index 6028666..c370426 100644
--- a/arch/mips/cavium-octeon/Kconfig
+++ b/arch/mips/cavium-octeon/Kconfig
@@ -1,7 +1,7 @@
 if CPU_CAVIUM_OCTEON
 
 config CAVIUM_CN63XXP1
-	bool "Enable CN63XXP1 errata worarounds"
+	bool "Enable CN63XXP1 errata workarounds"
 	default "n"
 	help
 	  The CN63XXP1 chip requires build time workarounds to
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2ac87fa..2e45ae3 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -357,7 +357,7 @@ config I2C_BCM_KONA
 	  If you say yes to this option, support will be included for the
 	  I2C interface on the Broadcom Kona family of processors.
 
-	  If you do not need KONA I2C inteface, say N.
+	  If you do not need KONA I2C interface, say N.
 
 config I2C_BLACKFIN_TWI
 	tristate "Blackfin TWI I2C support"
diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index b8632bf..a31a9e4 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -109,7 +109,7 @@ config XTENSA_MX
 config IRQ_CROSSBAR
 	bool
 	help
-	  Support for a CROSSBAR ip that preceeds the main interrupt controller.
+	  Support for a CROSSBAR ip that precedes the main interrupt controller.
 	  The primary irqchip invokes the crossbar's callback which inturn allocates
 	  a free irq and configures the IP. Thus the peripheral interrupts are
 	  routed to one of the free irqchip interrupt lines.
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3bbcbf1..4dd2cd8 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -540,7 +540,7 @@ config ASUS_NB_WMI
 	  This is a driver for newer Asus notebooks. It adds extra features
 	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
 
-	  For more informations, see
+	  For more information, see
 	  <file:Documentation/ABI/testing/sysfs-platform-asus-wmi>
 
 	  If you have an ACPI-WMI compatible Asus Notebook, say Y or M
@@ -553,7 +553,7 @@ config EEEPC_WMI
 	  This is a driver for newer Eee PC laptops. It adds extra features
 	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
 
-	  For more informations, see
+	  For more information, see
 	  <file:Documentation/ABI/testing/sysfs-platform-asus-wmi>
 
 	  If you have an ACPI-WMI compatible Eee PC laptop (>= 1000), say Y or M
@@ -657,7 +657,7 @@ config TOSHIBA_HAPS
 	depends on ACPI
 	---help---
 	  This driver adds support for the built-in accelerometer
-	  found on recent Toshiba laptops equiped with HID TOS620A
+	  found on recent Toshiba laptops equipped with HID TOS620A
 	  device.
 
 	  This driver receives ACPI notify events 0x80 when the sensor
@@ -666,7 +666,7 @@ config TOSHIBA_HAPS
 	  been stabilized.
 
 	  Also provides sysfs entries to get/set the desired protection
-	  level and reseting the HDD protection interface.
+	  level and resetting the HDD protection interface.
 
 	  If you have a recent Toshiba laptop with a built-in accelerometer
 	  device, say Y.
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 82800a7..56f4336 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -126,7 +126,7 @@ config XPS_USB_HCD_XILINX
 	select USB_EHCI_BIG_ENDIAN_DESC
 	select USB_EHCI_BIG_ENDIAN_MMIO
 	---help---
-		Xilinx xps USB host controller core is EHCI compilant and has
+		Xilinx xps USB host controller core is EHCI compliant and has
 		transaction translator built-in. It can be configured to either
 		support both high speed and full speed devices, or high speed
 		devices only.
-- 
2.1.0.238.gce1d3a9

