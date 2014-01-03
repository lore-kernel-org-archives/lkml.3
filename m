Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaACU5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:57:30 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:39871 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaACU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:57:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,599,1384329600"; 
   d="scan'208";a="7641278"
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
CC: Linaro Patches <patches@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH] watchdog: bcm281xx: Fix Kconfig help section
Date: Fri, 3 Jan 2014 12:57:16 -0800
Message-ID: <1388782636-10042-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the debugfs path name mentioned in the Kconfig help section.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---

This patch fixes an oversight in my previous series from Dec 31.
http://www.spinics.net/lists/linux-watchdog/msg03538.html

 drivers/watchdog/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 9b8b96d..af8f7c7 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1156,7 +1156,7 @@ config BCM_KONA_WDT_DEBUG
 	bool "DEBUGFS support for BCM Kona Watchdog"
 	depends on BCM_KONA_WDT
 	help
-	  If enabled, adds /sys/kernel/debug/bcm-kona-wdt/info which provides
+	  If enabled, adds /sys/kernel/debug/bcm_kona_wdt/info which provides
 	  access to the driver's internal data structures as well as watchdog
 	  timer hardware registres.
 
-- 
1.7.9.5

