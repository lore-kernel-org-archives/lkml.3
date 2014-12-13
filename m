Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaLMQ1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 11:27:41 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49326 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbaLMQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 11:27:32 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v7 2/5] hwmon: ina2xx: remove a stray new line
Date: Sat, 13 Dec 2014 17:27:18 +0100
Message-Id: <1418488041-7433-3-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418488041-7433-1-git-send-email-bgolaszewski@baylibre.com>
References: <1418488041-7433-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index ffbd60f..39e017b 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -52,7 +52,6 @@
 #define INA226_ALERT_LIMIT		0x07
 #define INA226_DIE_ID			0xFF
 
-
 /* register count */
 #define INA219_REGISTERS		6
 #define INA226_REGISTERS		8
-- 
2.1.3

