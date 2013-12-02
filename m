Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3LBN6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:58:25 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9434 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3LBN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:58:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 02 Dec 2013 05:55:29 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>
CC: <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <thierry.reding@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/2] ARM: dts: tegra: Header file for pinctrl constants
Date: Mon, 2 Dec 2013 19:25:01 +0530
Message-ID: <1385992502-12771-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines pincontrol constants to use from Tegra's DTS file
for tegra pincontrol properties option.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 include/dt-bindings/pinctrl/pinctrl-tegra.h |   65 +++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra.h

diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra.h b/include/dt-bindings/pinctrl/pinctrl-tegra.h
new file mode 100644
index 0000000..c2bfa3f
--- /dev/null
+++ b/include/dt-bindings/pinctrl/pinctrl-tegra.h
@@ -0,0 +1,65 @@
+/*
+ * This header provides constants for TEGRA pinctrl bindings.
+ *
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef _DT_BINDINGS_PINCTRL_TEGRA_H
+#define _DT_BINDINGS_PINCTRL_TEGRA_H
+
+/* Input/output */
+#define TEGRA_PIN_OUTPUT				0
+#define TEGRA_PIN_INPUT					1
+
+/* Pull up/down/normal */
+#define TEGRA_PIN_PUPD_NORMAL				0
+#define TEGRA_PIN_PUPD_PULL_DOWN			1
+#define TEGRA_PIN_PUPD_PULL_UP				2
+
+/* Tristate/normal */
+#define TEGRA_PIN_NORMAL				0
+#define TEGRA_PIN_TRISTATE				1
+
+/* Rcv Sel enable/disable */
+#define TEGRA_PIN_RCV_SEL_DISABLE			0
+#define TEGRA_PIN_RCV_SEL_ENABLE			1
+
+/* Lock enable/disable */
+#define TEGRA_PIN_LOCK_DISABLE				0
+#define TEGRA_PIN_LOCK_ENABLE				1
+
+/* Open drain enable/disable */
+#define TEGRA_PIN_OPEN_DRAIN_DISABLE			0
+#define TEGRA_PIN_OPEN_DRAIN_ENABLE			1
+
+/* High speed mode */
+#define TEGRA_PIN_DRIVE_HIGH_SPEED_MODE_DISABLE		0
+#define TEGRA_PIN_DRIVE_HIGH_SPEED_MODE_ENABLE		1
+
+/* Schmitt enable/disable */
+#define TEGRA_PIN_DRIVE_SCHMITT_DISABLE			0
+#define TEGRA_PIN_DRIVE_SCHMITT_ENABLE			1
+
+/* Low power mode */
+#define TEGRA_PIN_LP_DRIVE_DIV_8			0
+#define TEGRA_PIN_LP_DRIVE_DIV_4			1
+#define TEGRA_PIN_LP_DRIVE_DIV_2			2
+#define TEGRA_PIN_LP_DRIVE_DIV_1			3
+
+#define TEGRA_PIN_SLEW_RATE_FASTEST			0
+#define TEGRA_PIN_SLEW_RATE_FAST			1
+#define TEGRA_PIN_SLEW_RATE_SLOW			2
+#define TEGRA_PIN_SLEW_RATE_SLOWEST			3
+
+#endif
-- 
1.7.1.1

