Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbaA1Hpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 02:45:30 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:6955 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbaA1Hp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 02:45:28 -0500
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 11
X-BigFish: VS11(z4d03rzzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21bch1fc6hzz8275ch1de098h17326ah8275bh8275dh1de097h186068h1954cbhz31h87h2a8h839hd24he5bh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h13eah1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h129fi1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Sonic Zhang <sonic.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: <adi-buildroot-devel@lists.sourceforge.net>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: [PATCH] MAINTAINERS: ADI Linux development mailing lists change to the new server.
Date: Tue, 28 Jan 2014 15:48:53 +0800
Message-ID: <1390895333-30877-1-git-send-email-sonic.adi@gmail.com>
X-Mailer: git-send-email 1.8.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Update Blackfin arch branch maintainer's email as well.

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
---
 MAINTAINERS | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cacc88..bd49e70 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -288,36 +288,36 @@ F:	sound/pci/ad1889.*
 
 AD525X ANALOG DEVICES DIGITAL POTENTIOMETERS DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD5254
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/misc/ad525x_dpot.c
 
 AD5398 CURRENT REGULATOR DRIVER (AD5398/AD5821)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD5398
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/regulator/ad5398.c
 
 AD714X CAPACITANCE TOUCH SENSOR DRIVER (AD7142/3/7/8/7A)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7142
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/misc/ad714x.c
 
 AD7877 TOUCHSCREEN DRIVER
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7877
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/touchscreen/ad7877.c
 
 AD7879 TOUCHSCREEN DRIVER (AD7879/AD7889)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/AD7879
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/touchscreen/ad7879.c
 
@@ -353,8 +353,8 @@ F:	include/media/adp1653.h
 
 ADP5520 BACKLIGHT DRIVER WITH IO EXPANDER (ADP5520/ADP5501)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5520
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/mfd/adp5520.c
 F:	drivers/video/backlight/adp5520_bl.c
@@ -364,16 +364,16 @@ F:	drivers/input/keyboard/adp5520-keys.c
 
 ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP5588
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/keyboard/adp5588-keys.c
 F:	drivers/gpio/gpio-adp5588.c
 
 ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADP8860
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/video/backlight/adp8860_bl.c
 
@@ -399,8 +399,8 @@ F:	drivers/hwmon/adt7475.c
 
 ADXL34X THREE-AXIS DIGITAL ACCELEROMETER DRIVER (ADXL345/ADXL346)
 M:	Michael Hennerich <michael.hennerich@analog.com>
-L:	device-drivers-devel@blackfin.uclinux.org
 W:	http://wiki.analog.com/ADXL345
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	drivers/input/misc/adxl34x.c
 
@@ -588,9 +588,9 @@ F:	drivers/media/i2c/adv7604*
 
 ANALOG DEVICES INC ASOC CODEC DRIVERS
 M:	Lars-Peter Clausen <lars@metafoo.de>
-L:	device-drivers-devel@blackfin.uclinux.org
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://wiki.analog.com/
+W:	http://ez.analog.com/community/linux-device-drivers
 S:	Supported
 F:	sound/soc/codecs/adau*
 F:	sound/soc/codecs/adav*
@@ -599,7 +599,7 @@ F:	sound/soc/codecs/ssm*
 F:	sound/soc/codecs/sigmadsp.*
 
 ANALOG DEVICES INC ASOC DRIVERS
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org/
 S:	Supported
@@ -1666,56 +1666,54 @@ F:	fs/bfs/
 F:	include/uapi/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
-M:	Mike Frysinger <vapier@gentoo.org>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+M:	Steven Miao <realmz6@gmail.com>
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	arch/blackfin/
 
 BLACKFIN EMAC DRIVER
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/net/ethernet/adi/
 
 BLACKFIN RTC DRIVER
-M:	Mike Frysinger <vapier.adi@gmail.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
 BLACKFIN SDH DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/mmc/host/bfin_sdh.c
 
 BLACKFIN SERIAL DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/tty/serial/bfin_uart.c
 
 BLACKFIN WATCHDOG DRIVER
-M:	Mike Frysinger <vapier.adi@gmail.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/watchdog/bfin_wdt.c
 
 BLACKFIN I2C TWI DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/i2c/busses/i2c-bfin-twi.c
 
 BLACKFIN MEDIA DRIVER
 M:	Scott Jiang <scott.jiang.linux@gmail.com>
-L:	uclinux-dist-devel@blackfin.uclinux.org
+L:	adi-buildroot-devel@lists.sourceforge.net
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	drivers/media/platform/blackfin/
-- 
1.8.2.3


