Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaEWKjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:39:53 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:39696 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaEWKcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:41 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 52/71] clocksource: sh_mtu2: Sort headers alphabetically
Date: Fri, 23 May 2014 12:31:32 +0200
Message-Id: <1400841111-6683-52-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

This helps locating duplicates and inserting new headers.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Wolfram Sang <wsa@sang-engineering.com>
---
 drivers/clocksource/sh_mtu2.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index 510bd32..f2c1c36 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -13,22 +13,22 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/clk.h>
+#include <linux/clockchips.h>
+#include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/clk.h>
+#include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/err.h>
-#include <linux/clockchips.h>
-#include <linux/sh_timer.h>
-#include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
+#include <linux/sh_timer.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
 
 struct sh_mtu2_device;
 
-- 
1.7.9.5

