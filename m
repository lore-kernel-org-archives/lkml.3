Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbbAUPrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:47:32 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.164]:19020 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754194AbbAUPrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:47:14 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-8.tower-38.messagelabs.com!1421855230!8566223!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <a034cd332a8171fd18a821999e6aecd03ade19be.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1421854282.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 21 Jan 2015 15:47:08 +0000
Subject: [PATCH v6 7/7] MAINTAINERS: Include DA9150 files in Dialog Semiconductor
 support list.
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <linux-iio@vger.kernel.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, <support.opensource@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 MAINTAINERS | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fa3853..1e46651 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3085,12 +3085,15 @@ S:	Supported
 F:	Documentation/hwmon/da90??
 F:	drivers/gpio/gpio-da90??.c
 F:	drivers/hwmon/da90??-hwmon.c
+F:	drivers/iio/adc/da91??-*.c
 F:	drivers/input/misc/da90??_onkey.c
 F:	drivers/input/touchscreen/da9052_tsi.c
 F:	drivers/leds/leds-da90??.c
 F:	drivers/mfd/da903x.c
 F:	drivers/mfd/da90??-*.c
+F:	drivers/mfd/da91??-*.c
 F:	drivers/power/da9052-battery.c
+F:	drivers/power/da91??-*.c
 F:	drivers/regulator/da903x.c
 F:	drivers/regulator/da9???-regulator.[ch]
 F:	drivers/rtc/rtc-da90??.c
@@ -3100,6 +3103,7 @@ F:	include/linux/mfd/da903x.h
 F:	include/linux/mfd/da9052/
 F:	include/linux/mfd/da9055/
 F:	include/linux/mfd/da9063/
+F:	include/linux/mfd/da9150/
 F:	include/sound/da[79]*.h
 F:	sound/soc/codecs/da[79]*.[ch]

--
1.9.3

