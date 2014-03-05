Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaCELRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:17:41 -0500
Received: from smtp2.macau.ctm.net ([202.175.3.60]:48232 "EHLO
	smtp2.macau.ctm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbaCELRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:17:39 -0500
X-Greylist: delayed 1104 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 06:17:37 EST
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Subject: [PATCH] watchdog: bcm281xx: Fix Kconfig dependency
Date: Wed,  5 Mar 2014 18:57:41 +0800
Message-Id: <1394017061-5481-1-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.9.0
X-TM-AS-MML: No
X-TM-AS-Product-Ver: IMSS-7.1.0.1392-7.5.0.1017-20546.006
X-TM-AS-Result: No--1.319-7.0-31-10
X-imss-scan-details: No--1.319-7.0-31-10;No--1.319-7.0-31-10
X-TMASE-MatchedRID: ZedqH6QxswFVh4Yj8LJiiJ3iEJrvFJmhQl/FdRYkUZKcbyawsiRjd6PF
	jJEFr+olAmPpbGBYlhvkwjHXXC/4I8ZW5ai5WKlyBNCpxBQYCAgcDs2JeFetrhtc5CvIfqxW5Kp
	AZxNtCOIRvCwkWu1U1Fjv/pLnCgILKuUbtaTrPd1yYBbCMIXAw3oJgN4lthN9/r/b+dmSKFo6AH
	9/PcRd1xUpPR4VGZ8OzhiFp8LOC6Mh1j2M6LiVMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more the applicable ARCH_BCM_MOBILE option instead of ARCH_BCM as
dependency for bcm_kona_wdt.c.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 drivers/watchdog/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 79d2589..47a6f10 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1160,7 +1160,7 @@ config BCM2835_WDT
 
 config BCM_KONA_WDT
 	tristate "BCM Kona Watchdog"
-	depends on ARCH_BCM
+	depends on ARCH_BCM_MOBILE
 	select WATCHDOG_CORE
 	help
 	  Support for the watchdog timer on the following Broadcom BCM281xx
-- 
1.9.0

