Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965308AbaCTTi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:38:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53493 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933625AbaCTTcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:00 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 03/11] tty: serial: omap: cleanup variable declarations
Date: Thu, 20 Mar 2014 14:29:59 -0500
Message-ID: <1395343807-21618-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
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
index db5d90b..6831425 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1624,10 +1624,13 @@ static int serial_omap_probe_rs485(struct uart_omap_port *up,
 
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
1.9.1.286.g5172cb3

