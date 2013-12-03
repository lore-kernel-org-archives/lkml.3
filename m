Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3LCNTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:19:04 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8652 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab3LCNS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:18:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Dec 2013 05:12:21 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>
CC: <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <thierry.reding@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/2] ARM: tegra: Add header file for pinctrl constants
Date: Tue, 3 Dec 2013 18:46:06 +0530
Message-ID: <1386076567-14283-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new header file defines pincontrol constants for Tegra to
use from Tegra's DTS file for pincontrol properties option.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Get rid of lots of macro and converge it to TEGRA_PIN_ENABLE/DISABLE.
- Change macro name for PULL UP/DOWN/NONE.

 include/dt-bindings/pinctrl/pinctrl-tegra.h |   40 +++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-tegra.h

diff --git a/include/dt-bindings/pinctrl/pinctrl-tegra.h b/include/dt-bindings/pinctrl/pinctrl-tegra.h
new file mode 100644
index 0000000..e5f02f8
--- /dev/null
+++ b/include/dt-bindings/pinctrl/pinctrl-tegra.h
@@ -0,0 +1,40 @@
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
+#define TEGRA_PIN_DISABLE				0
+#define TEGRA_PIN_ENABLE				1
+
+/* Pull up/down/normal */
+#define TEGRA_PIN_PULL_NONE				0
+#define TEGRA_PIN_PULL_DOWN				1
+#define TEGRA_PIN_PULL_UP				2
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

