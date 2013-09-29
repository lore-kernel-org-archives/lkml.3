Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab3I2Ly0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 07:54:26 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52305 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3I2LyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 07:54:24 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/v2] trivial: treewide: Fix typo in Kconfig
Date: Sun, 29 Sep 2013 20:54:15 +0900
Message-Id: <1380455655-11962-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-Reply-To: <1377420828-32716-1-git-send-email-standby24x7@gmail.com>
References: <1377420828-32716-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Kconfig.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

---
 arch/arm/mach-sti/Kconfig            | 4 ++--
 drivers/cpufreq/Kconfig.x86          | 2 +-
 drivers/dma/Kconfig                  | 2 +-
 drivers/fmc/Kconfig                  | 2 +-
 drivers/infiniband/ulp/isert/Kconfig | 4 ++--
 drivers/media/i2c/Kconfig            | 2 +-
 drivers/mfd/Kconfig                  | 4 ++--
 drivers/usb/core/Kconfig             | 2 +-
 net/vmw_vsock/Kconfig                | 2 +-
 9 files changed, 12 insertions(+), 12 deletions(-)

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
index f238cfd..fcba96c 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -301,7 +301,7 @@ config MMP_PDMA
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
index d18be19..cbc9ee9 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -646,7 +646,7 @@ config VIDEO_UPD64083
 	  To compile this driver as a module, choose M here: the
 	  module will be called upd64083.
 
-comment "Miscelaneous helper chips"
+comment "Miscellaneous helper chips"
 
 config VIDEO_THS7303
 	tristate "THS7303/53 Video Amplifier"
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d078fe4a..6d0e0cf 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -664,14 +664,14 @@ menu "STMicroelectronics STMPE Interface Drivers"
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
1.8.4.474.g128a96c

