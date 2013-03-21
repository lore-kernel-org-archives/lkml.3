Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3CUSXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:23:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41695 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3CUSXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:23:30 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Cc: arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH REPOST 6/7] ARM: dt: add header to define IRQ flags
Date: Thu, 21 Mar 2013 12:23:13 -0600
Message-Id: <1363890194-31538-6-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363890194-31538-1-git-send-email-swarren@wwwdotorg.org>
References: <1363890194-31538-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Many IRQ device tree bindings use the same flags. Create a header to
define those.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Moved header. Added include guard.
---
 include/dt-bindings/interrupt-controller/irq.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 include/dt-bindings/interrupt-controller/irq.h

diff --git a/include/dt-bindings/interrupt-controller/irq.h b/include/dt-bindings/interrupt-controller/irq.h
new file mode 100644
index 0000000..33a1003
--- /dev/null
+++ b/include/dt-bindings/interrupt-controller/irq.h
@@ -0,0 +1,19 @@
+/*
+ * This header provides constants for most IRQ bindings.
+ *
+ * Most IRQ bindings include a flags cell as part of the IRQ specifier.
+ * In most cases, the format of the flags cell uses the standard values
+ * defined in this header.
+ */
+
+#ifndef _DT_BINDINGS_INTERRUPT_CONTROLLER_IRQ_H
+#define _DT_BINDINGS_INTERRUPT_CONTROLLER_IRQ_H
+
+#define IRQ_TYPE_NONE		0
+#define IRQ_TYPE_EDGE_RISING	1
+#define IRQ_TYPE_EDGE_FALLING	2
+#define IRQ_TYPE_EDGE_BOTH	(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING)
+#define IRQ_TYPE_LEVEL_HIGH	4
+#define IRQ_TYPE_LEVEL_LOW	8
+
+#endif
-- 
1.7.10.4

