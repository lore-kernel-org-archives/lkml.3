Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab3LDUiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:38:07 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52434 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933348Ab3LDUiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:38:00 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: khilman@linaro.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        daniel.lezcano@linaro.org, horms@verge.net.au, john.stultz@linaro.org,
        olof@lixom.net, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Thu, 05 Dec 2013 05:38:46 +0900
Message-Id: <20131204203846.19090.2532.sendpatchset@w520>
In-Reply-To: <20131204203818.19090.92396.sendpatchset@w520>
References: <20131204203818.19090.92396.sendpatchset@w520>
Subject: [PATCH v2 03/03] sh: Remove Kconfig entries for TMU, CMT and MTU2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Now when drivers/clocksource/Kconfig has been
updated with entires for CMT, TMU and MTU2
it is safe to remove these from SH.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/sh/Kconfig |   21 ---------------------
 1 file changed, 21 deletions(-)

--- 0001/arch/sh/Kconfig
+++ work/arch/sh/Kconfig	2013-11-05 21:03:10.000000000 +0900
@@ -565,27 +565,6 @@ source "arch/sh/boards/Kconfig"
 
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
