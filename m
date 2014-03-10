Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaCJSA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:00:56 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.139]:20805 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525AbaCJSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:00:54 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-3.tower-179.messagelabs.com!1394474451!31164166!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201403101800.s2AI0nId021436@swsrvapps-01.diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Mon, 10 Mar 2014 17:51:45 +0000
Subject: [PATCH V1] MAINTAINERS: Addition of Dialog Semiconductor files
To: Joe Perches <joe@perches.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Addition of support e-mail address for Dialog Semiconductor Ltd

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
Checks performed with linux-next/next-20140307/scripts/checkpatch.pl
 MAINTAINERS               total: 0 errors, 0 warnings, 9942 lines checked
This patch applies against linux-next and next-20140307

Dialog Semiconductor would like to add a new section called DIALOG
SEMICONDUCTOR DRIVERS which contains the new e-mail address which
can cover Dialog supported drivers: support.opensource@diasemi.com.

Change History:
- An alteration to the previous patch has been made according to
  the comments provided by Joe Perches in the previous RFC V1 e-mail
  thread, see here: https://lkml.org/lkml/2014/3/7/216
  - Changing the L: (mailing-list) to M: (mail patches to) for the
    support.opensource address.

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 MAINTAINERS |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ab32ad5..d019702 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2737,6 +2737,34 @@ F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
 F:	include/uapi/linux/dm-*.h
 
+DIALOG SEMICONDUCTOR DRIVERS
+M:	Support Opensource <support.opensource@diasemi.com>
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
end-of-patch for PATCH V1

