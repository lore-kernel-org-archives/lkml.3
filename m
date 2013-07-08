Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3GHGEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:04:42 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57544 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3GHGEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:04:25 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        David.Woodhouse@intel.com, artem.bityutskiy@linux.intel.com,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 2/3] cris: cleanup arch-v32/drivers/Kconfig
Date: Mon,  8 Jul 2013 08:04:10 +0200
Message-Id: <1373263451-26841-3-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove kernel configuration parameters
defined in arch/cris/arch-v32/drivers/Kconfig, but used nowhere
in the makefiles and source code

It also removes parameters which are no longer used after this change

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/cris/arch-v32/drivers/Kconfig | 197 -------------------------------------
 1 file changed, 197 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/Kconfig b/arch/cris/arch-v32/drivers/Kconfig
index acff3df..152bd68 100644
--- a/arch/cris/arch-v32/drivers/Kconfig
+++ b/arch/cris/arch-v32/drivers/Kconfig
@@ -29,10 +29,6 @@ config ETRAX_ETHERNET_IFACE1
 	depends on (ETRAX_ETHERNET && ETRAXFS)
 	bool "Enable network interface 1 (uses DMA6 and DMA7)"
 
-config ETRAX_ETHERNET_GBIT
-	depends on (ETRAX_ETHERNET && CRIS_MACH_ARTPEC3)
-	bool "Enable gigabit Ethernet support"
-
 choice
 	prompt "Eth0 led group"
 	depends on ETRAX_ETHERNET_IFACE0
@@ -135,22 +131,6 @@ config ETRAX_SERIAL_PORT0_TYPE_485FD
 	  Configure serial port 0 to be a full duplex (four wires) RS-485 port.
 endchoice
 
-config ETRAX_SER0_DTR_BIT
-	string "Ser 0 DTR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT0
-
-config ETRAX_SER0_RI_BIT
-	string "Ser 0 RI bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT0
-
-config ETRAX_SER0_DSR_BIT
-	string "Ser 0 DSR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT0
-
-config ETRAX_SER0_CD_BIT
-	string "Ser 0 CD bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT0
-
 config ETRAX_SERIAL_PORT1
 	bool "Serial port 1 enabled"
 	depends on ETRAXFS_SERIAL
@@ -182,22 +162,6 @@ config ETRAX_SERIAL_PORT1_TYPE_485FD
 	  Configure serial port 1 to be a full duplex (four wires) RS-485 port.
 endchoice
 
-config ETRAX_SER1_DTR_BIT
-	string "Ser 1 DTR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT1
-
-config ETRAX_SER1_RI_BIT
-	string "Ser 1 RI bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT1
-
-config ETRAX_SER1_DSR_BIT
-	string "Ser 1 DSR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT1
-
-config ETRAX_SER1_CD_BIT
-	string "Ser 1 CD bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT1
-
 config ETRAX_SERIAL_PORT2
 	bool "Serial port 2 enabled"
 	depends on ETRAXFS_SERIAL
@@ -230,22 +194,6 @@ config ETRAX_SERIAL_PORT2_TYPE_485FD
 endchoice
 
 
-config ETRAX_SER2_DTR_BIT
-	string "Ser 2 DTR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT2
-
-config ETRAX_SER2_RI_BIT
-	string "Ser 2 RI bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT2
-
-config ETRAX_SER2_DSR_BIT
-	string "Ser 2 DSR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT2
-
-config ETRAX_SER2_CD_BIT
-	string "Ser 2 CD bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT2
-
 config ETRAX_SERIAL_PORT3
 	bool "Serial port 3 enabled"
 	depends on ETRAXFS_SERIAL
@@ -277,22 +225,6 @@ config ETRAX_SERIAL_PORT3_TYPE_485FD
 	  Configure serial port 3 to be a full duplex (four wires) RS-485 port.
 endchoice
 
-config ETRAX_SER3_DTR_BIT
-	string "Ser 3 DTR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
-
-config ETRAX_SER3_RI_BIT
-	string "Ser 3 RI bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
-
-config ETRAX_SER3_DSR_BIT
-	string "Ser 3 DSR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
-
-config ETRAX_SER3_CD_BIT
-	string "Ser 3 CD bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT3
-
 config ETRAX_SERIAL_PORT4
 	bool "Serial port 4 enabled"
 	depends on ETRAXFS_SERIAL && CRIS_MACH_ARTPEC3
@@ -349,22 +281,6 @@ config ETRAX_SERIAL_PORT4_DMA9_IN
 
 endchoice
 
-config ETRAX_SER4_DTR_BIT
-	string "Ser 4 DTR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT4
-
-config ETRAX_SER4_RI_BIT
-	string "Ser 4 RI bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT4
-
-config ETRAX_SER4_DSR_BIT
-	string "Ser 4 DSR bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT4
-
-config ETRAX_SER4_CD_BIT
-	string "Ser 4 CD bit (empty = not used)"
-	depends on ETRAX_SERIAL_PORT4
-
 config ETRAX_SYNCHRONOUS_SERIAL
 	bool "Synchronous serial-port support"
 	depends on ETRAX_ARCH_V32
@@ -705,32 +621,6 @@ config ETRAX_SPI_SSER0
 	  want to build it as a module, which will be named spi_crisv32_sser.
 	  (You need to select MMC separately.)
 
-config ETRAX_SPI_SSER0_DMA
-	bool "DMA for SPI on sser0 enabled"
-	depends on ETRAX_SPI_SSER0
-	depends on !ETRAX_SERIAL_PORT1_DMA4_OUT && !ETRAX_SERIAL_PORT1_DMA5_IN
-	default y
-	help
-	  Say Y if using DMA (dma4/dma5) for SPI on synchronous serial port 0.
-
-config ETRAX_SPI_MMC_CD_SSER0_PIN
-	string "MMC/SD card detect pin for SPI on sser0"
-	depends on ETRAX_SPI_SSER0 && MMC_SPI
-	default "pd11"
-	help
-	  The pin to use for SD/MMC card detect.  This pin should be pulled up
-	  and grounded when a card is present.  If defined as " " (space), no
-	  pin is selected.  A card must then always be inserted for proper
-	  action.
-
-config ETRAX_SPI_MMC_WP_SSER0_PIN
-	string "MMC/SD card write-protect pin for SPI on sser0"
-	depends on ETRAX_SPI_SSER0 && MMC_SPI
-	default "pd10"
-	help
-	  The pin to use for the SD/MMC write-protect signal for a memory
-	  card.  If defined as " " (space), the card is considered writable.
-
 config ETRAX_SPI_SSER1
 	tristate "SPI using synchronous serial port 1 (sser1)"
 	depends on ETRAX_SPI_MMC
@@ -744,91 +634,4 @@ config ETRAX_SPI_SSER1
 	  want to build it as a module, which will be named spi_crisv32_sser.
 	  (You need to select MMC separately.)
 
-config ETRAX_SPI_SSER1_DMA
-	bool "DMA for SPI on sser1 enabled"
-	depends on ETRAX_SPI_SSER1 && !ETRAX_ETHERNET_IFACE1
-	depends on !ETRAX_SERIAL_PORT0_DMA6_OUT && !ETRAX_SERIAL_PORT0_DMA7_IN
-	default y
-	help
-	  Say Y if using DMA (dma6/dma7) for SPI on synchronous serial port 1.
-
-config ETRAX_SPI_MMC_CD_SSER1_PIN
-	string "MMC/SD card detect pin for SPI on sser1"
-	depends on ETRAX_SPI_SSER1 && MMC_SPI
-	default "pd12"
-	help
-	  The pin to use for SD/MMC card detect.  This pin should be pulled up
-	  and grounded when a card is present.  If defined as " " (space), no
-	  pin is selected.  A card must then always be inserted for proper
-	  action.
-
-config ETRAX_SPI_MMC_WP_SSER1_PIN
-	string "MMC/SD card write-protect pin for SPI on sser1"
-	depends on ETRAX_SPI_SSER1 && MMC_SPI
-	default "pd9"
-	help
-	  The pin to use for the SD/MMC write-protect signal for a memory
-	  card.  If defined as " " (space), the card is considered writable.
-
-config ETRAX_SPI_GPIO
-	tristate "Bitbanged SPI using gpio pins"
-	depends on ETRAX_SPI_MMC
-	select SPI_ETRAX_GPIO
-	default m if MMC_SPI=m && ETRAX_SPI_SSER0=n && ETRAX_SPI_SSER1=n
-	default y if MMC_SPI=y && ETRAX_SPI_SSER0=n && ETRAX_SPI_SSER1=n
-	default y if MMC_SPI=n && ETRAX_SPI_SSER0=n && ETRAX_SPI_SSER1=n
-	help
-	  Say Y for an MMC/SD socket connected to general I/O pins (but not
-	  a complete synchronous serial ports), or for devices using the SPI
-	  protocol on general I/O pins.  Slow and slows down the system.
-	  Say m to build it as a module, which will be called spi_crisv32_gpio.
-	  (You need to select MMC separately.)
-
-# The default match that of sser0, only because that's how it was tested.
-config ETRAX_SPI_CS_PIN
-	string "SPI chip select pin"
-	depends on ETRAX_SPI_GPIO
-	default "pc3"
-	help
-	  The pin to use for SPI chip select.
-
-config ETRAX_SPI_CLK_PIN
-	string "SPI clock pin"
-	depends on ETRAX_SPI_GPIO
-	default "pc1"
-	help
-	  The pin to use for the SPI clock.
-
-config ETRAX_SPI_DATAIN_PIN
-	string "SPI MISO (data in) pin"
-	depends on ETRAX_SPI_GPIO
-	default "pc16"
-	help
-	  The pin to use for SPI data in from the device.
-
-config ETRAX_SPI_DATAOUT_PIN
-	string "SPI MOSI (data out) pin"
-	depends on ETRAX_SPI_GPIO
-	default "pc0"
-	help
-	  The pin to use for SPI data out to the device.
-
-config ETRAX_SPI_MMC_CD_GPIO_PIN
-	string "MMC/SD card detect pin for SPI using gpio (space for none)"
-	depends on ETRAX_SPI_GPIO && MMC_SPI
-	default "pd11"
-	help
-	  The pin to use for SD/MMC card detect.  This pin should be pulled up
-	  and grounded when a card is present.  If defined as " " (space), no
-	  pin is selected.  A card must then always be inserted for proper
-	  action.
-
-config ETRAX_SPI_MMC_WP_GPIO_PIN
-	string "MMC/SD card write-protect pin for SPI using gpio (space for none)"
-	depends on ETRAX_SPI_GPIO && MMC_SPI
-	default "pd10"
-	help
-	  The pin to use for the SD/MMC write-protect signal for a memory
-	  card.  If defined as " " (space), the card is considered writable.
-
 endif
-- 
1.8.1.2

