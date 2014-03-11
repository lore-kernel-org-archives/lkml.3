Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaCKWnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:43:25 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:56931 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbaCKWlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:41:09 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        ezequiel.garcia@free-electrons.com, ivan.khoronzhuk@ti.com,
        linus.walleij@linaro.org, magnus.damm@gmail.com,
        matthias.bgg@gmail.com, soren.brinkmann@xilinx.com,
        sboyd@codeaurora.org
Subject: [PATCH 11/17] sh: Remove Kconfig entries for TMU, CMT and MTU2
Date: Tue, 11 Mar 2014 23:40:47 +0100
Message-Id: <1394577653-8615-11-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
References: <531F8FAC.2040902@linaro.org>
 <1394577653-8615-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when drivers/clocksource/Kconfig has been
updated with entires for CMT, TMU and MTU2
it is safe to remove these from SH.

Signed-off-by: Magnus Damm <damm@opensource.se>
Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Wolfram Sang <wsa@sang-engineering.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/sh/Kconfig |   76 +++++++++++++++++--------------------------------------
 1 file changed, 23 insertions(+), 53 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 6357710..364d204 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -123,15 +123,6 @@ config SYS_SUPPORTS_NUMA
 config SYS_SUPPORTS_PCI
 	bool
 
-config SYS_SUPPORTS_CMT
-	bool
-
-config SYS_SUPPORTS_MTU2
-	bool
-
-config SYS_SUPPORTS_TMU
-	bool
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
@@ -191,14 +182,14 @@ config CPU_SH3
 	bool
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 
 config CPU_SH4
 	bool
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
 	select CPU_HAS_FPU if !CPU_SH4AL_DSP
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SH4A
@@ -213,7 +204,7 @@ config CPU_SH4AL_DSP
 config CPU_SH5
 	bool
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_TMU
+	select SYS_SUPPORTS_SH_TMU
 	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SHX2
@@ -250,7 +241,7 @@ choice
 config CPU_SUBTYPE_SH7619
 	bool "Support SH7619 processor"
 	select CPU_SH2
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 # SH-2A Processor Support
 
@@ -258,50 +249,50 @@ config CPU_SUBTYPE_SH7201
 	bool "Support SH7201 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_MTU2
  
 config CPU_SUBTYPE_SH7203
 	bool "Support SH7203 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7206
 	bool "Support SH7206 processor"
 	select CPU_SH2A
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 
 config CPU_SUBTYPE_SH7263
 	bool "Support SH7263 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 
 config CPU_SUBTYPE_SH7264
 	bool "Support SH7264 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select PINCTRL
 
 config CPU_SUBTYPE_SH7269
 	bool "Support SH7269 processor"
 	select CPU_SH2A
 	select CPU_HAS_FPU
-	select SYS_SUPPORTS_CMT
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_CMT
+	select SYS_SUPPORTS_SH_MTU2
 	select PINCTRL
 
 config CPU_SUBTYPE_MXG
 	bool "Support MX-G processor"
 	select CPU_SH2A
-	select SYS_SUPPORTS_MTU2
+	select SYS_SUPPORTS_SH_MTU2
 	help
 	  Select MX-G if running on an R8A03022BG part.
 
@@ -354,7 +345,7 @@ config CPU_SUBTYPE_SH7720
 	bool "Support SH7720 processor"
 	select CPU_SH3
 	select CPU_HAS_DSP
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
@@ -366,7 +357,7 @@ config CPU_SUBTYPE_SH7721
 	bool "Support SH7721 processor"
 	select CPU_SH3
 	select CPU_HAS_DSP
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select USB_ARCH_HAS_OHCI
 	select USB_OHCI_SH if USB_OHCI_HCD
 	help
@@ -422,7 +413,7 @@ config CPU_SUBTYPE_SH7723
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 	help
@@ -434,7 +425,7 @@ config CPU_SUBTYPE_SH7724
 	select CPU_SHX2
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 	help
@@ -514,7 +505,7 @@ config CPU_SUBTYPE_SH7343
 	bool "Support SH7343 processor"
 	select CPU_SH4AL_DSP
 	select ARCH_SHMOBILE
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 config CPU_SUBTYPE_SH7722
 	bool "Support SH7722 processor"
@@ -523,7 +514,7 @@ config CPU_SUBTYPE_SH7722
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select PINCTRL
 
@@ -534,7 +525,7 @@ config CPU_SUBTYPE_SH7366
 	select ARCH_SHMOBILE
 	select ARCH_SPARSEMEM_ENABLE
 	select SYS_SUPPORTS_NUMA
-	select SYS_SUPPORTS_CMT
+	select SYS_SUPPORTS_SH_CMT
 
 endchoice
 
@@ -567,27 +558,6 @@ source "arch/sh/boards/Kconfig"
 
 menu "Timer and clock configuration"
 
-config SH_TIMER_TMU
-	bool "TMU timer driver"
-	depends on SYS_SUPPORTS_TMU
-	default y
-	help
-	  This enables the build of the TMU timer driver.
-
-config SH_TIMER_CMT
-	bool "CMT timer driver"
-	depends on SYS_SUPPORTS_CMT
-	default y
-	help
-	  This enables build of the CMT timer driver.
-
-config SH_TIMER_MTU2
-	bool "MTU2 timer driver"
-	depends on SYS_SUPPORTS_MTU2
-	default y
-	help
-	  This enables build of the MTU2 timer driver.
-
 config SH_PCLK_FREQ
 	int "Peripheral clock frequency (in Hz)"
 	depends on SH_CLK_CPG_LEGACY
-- 
1.7.9.5

