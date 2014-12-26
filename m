Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaLZSdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 13:33:31 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59317 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaLZSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 13:33:29 -0500
From: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
To: zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Subject: [PATCH v2] bcma: Fix three coding style issues, more than 80 characters per line
Date: Fri, 26 Dec 2014 18:33:18 +0000
Message-Id: <1419618798-9275-1-git-send-email-oscar.forner.martinez@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three lines with more than 80 characters per line have been split in several lines.

Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
---
 drivers/bcma/driver_chipcommon.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 19f6796..15f044d 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -79,7 +79,9 @@ static int bcma_chipco_watchdog_ticks_per_ms(struct bcma_drv_cc *cc)
 
 	if (cc->capabilities & BCMA_CC_CAP_PMU) {
 		if (bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
-			/* 4706 CC and PMU watchdogs are clocked at 1/4 of ALP clock */
+			/* 4706 CC and PMU watchdogs are clocked
+			 * at 1/4 of ALP clock
+			 */
 			return bcma_chipco_get_alp_clock(cc) / 4000;
 		else
 			/* based on 32KHz ILP clock */
@@ -97,7 +99,8 @@ int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc)
 	wdt.driver_data = cc;
 	wdt.timer_set = bcma_chipco_watchdog_timer_set_wdt;
 	wdt.timer_set_ms = bcma_chipco_watchdog_timer_set_ms_wdt;
-	wdt.max_timer_ms = bcma_chipco_watchdog_get_max_timer(cc) / cc->ticks_per_ms;
+	wdt.max_timer_ms =
+		bcma_chipco_watchdog_get_max_timer(cc) / cc->ticks_per_ms;
 
 	pdev = platform_device_register_data(NULL, "bcm47xx-wdt",
 					     cc->core->bus->num, &wdt,
@@ -335,7 +338,9 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 				       | BCMA_CC_CORECTL_UARTCLKEN);
 		}
 	} else {
-		bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
+		bcma_err(cc->core->bus,
+			 "serial not supported on this device ccrev: 0x%x\n",
+			 ccrev);
 		return;
 	}
 
-- 
2.2.1

