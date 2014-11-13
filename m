Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbaKMLBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:01:10 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43857 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbaKMLBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:01:03 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 08/14] ARM: STi: DT: STiH410: Add defines for STiH410 DT clocks
Date: Thu, 13 Nov 2014 11:00:11 +0000
Message-Id: <1415876417-28728-9-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although most clock outputs are the same as stih407 SoC, stih410
also has some additional new clock outputs.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 include/dt-bindings/clock/stih410-clks.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 include/dt-bindings/clock/stih410-clks.h

diff --git a/include/dt-bindings/clock/stih410-clks.h b/include/dt-bindings/clock/stih410-clks.h
new file mode 100644
index 0000000..2097a4b
--- /dev/null
+++ b/include/dt-bindings/clock/stih410-clks.h
@@ -0,0 +1,25 @@
+/*
+ * This header provides constants clk index STMicroelectronics
+ * STiH410 SoC.
+ */
+#ifndef _DT_BINDINGS_CLK_STIH410
+#define _DT_BINDINGS_CLK_STIH410
+
+#include "stih407-clks.h"
+
+/* STiH410 introduces new clock outputs compared to STiH407 */
+
+/* CLOCKGEN C0 */
+#define CLK_TX_ICN_HADES	32
+#define CLK_RX_ICN_HADES	33
+#define CLK_ICN_REG_16		34
+#define CLK_PP_HADES		35
+#define CLK_CLUST_HADES		36
+#define CLK_HWPE_HADES		37
+#define CLK_FC_HADES		38
+
+/* CLOCKGEN D0 */
+#define CLK_PCMR10_MASTER	4
+#define CLK_USB2_PHY		5
+
+#endif
-- 
1.9.1

