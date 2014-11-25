Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaKYPrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:47:36 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60863 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaKYPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:47:17 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4/5] hwmon: ina2xx: change hex constants to lower-case
Date: Tue, 25 Nov 2014 16:47:02 +0100
Message-Id: <1416930423-12179-5-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
References: <1416930423-12179-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ina2xx uniform with the majority of the kernel code.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 0914a72..41a5ad3 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -49,7 +49,7 @@
 /* INA226 register definitions */
 #define INA226_MASK_ENABLE		0x06
 #define INA226_ALERT_LIMIT		0x07
-#define INA226_DIE_ID			0xFF
+#define INA226_DIE_ID			0xff
 
 /* shunt resistor sysfs attribute index */
 #define INA2XX_RSHUNT			0x8
@@ -64,7 +64,7 @@
 #define INA2XX_MAX_REGISTERS		8
 
 /* settings - depend on use case */
-#define INA219_CONFIG_DEFAULT		0x399F	/* PGA=8 */
+#define INA219_CONFIG_DEFAULT		0x399f	/* PGA=8 */
 #define INA226_CONFIG_DEFAULT		0x4527	/* averages=16 */
 
 /* worst case is 68.10 ms (~14.6Hz, ina219) */
@@ -74,8 +74,8 @@
 #define INA2XX_RSHUNT_DEFAULT		10000
 
 /* bit masks for the averaging setting in the configuration register */
-#define INA226_AVG_RD_MASK		0x0E00
-#define INA226_AVG_WR_MASK		0xF1FF
+#define INA226_AVG_RD_MASK		0x0e00
+#define INA226_AVG_WR_MASK		0xf1ff
 
 #define INA226_READ_AVG(reg) ((reg & INA226_AVG_RD_MASK) >> 9)
 
-- 
2.1.3

