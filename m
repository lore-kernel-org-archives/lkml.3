Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3KWF4D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 00:56:03 -0500
Received: from gnurou.org ([207.192.72.5]:40440 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3KWF4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 00:56:00 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] gpiolib: add missing declarations
Date: Sat, 23 Nov 2013 14:54:29 +0900
Message-Id: <1385186069-28986-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing declarations and include files to avoid warnings during
compilation of include/gpio/driver.h.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Reported-by: Stephen Warren <swarren@wwwdotorg.org>
---
 include/linux/gpio/driver.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 82eac61..3ea2cf6 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -2,9 +2,12 @@
 #define __LINUX_GPIO_DRIVER_H
 
 #include <linux/types.h>
+#include <linux/module.h>
 
 struct device;
 struct gpio_desc;
+struct of_phandle_args;
+struct device_node;
 struct seq_file;
 
 /**
-- 
1.8.4.2

