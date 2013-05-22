Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3EVHJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:09:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56742 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3EVHJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:09:47 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, KV Sujith <sujithkv@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 01/11] ARM: davinci: GPIO: Add platform data structure
Date: Wed, 22 May 2013 12:40:24 +0530
Message-ID: <1369206634-6778-2-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KV Sujith <sujithkv@ti.com>

Add struct davinci_gpio_platform_data davinci gpio module.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 include/linux/platform_data/gpio-davinci.h |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)
 create mode 100644 include/linux/platform_data/gpio-davinci.h

diff --git a/include/linux/platform_data/gpio-davinci.h b/include/linux/platform_data/gpio-davinci.h
new file mode 100644
index 0000000..f1c8277
--- /dev/null
+++ b/include/linux/platform_data/gpio-davinci.h
@@ -0,0 +1,27 @@
+/*
+ * gpio-davinci.h
+ *
+ * DaVinci GPIO Platform Related Defines
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __ASM_ARCH_DAVINCI_GPIO_H
+#define __ASM_ARCH_DAVINCI_GPIO_H
+
+struct davinci_gpio_platform_data {
+	u32	ngpio;
+	u32	gpio_unbanked;
+	u32	intc_irq_num;
+};
+
+#endif
-- 
1.7.9.5

