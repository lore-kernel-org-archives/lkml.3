Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaG1VVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:21:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33672 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbaG1VRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:49 -0400
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        <bcousson@baylibre.com>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>, <tglx@linutronix.de>,
        <jason@lakedaemon.net>, <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 33/35] irq: intc: comment style cleanup
Date: Mon, 28 Jul 2014 16:16:21 -0500
Message-ID: <1406582183-696-34-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no functional changes, just making sure comment
follows Coding Style.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/irqchip/irq-omap-intc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-omap-intc.c b/drivers/irqchip/irq-omap-intc.c
index c9ba502..342e0ab 100644
--- a/drivers/irqchip/irq-omap-intc.c
+++ b/drivers/irqchip/irq-omap-intc.c
@@ -327,9 +327,11 @@ out:
 		}
 	} while (irqnr);
 
-	/* If an irq is masked or deasserted while active, we will
+	/*
+	 * If an irq is masked or deasserted while active, we will
 	 * keep ending up here with no irq handled. So remove it from
-	 * the INTC with an ack.*/
+	 * the INTC with an ack.
+	 */
 	if (!handled_irq)
 		omap_ack_irq(NULL);
 }
-- 
2.0.1.563.g66f467c

