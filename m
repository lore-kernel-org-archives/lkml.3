Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbaFPL0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:26:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41715 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbaFPL0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:26:21 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 08/16] irqchip: crossbar: fix kerneldoc warning
Date: Mon, 16 Jun 2014 16:53:08 +0530
Message-ID: <1402917796-31574-9-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

Adding missing properties for kerneldoc (@write) and cleanup
of harmless warnings while we are here.

kerneldoc warnings:
Warning(drivers/irqchip/irq-crossbar.c:27): missing initial short description on line:
 * struct crossbar_device: crossbar device description
Info(drivers/irqchip/irq-crossbar.c:27): Scanning doc for struct
Warning(drivers/irqchip/irq-crossbar.c:39): No description found for parameter 'write'
2 warnings

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
[V3] Reworded the commit log

 drivers/irqchip/irq-crossbar.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 2d7fbdb..6eee61b 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -22,12 +22,14 @@
 #define IRQ_SKIP	-3
 #define GIC_IRQ_START	32
 
-/*
+/**
+ * struct crossbar_device - crossbar device description
  * @int_max: maximum number of supported interrupts
  * @safe_map: safe default value to initialize the crossbar
  * @irq_map: array of interrupts to crossbar number mapping
  * @crossbar_base: crossbar base address
  * @register_offsets: offsets for each irq number
+ * @write: register write function pointer
  */
 struct crossbar_device {
 	uint int_max;
-- 
1.7.9.5

