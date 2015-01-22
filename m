Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbbAVJtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 04:49:23 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61871 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbAVJtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 04:49:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, tglx@linutronix.de,
        jason@lakedaemon.net, devicetree@vger.kernel.org
Subject: [PATCH v2 RESEND 1/8] dt: bindings: Supply shared ST IRQ defines
Date: Thu, 22 Jan 2015 09:48:46 +0000
Message-Id: <1421920133-7914-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
References: <1421920133-7914-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These defines are used to allow values used for configuration to be
easily human readable and will lessen the chance of logical mistakes.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/dt-bindings/interrupt-controller/irq-st.h | 30 +++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 include/dt-bindings/interrupt-controller/irq-st.h

diff --git a/include/dt-bindings/interrupt-controller/irq-st.h b/include/dt-bindings/interrupt-controller/irq-st.h
new file mode 100644
index 0000000..4c59ace
--- /dev/null
+++ b/include/dt-bindings/interrupt-controller/irq-st.h
@@ -0,0 +1,30 @@
+/*
+ *  include/linux/irqchip/irq-st.h
+ *
+ *  Copyright (C) 2014 STMicroelectronics – All Rights Reserved
+ *
+ *  Author: Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _DT_BINDINGS_INTERRUPT_CONTROLLER_ST_H
+#define _DT_BINDINGS_INTERRUPT_CONTROLLER_ST_H
+
+#define ST_IRQ_SYSCFG_EXT_0		0
+#define ST_IRQ_SYSCFG_EXT_1		1
+#define ST_IRQ_SYSCFG_EXT_2		2
+#define ST_IRQ_SYSCFG_CTI_0		3
+#define ST_IRQ_SYSCFG_CTI_1		4
+#define ST_IRQ_SYSCFG_PMU_0		5
+#define ST_IRQ_SYSCFG_PMU_1		6
+#define ST_IRQ_SYSCFG_pl310_L2		7
+#define ST_IRQ_SYSCFG_DISABLED		0xFFFFFFFF
+
+#define ST_IRQ_SYSCFG_EXT_1_INV		0x1
+#define ST_IRQ_SYSCFG_EXT_2_INV		0x2
+#define ST_IRQ_SYSCFG_EXT_3_INV		0x4
+
+#endif
-- 
1.9.1

