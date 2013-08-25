Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3HYIyA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 04:54:00 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48705 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3HYIx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 04:53:56 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial]treewide: Fix typo in Kconfig
Date: Sun, 25 Aug 2013 17:53:48 +0900
Message-Id: <1377420828-32716-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in various Kconfig files.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-sti/Kconfig            | 4 ++--
 drivers/cpufreq/Kconfig.x86          | 2 +-
 drivers/dma/Kconfig                  | 2 +-
 drivers/fmc/Kconfig                  | 2 +-
 drivers/infiniband/ulp/isert/Kconfig | 4 ++--
 drivers/media/i2c/Kconfig            | 2 +-
 drivers/mfd/Kconfig                  | 4 ++--
 drivers/usb/core/Kconfig             | 2 +-
 init/Kconfig                         | 2 +-
 net/vmw_vsock/Kconfig                | 2 +-
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-sti/Kconfig b/arch/arm/mach-sti/Kconfig
index 835833e..a67f83f 100644
--- a/arch/arm/mach-sti/Kconfig
+++ b/arch/arm/mach-sti/Kconfig
@@ -30,7 +30,7 @@ config SOC_STIH415
 	default y
 	help
 	  This enables support for STMicroelectronics Digital Consumer
-	  Electronics family StiH415 parts, primarily targetted at set-top-box
+	  Electronics family StiH415 parts, primarily targeted at set-top-box
 	  and other digital audio/video applications using Flattned Device
 	  Trees.
 
@@ -39,7 +39,7 @@ config SOC_STIH416
 	default y
 	help
 	  This enables support for STMicroelectronics Digital Consumer
-	  Electronics family StiH416 parts, primarily targetted at set-top-box
+	  Electronics family StiH416 parts, primarily targeted at set-top-box
 	  and other digital audio/video applications using Flattened Device
 	  Trees.
 
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index e2b6eab..b80bb4d 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -136,7 +136,7 @@ config X86_AMD_FREQ_SENSITIVITY
 	help
 	  This adds AMD-specific powersave bias function to the ondemand
 	  governor, which allows it to make more power-conscious frequency
-	  change decisions based on feedback from hardware (availble on AMD
+	  change decisions based on feedback from hardware (available on AMD
 	  Family 16h and above).
 
 	  Hardware feedback tells software how "sensitive" to frequency changes
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 77bc480..6a737d9 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -300,7 +300,7 @@ config MMP_PDMA
 	depends on (ARCH_MMP || ARCH_PXA)
 	select DMA_ENGINE
 	help
-	  Support the MMP PDMA engine for PXA and MMP platfrom.
+	  Support the MMP PDMA engine for PXA and MMP platform.
 
 config DMA_JZ4740
 	tristate "JZ4740 DMA support"
diff --git a/drivers/fmc/Kconfig b/drivers/fmc/Kconfig
index c01cf45..3a75f42 100644
--- a/drivers/fmc/Kconfig
+++ b/drivers/fmc/Kconfig
@@ -46,6 +46,6 @@ config FMC_CHARDEV
 	  This driver matches every mezzanine device and allows user
 	  space to read and write registers using a char device. It
 	  can be used to write user-space drivers, or just get
-	  aquainted with a mezzanine before writing its specific driver.
+	  acquainted with a mezzanine before writing its specific driver.
 
 endif # FMC
diff --git a/drivers/infiniband/ulp/isert/Kconfig b/drivers/infiniband/ulp/isert/Kconfig
index ce3fd32..02f9759 100644
--- a/drivers/infiniband/ulp/isert/Kconfig
+++ b/drivers/infiniband/ulp/isert/Kconfig
@@ -1,5 +1,5 @@
 config INFINIBAND_ISERT
-	tristate "iSCSI Extentions for RDMA (iSER) target support"
+	tristate "iSCSI Extensions for RDMA (iSER) target support"
 	depends on INET && INFINIBAND_ADDR_TRANS && TARGET_CORE && ISCSI_TARGET
 	---help---
-	Support for iSCSI Extentions for RDMA (iSER) Target on Infiniband fabrics.
+	Support for iSCSI Extensions for RDMA (iSER) Target on Infiniband fabrics.
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index b2cd8ca..70c4671 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -623,7 +623,7 @@ config VIDEO_UPD64083
 	  To compile this driver as a module, choose M here: the
 	  module will be called upd64083.
 
-comment "Miscelaneous helper chips"
+comment "Miscellaneous helper chips"
 
 config VIDEO_THS7303
 	tristate "THS7303/53 Video Amplifier"
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index e0e46f5..36d8edb 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -665,14 +665,14 @@ menu "STMicroelectronics STMPE Interface Drivers"
 depends on MFD_STMPE
 
 config STMPE_I2C
-	bool "STMicroelectronics STMPE I2C Inteface"
+	bool "STMicroelectronics STMPE I2C Interface"
 	depends on I2C=y
 	default y
 	help
 	  This is used to enable I2C interface of STMPE
 
 config STMPE_SPI
-	bool "STMicroelectronics STMPE SPI Inteface"
+	bool "STMicroelectronics STMPE SPI Interface"
 	depends on SPI_MASTER
 	help
 	  This is used to enable SPI interface of STMPE
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index db535b0..fed7f68 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -28,7 +28,7 @@ config USB_DEFAULT_PERSIST
 	bool "Enable USB persist by default"
 	default y
 	help
-	  Say N here if you don't want USB power session persistance
+	  Say N here if you don't want USB power session persistence
 	  enabled by default.  If you say N it will make suspended USB
 	  devices that lose power get reenumerated as if they had been
 	  unplugged, causing any mounted filesystems to be lost.  The
diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..43d7554 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -536,7 +536,7 @@ config CONTEXT_TRACKING_FORCE
 	  dynticks working.
 
 	  This option stands for testing when an arch implements the
-	  context tracking backend but doesn't yet fullfill all the
+	  context tracking backend but doesn't yet fulfill all the
 	  requirements to make the full dynticks feature working.
 	  Without the full dynticks, there is no way to test the support
 	  for context tracking and the subsystems that rely on it: RCU
diff --git a/net/vmw_vsock/Kconfig b/net/vmw_vsock/Kconfig
index b5fa7e4..14810ab 100644
--- a/net/vmw_vsock/Kconfig
+++ b/net/vmw_vsock/Kconfig
@@ -6,7 +6,7 @@ config VSOCKETS
 	tristate "Virtual Socket protocol"
 	help
 	  Virtual Socket Protocol is a socket protocol similar to TCP/IP
-	  allowing comunication between Virtual Machines and hypervisor
+	  allowing communication between Virtual Machines and hypervisor
 	  or host.
 
 	  You should also select one or more hypervisor-specific transports
-- 
1.8.4

