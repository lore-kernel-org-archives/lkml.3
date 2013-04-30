Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938Ab3D3X7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:59:13 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48095 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038Ab3D3X65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:58:57 -0400
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 1/7] tty: xuartps: Sort #includes alphabetically
Date: Tue, 30 Apr 2013 16:57:58 -0700
Message-Id: <1367366284-28304-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>
CC: linux-serial@vger.kernel.org
---
 drivers/tty/serial/xilinx_uartps.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 4e5c778..773732b 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -11,17 +11,17 @@
  *
  */
 
+#include <linux/clk.h>
+#include <linux/console.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
-#include <linux/console.h>
-#include <linux/clk.h>
-#include <linux/irq.h>
-#include <linux/io.h>
-#include <linux/of.h>
-#include <linux/module.h>
 
 #define XUARTPS_TTY_NAME	"ttyPS"
 #define XUARTPS_NAME		"xuartps"
-- 
1.8.2.2

