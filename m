Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965902AbaFSVel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:34:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:55664 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbaFSVej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:34:39 -0400
Message-Id: <20140619212712.948802939@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:34:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>, spear-devel@list.st.com
Subject: [patch 02/13] irqchip: spear_shirq: Kill pointless static
References: <20140619212606.431750473@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=spear-shirq-kill-pointless-static.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/irqchip/spear-shirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/irqchip/spear-shirq.c
===================================================================
--- linux.orig/drivers/irqchip/spear-shirq.c
+++ linux/drivers/irqchip/spear-shirq.c
@@ -252,7 +252,7 @@ static int __init shirq_init(struct spea
 		struct device_node *np)
 {
 	int i, irq_base, hwirq = 0, irq_nr = 0;
-	static struct irq_domain *shirq_domain;
+	struct irq_domain *shirq_domain;
 	void __iomem *base;
 
 	base = of_iomap(np, 0);


