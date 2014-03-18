Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaCROWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:22:52 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.146]:34036 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755358AbaCROWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:22:50 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-6.tower-180.messagelabs.com!1395152566!25038537!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201403181422.s2IEMgVv031077@swsrvapps-01.diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Tue, 18 Mar 2014 14:07:35 +0000
Subject: [PATCH V2] MAINTAINERS: Addition of Dialog Semiconductor files
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Samuel Ortiz" <sameo@linux.intel.com>
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
Checks performed with linux-next/next-20140318/scripts/checkpatch.pl
 MAINTAINERS               total: 0 errors, 0 warnings, 9993 lines checked

Hello,

This is the reason for the patch:

Dialog Semiconductor Ltd would like to add a new section called DIALOG
SEMICONDUCTOR DRIVERS which contains a new e-mail address that can
cover all Dialog supported drivers: support.opensource@diasemi.com.

My previous PATCH V1 had a little trouble finding a maintainer for the
MAINTAINERS file. After taking suggestions, I am now following the
get_maintainers results more closely. Hence I have added Andrew Morton's
name into the e-mail fields this time.

PATCH V1 was Acked by Mark Brown, but instead of resending the same
patch again I have updated it with the changes suggested in that ACK.
See here: https://lkml.org/lkml/2014/3/10/439

Change History:

- Since PATCH V1
  - An alteration suggested by Mark Brown to reduce the number of
    file entries in the include/sound and sound/soc/codecs directories
    has been made.
  - The e-mail To: field now includes Andrew Morton as suggested in
    this thread: https://lkml.org/lkml/2014/3/18/150

- Since RFC V1
  - An alteration according to the comments provided by Joe Perches
    in the RFC V1 e-mail thread, see here:
    https://lkml.org/lkml/2014/3/7/216
    Changing the L: (mailing-list) to M: (mail patches to) for the
    e-mail support.opensource address.

This patch applies against linux-next and next-20140318

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 MAINTAINERS |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 630cb9f..ddd552f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2754,6 +2754,31 @@ F:	include/linux/device-mapper.h
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
+F:	include/sound/da[79]*.h
+F:	sound/soc/codecs/da[79]*.[ch]
+
 DIGI NEO AND CLASSIC PCI PRODUCTS
 M:	Lidza Louina <lidza.louina@gmail.com>
 L:	driverdev-devel@linuxdriverproject.org
-- 
end-of-patch for PATCH V2

