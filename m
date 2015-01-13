Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbbAMSrQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:47:16 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37060 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752614AbbAMSq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:46:28 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 4/5] ARM: at91/dt: add AIC irq1 muxed peripheral id definitions
Date: Tue, 13 Jan 2015 19:46:20 +0100
Message-Id: <1421174781-4340-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These ids will be used to define irqs multiplexed on the first irq line.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 .../dt-bindings/interrupt-controller/atmel-aic.h   | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 include/dt-bindings/interrupt-controller/atmel-aic.h

diff --git a/include/dt-bindings/interrupt-controller/atmel-aic.h b/include/dt-bindings/interrupt-controller/atmel-aic.h
new file mode 100644
index 0000000..e14a94f
--- /dev/null
+++ b/include/dt-bindings/interrupt-controller/atmel-aic.h
@@ -0,0 +1,22 @@
+#ifndef _DT_BINDINGS_INTERRUPT_CONTROLLER_ARM_GIC_H
+#define _DT_BINDINGS_INTERRUPT_CONTROLLER_ARM_GIC_H
+
+#include <dt-bindings/interrupt-controller/irq.h>
+
+#define AIC_IRQ1_PMC		0
+#define AIC_IRQ1_ST		1
+#define AIC_IRQ1_PIT		1
+#define AIC_IRQ1_DBGU		2
+#define AIC_IRQ1_RTC		3
+#define AIC_IRQ1_RTT		4
+#define AIC_IRQ1_WATCHDOG	5
+#define AIC_IRQ1_MC		6
+#define AIC_IRQ1_SDRAMC		6
+#define AIC_IRQ1_DDRSDRC	6
+#define AIC_IRQ1_RSTC		7
+#define AIC_IRQ1_PMERRLOC	8
+#define AIC_IRQ1_PMECC		9
+
+#define AIC_IRQ_MASK(x)		(1 << x)
+
+#endif
-- 
1.9.1

