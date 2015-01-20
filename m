Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbbATCFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:05:42 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41482 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbATCFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:39 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Cc: Rajendra Nayak <rnayak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 5/8] dt-bindings: Add #defines for IPQ806x lpass clock control
Date: Mon, 19 Jan 2015 18:05:32 -0800
Message-Id: <1421719535-28398-6-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
References: <1421719535-28398-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

Add defines to make more human readable numbers for the lpass
clock controller found on IPQ806x SoCs. Also remove the PLL4
define in gcc to avoid #define conflicts because that clock
doesn't exist in gcc, instead it lives in lcc.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
[sboyd@codeaurora.org: Split off into separate patch]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/dt-bindings/clock/qcom,gcc-ipq806x.h |  1 -
 include/dt-bindings/clock/qcom,lcc-ipq806x.h | 30 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)
 create mode 100644 include/dt-bindings/clock/qcom,lcc-ipq806x.h

diff --git a/include/dt-bindings/clock/qcom,gcc-ipq806x.h b/include/dt-bindings/clock/qcom,gcc-ipq806x.h
index b857cadb0bd4..04fb29ae30e6 100644
--- a/include/dt-bindings/clock/qcom,gcc-ipq806x.h
+++ b/include/dt-bindings/clock/qcom,gcc-ipq806x.h
@@ -238,7 +238,6 @@
 #define PLL0_VOTE				221
 #define PLL3					222
 #define PLL3_VOTE				223
-#define PLL4					224
 #define PLL4_VOTE				225
 #define PLL8					226
 #define PLL8_VOTE				227
diff --git a/include/dt-bindings/clock/qcom,lcc-ipq806x.h b/include/dt-bindings/clock/qcom,lcc-ipq806x.h
new file mode 100644
index 000000000000..4e944b85c56d
--- /dev/null
+++ b/include/dt-bindings/clock/qcom,lcc-ipq806x.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_CLK_LCC_IPQ806X_H
+#define _DT_BINDINGS_CLK_LCC_IPQ806X_H
+
+#define PLL4				0
+#define MI2S_OSR_SRC			1
+#define MI2S_OSR_CLK			2
+#define MI2S_DIV_CLK			3
+#define MI2S_BIT_DIV_CLK		4
+#define MI2S_BIT_CLK			5
+#define PCM_SRC				6
+#define PCM_CLK_OUT			7
+#define PCM_CLK				8
+#define SPDIF_SRC			9
+#define SPDIF_CLK			10
+#define AHBIX_CLK			11
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

