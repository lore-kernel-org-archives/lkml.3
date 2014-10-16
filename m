Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaJPNIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:08:12 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.170]:54879 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbaJPNIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:08:10 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-15.tower-39.messagelabs.com!1413464885!22079190!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Thu, 16 Oct 2014 15:08:05 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Andreas Werner <andreas.werner@men.de>, Jean Delvare <jdelvare@suse.de>,
        Gunter Roeck <linux@roeck-us.net>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH] hwmon: menf21bmc: Include linux/err.h
Date: Thu, 16 Oct 2014 15:07:51 +0200
Message-ID: <1413464871-882-1-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/err.h to get the definitions for IS_ERR() PTR_ERR() and
ERR_PTR() used in the driver.

This fixes compilation on powerpc targets.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/hwmon/menf21bmc_hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/menf21bmc_hwmon.c b/drivers/hwmon/menf21bmc_hwmon.c
index c92229d..afc6b58 100644
--- a/drivers/hwmon/menf21bmc_hwmon.c
+++ b/drivers/hwmon/menf21bmc_hwmon.c
@@ -21,6 +21,7 @@
 #include <linux/jiffies.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
+#include <linux/err.h>
 
 #define DRV_NAME  "menf21bmc_hwmon"
 
-- 
1.9.1

