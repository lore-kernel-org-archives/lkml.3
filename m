Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3CMJqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:46:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3CMJqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:46:09 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, olof@lixom.net, sachin.kamat@linaro.org
Subject: [PATCH 1/1] irqchip: irq-gic: Fix checkpatch errors
Date: Wed, 13 Mar 2013 15:05:15 +0530
Message-Id: <1363167315-12753-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following errors:
ERROR: do not initialise statics to 0 or NULL
ERROR: space required after that ',' (ctx:VxV)

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
Compile tested and based on linux-next tree (20130313).
---
 drivers/irqchip/irq-gic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index a32e0d5..d06d5a4 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -127,7 +127,7 @@ static inline void gic_set_base_accessor(struct gic_chip_data *data,
 #else
 #define gic_data_dist_base(d)	((d)->dist_base.common_base)
 #define gic_data_cpu_base(d)	((d)->cpu_base.common_base)
-#define gic_set_base_accessor(d,f)
+#define gic_set_base_accessor(d, f)
 #endif
 
 static inline void __iomem *gic_dist_base(struct irq_data *d)
@@ -807,7 +807,7 @@ void __cpuinit gic_secondary_init(unsigned int gic_nr)
 }
 
 #ifdef CONFIG_OF
-static int gic_cnt __initdata = 0;
+static int gic_cnt __initdata;
 
 int __init gic_of_init(struct device_node *node, struct device_node *parent)
 {
-- 
1.7.4.1

