Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaDDFS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 01:18:59 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:36580 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaDDFSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 01:18:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20Shiraz=20has=20moved?=
Date: Fri,  4 Apr 2014 10:48:44 +0530
Message-Id: <b71ed4809df98a3e091ef727379835aeb44ba800.1396588666.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shiraz.hashim@st.com email-id doesn't exist anymore as he has left the
company. Replace ST's id with shiraz.linux.kernel@gmail.com.

It also updates .mailmap file to fix address for 'git shortlog'.

Cc: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 .mailmap                           | 1 +
 MAINTAINERS                        | 2 +-
 arch/arm/boot/dts/spear320-hmi.dts | 2 +-
 arch/arm/mach-spear/headsmp.S      | 2 +-
 arch/arm/mach-spear/platsmp.c      | 2 +-
 arch/arm/mach-spear/time.c         | 2 +-
 drivers/gpio/gpio-spear-spics.c    | 4 ++--
 drivers/irqchip/spear-shirq.c      | 2 +-
 drivers/mtd/devices/spear_smi.c    | 4 ++--
 drivers/pwm/pwm-spear.c            | 4 ++--
 include/linux/mtd/spear_smi.h      | 2 +-
 11 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/.mailmap b/.mailmap
index 658003a..df1baba 100644
--- a/.mailmap
+++ b/.mailmap
@@ -99,6 +99,7 @@ Sachin P Sant <ssant@in.ibm.com>
 Sam Ravnborg <sam@mars.ravnborg.org>
 Sascha Hauer <s.hauer@pengutronix.de>
 S.Çağlar Onur <caglar@pardus.org.tr>
+Shiraz Hashim <shiraz.linux.kernel@gmail.com> <shiraz.hashim@st.com>
 Simon Kelley <simon@thekelleys.org.uk>
 Stéphane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
 Stephen Hemminger <shemminger@osdl.org>
diff --git a/MAINTAINERS b/MAINTAINERS
index edd6139..014e5d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8143,7 +8143,7 @@ F:	include/linux/compiler.h
 
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <viresh.linux@gmail.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
+M:	Shiraz Hashim <shiraz.linux.kernel@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
diff --git a/arch/arm/boot/dts/spear320-hmi.dts b/arch/arm/boot/dts/spear320-hmi.dts
index 3075d2d..0aa6fef 100644
--- a/arch/arm/boot/dts/spear320-hmi.dts
+++ b/arch/arm/boot/dts/spear320-hmi.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 Evaluation Baord
  *
- * Copyright 2012 Shiraz Hashim <shiraz.hashim@st.com>
+ * Copyright 2012 Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/mach-spear/headsmp.S b/arch/arm/mach-spear/headsmp.S
index ed85473..c52192d 100644
--- a/arch/arm/mach-spear/headsmp.S
+++ b/arch/arm/mach-spear/headsmp.S
@@ -3,7 +3,7 @@
  *
  * Picked from realview
  * Copyright (c) 2012 ST Microelectronics Limited
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index 5c4a198..c19751f 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -4,7 +4,7 @@
  * based upon linux/arch/arm/mach-realview/platsmp.c
  *
  * Copyright (C) 2012 ST Microelectronics Ltd.
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/arch/arm/mach-spear/time.c b/arch/arm/mach-spear/time.c
index d449673..e43516d 100644
--- a/arch/arm/mach-spear/time.c
+++ b/arch/arm/mach-spear/time.c
@@ -2,7 +2,7 @@
  * arch/arm/plat-spear/time.c
  *
  * Copyright (C) 2010 ST Microelectronics
- * Shiraz Hashim<shiraz.hashim@st.com>
+ * Shiraz Hashim<shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/gpio/gpio-spear-spics.c b/drivers/gpio/gpio-spear-spics.c
index e9a0415..30bcc53 100644
--- a/drivers/gpio/gpio-spear-spics.c
+++ b/drivers/gpio/gpio-spear-spics.c
@@ -2,7 +2,7 @@
  * SPEAr platform SPI chipselect abstraction over gpiolib
  *
  * Copyright (C) 2012 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -205,6 +205,6 @@ static int __init spics_gpio_init(void)
 }
 subsys_initcall(spics_gpio_init);
 
-MODULE_AUTHOR("Shiraz Hashim <shiraz.hashim@st.com>");
+MODULE_AUTHOR("Shiraz Hashim <shiraz.linux.kernel@gmail.com>");
 MODULE_DESCRIPTION("ST Microlectronics SPEAr SPI Chip Select Abstraction");
 MODULE_LICENSE("GPL");
diff --git a/drivers/irqchip/spear-shirq.c b/drivers/irqchip/spear-shirq.c
index 8527743..3fdda3a 100644
--- a/drivers/irqchip/spear-shirq.c
+++ b/drivers/irqchip/spear-shirq.c
@@ -5,7 +5,7 @@
  * Viresh Kumar <viresh.linux@gmail.com>
  *
  * Copyright (C) 2012 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/mtd/devices/spear_smi.c b/drivers/mtd/devices/spear_smi.c
index 4238214..e52c880 100644
--- a/drivers/mtd/devices/spear_smi.c
+++ b/drivers/mtd/devices/spear_smi.c
@@ -6,7 +6,7 @@
  *
  * Copyright © 2010 STMicroelectronics.
  * Ashish Priyadarshi
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -1091,5 +1091,5 @@ static struct platform_driver spear_smi_driver = {
 module_platform_driver(spear_smi_driver);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Ashish Priyadarshi, Shiraz Hashim <shiraz.hashim@st.com>");
+MODULE_AUTHOR("Ashish Priyadarshi, Shiraz Hashim <shiraz.linux.kernel@gmail.com>");
 MODULE_DESCRIPTION("MTD SMI driver for serial nor flash chips");
diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index 8ad26b8..cb2d4f0 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -2,7 +2,7 @@
  * ST Microelectronics SPEAr Pulse Width Modulator driver
  *
  * Copyright (C) 2012 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -264,6 +264,6 @@ static struct platform_driver spear_pwm_driver = {
 module_platform_driver(spear_pwm_driver);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Shiraz Hashim <shiraz.hashim@st.com>");
+MODULE_AUTHOR("Shiraz Hashim <shiraz.linux.kernel@gmail.com>");
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.com>");
 MODULE_ALIAS("platform:spear-pwm");
diff --git a/include/linux/mtd/spear_smi.h b/include/linux/mtd/spear_smi.h
index 8ae1726..581603a 100644
--- a/include/linux/mtd/spear_smi.h
+++ b/include/linux/mtd/spear_smi.h
@@ -1,6 +1,6 @@
 /*
  * Copyright © 2010 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
-- 
1.7.12.rc2.18.g61b472e

