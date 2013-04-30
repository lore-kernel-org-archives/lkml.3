Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059Ab3D3X7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:59:22 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62294 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab3D3X7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:59:08 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/7] clocksource/cadence_ttc: Sort #includes alphabetically
Date: Tue, 30 Apr 2013 16:58:00 -0700
Message-Id: <1367366284-28304-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/clocksource/cadence_ttc_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 685bc60..ab8fc2c 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -16,12 +16,12 @@
  */
 
 #include <linux/clk.h>
-#include <linux/interrupt.h>
+#include <linux/clk-provider.h>
 #include <linux/clockchips.h>
+#include <linux/interrupt.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/slab.h>
-#include <linux/clk-provider.h>
 
 /*
  * This driver configures the 2 16-bit count-up timers as follows:
-- 
1.8.2.2

