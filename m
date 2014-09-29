Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaI2SHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:07:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:53229 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbaI2SG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:06:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 01/13] tty: serial: 8250: Fix wording in runtime-PM comments
Date: Mon, 29 Sep 2014 20:06:37 +0200
Message-Id: <1412014009-13315-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans reworded the two comments with better English for better
understanding. His review hit the mailing list after the patch got
applied so here is an incremental update.

Reported-by: Frans Klaver <frans.klaver@xsens.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 139f3d2b8aa9..a1904628a2a1 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -557,7 +557,7 @@ static void serial8250_rpm_put(struct uart_8250_port *p)
 }
 
 /*
- * This two wrapper ensure, that enable_runtime_pm_tx() can be called more than
+ * These two wrappers ensure that enable_runtime_pm_tx() can be called more than
  * once and disable_runtime_pm_tx() will still disable RPM because the fifo is
  * empty and the HW can idle again.
  */
@@ -1532,7 +1532,7 @@ void serial8250_tx_chars(struct uart_8250_port *up)
 	DEBUG_INTR("THRE...");
 
 	/*
-	 * With RPM enabled, we have to wait once the FIFO is empty before the
+	 * With RPM enabled, we have to wait until the FIFO is empty before the
 	 * HW can go idle. So we get here once again with empty FIFO and disable
 	 * the interrupt and RPM in __stop_tx()
 	 */
-- 
2.1.0

