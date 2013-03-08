Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383Ab3CHQWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:22:05 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64197 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517Ab3CHQWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:22:03 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 08 Mar 2013 10:22:02 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors@lm-sensors.org
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] MAINTAINERS: Add maintainer for MAX6697, INA209, and INA2XX drivers
Date: Fri,  8 Mar 2013 08:22:02 -0800
Message-Id: <1362759722-8252-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I actively maintain those drivers and have hardware available
to test changes, so add me as explicit maintainer.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 MAINTAINERS |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9561658..1a5aca7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4005,6 +4005,22 @@ M:	Stanislaw Gruszka <stf_xl@wp.pl>
 S:	Maintained
 F:	drivers/usb/atm/ueagle-atm.c
 
+INA209 HARDWARE MONITOR DRIVER
+M:	Guenter Roeck <linux@roeck-us.net>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	Documentation/hwmon/ina209
+F:	Documentation/devicetree/bindings/i2c/ina209.txt
+F:	drivers/hwmon/ina209.c
+
+INA2XX HARDWARE MONITOR DRIVER
+M:	Guenter Roeck <linux@roeck-us.net>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	Documentation/hwmon/ina2xx
+F:	drivers/hwmon/ina2xx.c
+F:	include/linux/platform_data/ina2xx.h
+
 INDUSTRY PACK SUBSYSTEM (IPACK)
 M:	Samuel Iglesias Gonsalvez <siglesias@igalia.com>
 M:	Jens Taprogge <jens.taprogge@taprogge.org>
@@ -5098,6 +5114,15 @@ S:	Maintained
 F:	Documentation/hwmon/max6650
 F:	drivers/hwmon/max6650.c
 
+MAX6697 HARDWARE MONITOR DRIVER
+M:	Guenter Roeck <linux@roeck-us.net>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	Documentation/hwmon/max6697
+F:	Documentation/devicetree/bindings/i2c/max6697.txt
+F:	drivers/hwmon/max6697.c
+F:	include/linux/platform_data/max6697.h
+
 MAXIRADIO FM RADIO RECEIVER DRIVER
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 L:	linux-media@vger.kernel.org
-- 
1.7.9.7

