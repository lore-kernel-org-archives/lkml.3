Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3GHQwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:52:47 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35477 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3GHQwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:52:44 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Baruch Siach <baruch@tkos.co.il>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v2 1/2] clocksource/cadence_ttc: Remove unused header
Date: Mon,  8 Jul 2013 09:51:37 -0700
Message-Id: <1373302298-27957-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clk-provider.h header is not required by this driver.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clocksource/cadence_ttc_timer.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksource/cadence_ttc_timer.c
index 4cbe28c..0eefc8d 100644
--- a/drivers/clocksource/cadence_ttc_timer.c
+++ b/drivers/clocksource/cadence_ttc_timer.c
@@ -21,7 +21,6 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/slab.h>
-#include <linux/clk-provider.h>
 
 /*
  * This driver configures the 2 16-bit count-up timers as follows:
-- 
1.8.3.2

