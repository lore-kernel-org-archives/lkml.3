Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3BMJje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:39:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43523 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3BMJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:04 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-74-511b5e47f7ec
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 1/9] extcon: gpio: Rename filename of extcon-gpio.c according
 to kernel naming style
Date: Wed, 13 Feb 2013 18:35:00 +0900
Message-id: <1360748100-21807-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t8zLV33OOlAgzkbtSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGhFsvmQoOqldcO7eZtYFxnUIXIyeHhICJxL4nrSwQtpjEhXvr
	2boYuTiEBJYxSnQ13mWCKVo+ZxMriC0kMJ1Roq89EqJoAZPEmbsLwYrYBLQk9r+4wQZiiwjI
	STy5/YcZxGYWqJU4ffkukM3BISyQJtH1xhckzCKgKnH8LMgyDg5eAVeJta/VIVbJSXzY84gd
	ZLyEwA42ickTNrFB1AtIfJt8iAWkXkJAVmLTAWaIekmJgytusExgFFzAyLCKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIyScpHYwrmywOMQowMGoxMPrECIVKMSaWFZcmXuIUYKDWUmE19Ff
	OlCINyWxsiq1KD++qDQntfgQYzLQ8onMUqLJ+cBQzyuJNzQ2MDY0tDQ0M7U0NSBNWEmcl/HU
	kwAhgfTEktTs1NSC1CKYLUwcnFINjOGO657MOvEt/Qp/Brfb339OOs2aK6usm/V7dqwtrOT0
	vXtek9vAXeLzlSbOeI9LZUGntvyYf8B72SlN6efflhimfOVrur5RfO8//rIvEueOr/2+hPl+
	04F494b3M0pVTgr8K2z/xiE+c7f01Z9H7DLWGl+resCo9DCxNS4jqri8x04/3qiQX4mlOCPR
	UIu5qDgRAGCxjZBrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoK57nHSgQV+TvMXlXXPYHBg9Pm+S
	C2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAGa
	qqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMmHDrJVPBQfWKa+c2szYw
	rlPoYuTkkBAwkVg+ZxMrhC0mceHeejYQW0hgOqNEX3tkFyMXkL2ASeLM3YVMIAk2AS2J/S9u
	gBWJCMhJPLn9hxnEZhaolTh9+S6QzcEhLJAm0fXGFyTMIqAqcfwsyEwODl4BV4m1r9UhVslJ
	fNjziH0CI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHB+kxqB+PKBotDjAIcjEo8
	vA4hUoFCrIllxZW5hxglOJiVRHgd/aUDhXhTEiurUovy44tKc1KLDzEmAy2fyCwlmpwPjKS8
	knhDYxMzI0sjM2MTc2Nj0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp1cC4IdK6frP8lTep
	pwMkl7bZ6axNOKTt8ejg9P6at6fvVR1ginSY0/El/pvZlXOsi8pmPZjMdrbRac4Zb94Fl1dN
	mjSFwfzTZVF/RRWj+Pw6Pp7vsw9KOQgcSX3BM2daofjGE8GvNNkVTFQuM5ye6B55eb+DzU7L
	J++7PefIRszLnVkSplxwqNZbiaU4I9FQi7moOBEA07XDuJoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-gpio.c       |  2 +-
 include/linux/extcon/extcon-gpio.h | 52 ++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/extcon_gpio.h | 52 --------------------------------------
 3 files changed, 53 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/extcon/extcon-gpio.h
 delete mode 100644 include/linux/extcon/extcon_gpio.h

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 1b14bfc..02bec32 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -29,7 +29,7 @@
 #include <linux/workqueue.h>
 #include <linux/gpio.h>
 #include <linux/extcon.h>
-#include <linux/extcon/extcon_gpio.h>
+#include <linux/extcon/extcon-gpio.h>
 
 struct gpio_extcon_data {
 	struct extcon_dev edev;
diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
new file mode 100644
index 0000000..2d8307f
--- /dev/null
+++ b/include/linux/extcon/extcon-gpio.h
@@ -0,0 +1,52 @@
+/*
+ *  External connector (extcon) class generic GPIO driver
+ *
+ * Copyright (C) 2012 Samsung Electronics
+ * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
+ *
+ * based on switch class driver
+ * Copyright (C) 2008 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+*/
+#ifndef __EXTCON_GPIO_H__
+#define __EXTCON_GPIO_H__ __FILE__
+
+#include <linux/extcon.h>
+
+/**
+ * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
+ * @name	The name of this GPIO extcon device.
+ * @gpio	Corresponding GPIO.
+ * @debounce	Debounce time for GPIO IRQ in ms.
+ * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
+ * @state_on	print_state is overriden with state_on if attached. If Null,
+ *		default method of extcon class is used.
+ * @state_off	print_state is overriden with state_on if detached. If Null,
+ *		default method of extcon class is used.
+ *
+ * Note that in order for state_on or state_off to be valid, both state_on
+ * and state_off should be not NULL. If at least one of them is NULL,
+ * the print_state is not overriden.
+ */
+struct gpio_extcon_platform_data {
+	const char *name;
+	unsigned gpio;
+	unsigned long debounce;
+	unsigned long irq_flags;
+
+	/* if NULL, "0" or "1" will be printed */
+	const char *state_on;
+	const char *state_off;
+};
+
+#endif /* __EXTCON_GPIO_H__ */
diff --git a/include/linux/extcon/extcon_gpio.h b/include/linux/extcon/extcon_gpio.h
deleted file mode 100644
index 2d8307f..0000000
--- a/include/linux/extcon/extcon_gpio.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/*
- *  External connector (extcon) class generic GPIO driver
- *
- * Copyright (C) 2012 Samsung Electronics
- * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
- *
- * based on switch class driver
- * Copyright (C) 2008 Google, Inc.
- * Author: Mike Lockwood <lockwood@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
-*/
-#ifndef __EXTCON_GPIO_H__
-#define __EXTCON_GPIO_H__ __FILE__
-
-#include <linux/extcon.h>
-
-/**
- * struct gpio_extcon_platform_data - A simple GPIO-controlled extcon device.
- * @name	The name of this GPIO extcon device.
- * @gpio	Corresponding GPIO.
- * @debounce	Debounce time for GPIO IRQ in ms.
- * @irq_flags	IRQ Flags (e.g., IRQF_TRIGGER_LOW).
- * @state_on	print_state is overriden with state_on if attached. If Null,
- *		default method of extcon class is used.
- * @state_off	print_state is overriden with state_on if detached. If Null,
- *		default method of extcon class is used.
- *
- * Note that in order for state_on or state_off to be valid, both state_on
- * and state_off should be not NULL. If at least one of them is NULL,
- * the print_state is not overriden.
- */
-struct gpio_extcon_platform_data {
-	const char *name;
-	unsigned gpio;
-	unsigned long debounce;
-	unsigned long irq_flags;
-
-	/* if NULL, "0" or "1" will be printed */
-	const char *state_on;
-	const char *state_off;
-};
-
-#endif /* __EXTCON_GPIO_H__ */
-- 
1.8.0

