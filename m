Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbaDWPEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:04:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32893 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158AbaDWPBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:01:15 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <marcel@holtmann.org>, <gustavo@padovan.org>, <johan.hedberg@gmail.com>,
        <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 07/13] tty: serial: omap: cleanup variable declarations
Date: Wed, 23 Apr 2014 09:58:31 -0500
Message-ID: <1398265117-11793-7-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
In-Reply-To: <1398265117-11793-1-git-send-email-balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup only, no functional changes.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 07d4273..3813740 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1641,10 +1641,13 @@ static int serial_omap_probe_rs485(struct uart_omap_port *up,
 
 static int serial_omap_probe(struct platform_device *pdev)
 {
-	struct uart_omap_port	*up;
-	struct resource		*mem, *irq;
 	struct omap_uart_port_info *omap_up_info = dev_get_platdata(&pdev->dev);
-	int ret, uartirq = 0, wakeirq = 0;
+	struct uart_omap_port *up;
+	struct resource *mem;
+	struct resource *irq;
+	int uartirq = 0;
+	int wakeirq = 0;
+	int ret;
 
 	/* The optional wakeirq may be specified in the board dts file */
 	if (pdev->dev.of_node) {
-- 
1.9.2.459.g68773ac

