Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3K3Miz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:38:55 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:38894 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3K3Miw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:38:52 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, rdunlap@infradead.org
Cc: trivial@kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/V2] [trivial] treewide: Fix typo in Kconfig
Date: Sat, 30 Nov 2013 21:38:43 +0900
Message-Id: <1385815123-18232-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
In-Reply-To: <1385479189-1862-1-git-send-email-standby24x7@gmail.com>
References: <1385479189-1862-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Kconfig.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-at91/Kconfig.non_dt | 2 +-
 arch/x86/Kconfig                  | 2 +-
 arch/xtensa/Kconfig               | 2 +-
 drivers/i2c/busses/Kconfig        | 2 +-
 drivers/isdn/mISDN/Kconfig        | 2 +-
 drivers/scsi/Kconfig              | 4 ++--
 drivers/xen/Kconfig               | 2 +-
 net/netfilter/ipset/Kconfig       | 2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
index ca900be..0363dba 100644
--- a/arch/arm/mach-at91/Kconfig.non_dt
+++ b/arch/arm/mach-at91/Kconfig.non_dt
@@ -241,7 +241,7 @@ config MACH_PCONTROL_G20
 	bool "PControl G20 CPU module"
 	help
 	  Select this if you are using taskit's Stamp9G20 CPU module on this
-	  carrier board, beeing the decentralized unit of a building automation
+	  carrier board, being the decentralized unit of a building automation
 	  system; featuring nvram, eth-switch, iso-rs485, display, io
 
 config MACH_GSIA18S
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a5c83b9..6bdaa0f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -952,7 +952,7 @@ config X86_ANCIENT_MCE
 	depends on X86_32 && X86_MCE
 	---help---
 	  Include support for machine check handling on old Pentium 5 or WinChip
-	  systems. These typically need to be enabled explicitely on the command
+	  systems. These typically need to be enabled explicitly on the command
 	  line.
 
 config X86_MCE_THRESHOLD
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index 70a160b..49c0bd0 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -117,7 +117,7 @@ config HAVE_SMP
 	  the CPU core definition and currently needs to be selected manually.
 
 	  Multiprocessor support in implemented with external cache and
-	  interrupt controlers.
+	  interrupt controllers.
 
 	  The MX interrupt distributer adds Interprocessor Interrupts
 	  and causes the IRQ numbers to be increased by 4 for devices
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 3b26129..8531b1d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -354,7 +354,7 @@ config I2C_BCM_KONA
 	  If you say yes to this option, support will be included for the
 	  I2C interface on the Broadcom Kona family of processors.
 
-	  If you do not need KONA I2C inteface, say N.
+	  If you do not need KONA I2C interface, say N.
 
 config I2C_BLACKFIN_TWI
 	tristate "Blackfin TWI I2C support"
diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 1747a02..c0730d5 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -17,7 +17,7 @@ config MISDN_DSP
 
 	  This module may be used for special applications that require
 	  cross connecting of bchannels, conferencing, dtmf decoding,
-	  echo cancelation, tone generation, and Blowfish encryption and
+	  echo cancellation, tone generation, and Blowfish encryption and
 	  decryption. It may use hardware features if available.
 
 	  E.g. it is required for PBX4Linux. Go to http://isdn.eversberg.eu
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index fe25677..a2d61d0 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -204,9 +204,9 @@ config SCSI_MULTI_LUN
 	  Some devices support more than one LUN (Logical Unit Number) in order
 	  to allow access to several media, e.g. CD jukebox, USB card reader,
 	  mobile phone in mass storage mode. This option forces the kernel to
-	  probe for all LUNs by default. This setting can be overriden by
+	  probe for all LUNs by default. This setting can be overridden by
 	  max_luns boot/module parameter. Note that this option does not affect
-	  devices conforming to SCSI-3 or higher as they can explicitely report
+	  devices conforming to SCSI-3 or higher as they can explicitly report
 	  their number of LUNs. It is safe to say Y here unless you have one of
 	  those rare devices which reacts in an unexpected way when probed for
 	  multiple LUNs.
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index c794ea1..12ba6db 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -222,7 +222,7 @@ config XEN_ACPI_PROCESSOR
 
 	  To do that the driver parses the Power Management data and uploads
 	  said information to the Xen hypervisor. Then the Xen hypervisor can
-	  select the proper Cx and Pxx states. It also registers itslef as the
+	  select the proper Cx and Pxx states. It also registers itself as the
 	  SMM so that other drivers (such as ACPI cpufreq scaling driver) will
 	  not load.
 
diff --git a/net/netfilter/ipset/Kconfig b/net/netfilter/ipset/Kconfig
index a2d6263..44cd4f5 100644
--- a/net/netfilter/ipset/Kconfig
+++ b/net/netfilter/ipset/Kconfig
@@ -21,7 +21,7 @@ config IP_SET_MAX
 	  You can define here default value of the maximum number 
 	  of IP sets for the kernel.
 
-	  The value can be overriden by the 'max_sets' module
+	  The value can be overridden by the 'max_sets' module
 	  parameter of the 'ip_set' module.
 
 config IP_SET_BITMAP_IP
-- 
1.8.5.rc1.28.g7061504

