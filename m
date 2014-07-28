Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaG1VRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:17:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55560 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaG1VRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:17:37 -0400
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
Subject: [PATCH 09/35] arm: omap: irq: rename omap3_intc_regs
Date: Mon, 28 Jul 2014 16:15:57 -0500
Message-ID: <1406582183-696-10-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.0.1.563.g66f467c
In-Reply-To: <1406582183-696-1-git-send-email-balbi@ti.com>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just to make it clearer that it can
be used on all omaps.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-omap2/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 38007b3..93fe0be 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -62,7 +62,7 @@ static void __iomem *omap_irq_base;
 static int omap_nr_irqs = 96;
 
 /* Structure to save interrupt controller context */
-struct omap3_intc_regs {
+struct omap_intc_regs {
 	u32 sysconfig;
 	u32 protection;
 	u32 idle;
@@ -266,7 +266,7 @@ void __init omap_intc_of_init(void)
 }
 
 #if defined(CONFIG_ARCH_OMAP3) || defined(CONFIG_SOC_AM33XX)
-static struct omap3_intc_regs intc_context;
+static struct omap_intc_regs intc_context;
 
 void omap_intc_save_context(void)
 {
-- 
2.0.1.563.g66f467c

