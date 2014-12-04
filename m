Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbaLDQrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:47:03 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47920 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaLDQqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:46:00 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 2/3] hwmon: tmp401: add TMP435 to the list of supported chips in docs and Kconfig
Date: Thu,  4 Dec 2014 17:45:52 +0100
Message-Id: <1417711553-21311-3-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
References: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/hwmon/tmp401 | 8 ++++++--
 drivers/hwmon/Kconfig      | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/hwmon/tmp401 b/Documentation/hwmon/tmp401
index f91e3fa..445ff7b 100644
--- a/Documentation/hwmon/tmp401
+++ b/Documentation/hwmon/tmp401
@@ -18,6 +18,10 @@ Supported chips:
     Prefix: 'tmp432'
     Addresses scanned: I2C 0x4c, 0x4d
     Datasheet: http://focus.ti.com/docs/prod/folders/print/tmp432.html
+  * Texas Instruments TMP435
+    Prefix: 'tmp435'
+    Addresses scanned: I2C 0x4c
+    Datasheet: http://focus.ti.com/docs/prod/folders/print/tmp435.html
 
 Authors:
          Hans de Goede <hdegoede@redhat.com>
@@ -27,8 +31,8 @@ Description
 -----------
 
 This driver implements support for Texas Instruments TMP401, TMP411,
-TMP431, and TMP432 chips. These chips implement one or two remote and
-one local temperature sensors. Temperature is measured in degrees
+TMP431, TMP432 and TMP435 chips. These chips implement one or two remote
+and one local temperature sensors. Temperature is measured in degrees
 Celsius. Resolution of the remote sensor is 0.0625 degree. Local
 sensor resolution can be set to 0.5, 0.25, 0.125 or 0.0625 degree (not
 supported by the driver so far, so using the default resolution of 0.5
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index b1ce6a0..6529c09 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -1466,7 +1466,7 @@ config SENSORS_TMP401
 	depends on I2C
 	help
 	  If you say yes here you get support for Texas Instruments TMP401,
-	  TMP411, TMP431, and TMP432 temperature sensor chips.
+	  TMP411, TMP431, TMP432 and TMP435 temperature sensor chips.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called tmp401.
-- 
2.1.3

