Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3CRK47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:56:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59133 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3CRK44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:56:56 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: [PATCH 1/2] driver: serial-omap: move max uart count into generic header file.
Date: Mon, 18 Mar 2013 16:26:46 +0530
Message-ID: <1363604206-11264-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP_MAX_HSUART_PORTS is moved to omap_serial header file.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Rajendra nayak <rnayak@ti.com>
Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
 drivers/tty/serial/omap-serial.c          |    2 --
 include/linux/platform_data/serial-omap.h |    1 +
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 5722eaf..4c2ba9f 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -43,8 +43,6 @@
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/serial-omap.h>
 
-#define OMAP_MAX_HSUART_PORTS	6
-
 #define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))
 
 #define OMAP_UART_REV_42 0x0402
diff --git a/include/linux/platform_data/serial-omap.h b/include/linux/platform_data/serial-omap.h
index ff9b0aa..92c48c2 100644
--- a/include/linux/platform_data/serial-omap.h
+++ b/include/linux/platform_data/serial-omap.h
@@ -29,6 +29,7 @@
  * is used as console uart.
  */
 #define OMAP_SERIAL_NAME	"ttyO"
+#define OMAP_MAX_HSUART_PORTS   6
 
 struct omap_uart_port_info {
 	bool			dma_enabled;	/* To specify DMA Mode */
-- 
1.7.1

