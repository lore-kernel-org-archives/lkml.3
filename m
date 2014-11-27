Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaK0G03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:26:29 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59551 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaK0G0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:22 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/25] phy: Add PHY header file for DT x Driver defines
Date: Thu, 27 Nov 2014 11:55:53 +0530
Message-ID: <1417069577-1169-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>

This provides the shared header file which will be reference from both
PHY driver and its associated Device Tree node(s).

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 include/dt-bindings/phy/phy.h |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 include/dt-bindings/phy/phy.h

diff --git a/include/dt-bindings/phy/phy.h b/include/dt-bindings/phy/phy.h
new file mode 100644
index 0000000..e8c6a3f
--- /dev/null
+++ b/include/dt-bindings/phy/phy.h
@@ -0,0 +1,18 @@
+/*
+ *
+ * This header provides constants for the phy framework
+ *
+ * Copyright (C) 2014 STMicroelectronics
+ * Author: Gabriel Fernandez <gabriel.fernandez@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _DT_BINDINGS_PHY
+#define _DT_BINDINGS_PHY
+
+#define PHY_TYPE_SATA		1
+#define PHY_TYPE_PCIE		2
+#define PHY_TYPE_USB2		3
+#define PHY_TYPE_USB3		4
+
+#endif /* _DT_BINDINGS_PHY */
-- 
1.7.9.5

