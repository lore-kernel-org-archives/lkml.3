Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaCGLpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 06:45:22 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.139]:11048 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbaCGLpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 06:45:18 -0500
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-10.tower-179.messagelabs.com!1394192714!29224497!2
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201403071145.s27BjBpg020540@swsrvapps-01.diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Fri, 7 Mar 2014 11:30:28 +0000
Subject: [RFC V1] MAINTAINERS: Addition of Dialog Semiconductor files
To: Joe Perches <joe@perches.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Addition of support mailing list for Dialog Semiconductor Ltd

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
Checks performed with next-20140307/scripts/checkpatch.pl
 MAINTAINERS               total: 0 errors, 0 warnings, 9942 lines checked
This patch applies against kernel version linux-next next-20140307

Dialog Semiconductor would like to add a new section called DIALOG
SEMICONDUCTOR DRIVERS which contains the new support mailing list
<support.opensource@diasemi.com> for Dialog supported drivers.

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 MAINTAINERS |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab32ad5..a1e6261 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2737,6 +2737,34 @@ F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 F:	include/uapi/linux/dm-*.h
 
+DIALOG SEMICONDUCTOR DRIVERS
+L:	Support Opensource <support.opensource@diasemi.com>
+W:	http://www.dialog-semiconductor.com/products
+S:	Supported
+F:	Documentation/hwmon/da90??
+F:	drivers/gpio/gpio-da90??.c
+F:	drivers/hwmon/da90??-hwmon.c
+F:	drivers/input/misc/da90??_onkey.c
+F:	drivers/input/touchscreen/da9052_tsi.c
+F:	drivers/leds/leds-da90??.c
+F:	drivers/mfd/da903x.c
+F:	drivers/mfd/da90??-*.c
+F:	drivers/power/da9052-battery.c
+F:	drivers/regulator/da903x.c
+F:	drivers/regulator/da9???-regulator.[ch]
+F:	drivers/rtc/rtc-da90??.c
+F:	drivers/video/backlight/da90??_bl.c
+F:	drivers/watchdog/da90??_wdt.c
+F:	include/linux/mfd/da903x.h
+F:	include/linux/mfd/da9052/
+F:	include/linux/mfd/da9055/
+F:	include/linux/mfd/da9063/
+F:	include/sound/da7213.h
+F:	include/sound/da9055.h
+F:	sound/soc/codecs/da7???.[ch]
+F:	sound/soc/codecs/da732x_reg.h
+F:	sound/soc/codecs/da9055.c
+
 DIGI NEO AND CLASSIC PCI PRODUCTS
 M:	Lidza Louina <lidza.louina@gmail.com>
 L:	driverdev-devel@linuxdriverproject.org
-- 
end-of-patch for RFC V1

