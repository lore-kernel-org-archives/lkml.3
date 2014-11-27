Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbaK0J7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:59:39 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36373 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807AbaK0J7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 04:59:35 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <jdelvare@suse.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 5/5] hwmon: ina2xx: documentation update for new sysfs attributes
Date: Thu, 27 Nov 2014 10:59:10 +0100
Message-Id: <1417082350-23470-6-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com>
References: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the rshunt and avg sysfs attributes for ina2xx in the documentation.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/hwmon/ina2xx | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
index 4223c2d..c100c24 100644
--- a/Documentation/hwmon/ina2xx
+++ b/Documentation/hwmon/ina2xx
@@ -44,6 +44,10 @@ The INA226 monitors both a shunt voltage drop and bus supply voltage.
 The INA230 is a high or low side current shunt and power monitor with an I2C
 interface. The INA230 monitors both a shunt voltage drop and bus supply voltage.
 
-The shunt value in micro-ohms can be set via platform data or device tree.
-Please refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
-if the device tree is used.
+The shunt value in micro-ohms can be set via platform data or device tree in
+compile-time or via the shunt_resistor attribute in sysfs in run-time. Please
+refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings if
+the device tree is used.
+
+The averaging rate of INA226 and INA230 can be changed via the avg_rate sysfs
+attribute. The available rates are: 1, 4, 16, 64, 128, 256, 512 and 1024.
-- 
2.1.3

