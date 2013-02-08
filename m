Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab3BHJyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:54:50 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:11387 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab3BHJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:54:47 -0500
Date: Fri, 8 Feb 2013 10:54:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: Remove Mark M. Hoffman
Message-ID: <20130208105437.347ea5b4@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark M. Hoffman stopped working on the Linux kernel several years
ago, so he should no longer be listed as a driver maintainer. I'm not
even sure if his e-mail address still works.

I can take over 3 drivers he was responsible for, the 4th one will
fall down to the subsystem maintainer.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <w.sang@pengutronix.de>
---
Mark, if you have any objection, it's now or never.

 MAINTAINERS |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- linux-3.8-rc6.orig/MAINTAINERS	2013-02-02 13:17:46.160665445 +0100
+++ linux-3.8-rc6/MAINTAINERS	2013-02-08 10:47:01.933759899 +0100
@@ -1286,12 +1286,6 @@ S:	Maintained
 F:	drivers/platform/x86/asus*.c
 F:	drivers/platform/x86/eeepc*.c
 
-ASUS ASB100 HARDWARE MONITOR DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
-L:	lm-sensors@lm-sensors.org
-S:	Maintained
-F:	drivers/hwmon/asb100.c
-
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
 M:	Dan Williams <djbw@fb.com>
 W:	http://sourceforge.net/projects/xscaleiop
@@ -3751,7 +3745,7 @@ F:	drivers/i2c/busses/i2c-via.c
 F:	drivers/i2c/busses/i2c-viapro.c
 
 I2C/SMBUS STUB DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
+M:	Jean Delvare <khali@linux-fr.org>
 L:	linux-i2c@vger.kernel.org
 S:	Maintained
 F:	drivers/i2c/i2c-stub.c
@@ -6906,13 +6900,6 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/sis/sis900.*
 
-SIS 96X I2C/SMBUS DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
-L:	linux-i2c@vger.kernel.org
-S:	Maintained
-F:	Documentation/i2c/busses/i2c-sis96x
-F:	drivers/i2c/busses/i2c-sis96x.c
-
 SIS FRAMEBUFFER DRIVER
 M:	Thomas Winischhofer <thomas@winischhofer.net>
 W:	http://www.winischhofer.net/linuxsisvga.shtml
@@ -6990,7 +6977,7 @@ F:	Documentation/hwmon/sch5627
 F:	drivers/hwmon/sch5627.c
 
 SMSC47B397 HARDWARE MONITOR DRIVER
-M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
+M:	Jean Delvare <khali@linux-fr.org>
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	Documentation/hwmon/smsc47b397


-- 
Jean Delvare
