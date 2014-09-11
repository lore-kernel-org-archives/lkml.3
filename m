Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaIKOmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:42:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47012 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752286AbaIKOmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:42:07 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] irqchip: atmel-aic5: sama5d3 has 48 IRQs
Date: Thu, 11 Sep 2014 16:41:51 +0200
Message-Id: <1410446511-29477-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FUSE and RAM controllers don't have any connected IRQs, reducing the number
of IRQs to 48.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/irqchip/irq-atmel-aic5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-atmel-aic5.c b/drivers/irqchip/irq-atmel-aic5.c
index 04fe2c1b5178..dc7d98607a89 100644
--- a/drivers/irqchip/irq-atmel-aic5.c
+++ b/drivers/irqchip/irq-atmel-aic5.c
@@ -341,7 +341,7 @@ static int __init aic5_of_init(struct device_node *node,
 	return 0;
 }
 
-#define NR_SAMA5D3_IRQS		50
+#define NR_SAMA5D3_IRQS		48
 
 static int __init sama5d3_aic5_of_init(struct device_node *node,
 				       struct device_node *parent)
-- 
1.9.1

