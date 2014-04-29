Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaD2HWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:22:00 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39151 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931AbaD2HVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:21:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 2/4] phy: miphy365x: Add MiPHY365x header file for DT x Driver defines
Date: Tue, 29 Apr 2014 08:21:32 +0100
Message-Id: <1398756095-32542-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398756095-32542-1-git-send-email-lee.jones@linaro.org>
References: <1398756095-32542-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the shared header file which will be reference from both
the MiPHY365x driver and its associated Device Tree node(s).

Cc: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/dt-bindings/phy/phy-miphy365x.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 include/dt-bindings/phy/phy-miphy365x.h

diff --git a/include/dt-bindings/phy/phy-miphy365x.h b/include/dt-bindings/phy/phy-miphy365x.h
new file mode 100644
index 0000000..8757c02
--- /dev/null
+++ b/include/dt-bindings/phy/phy-miphy365x.h
@@ -0,0 +1,25 @@
+/*
+ * This header provides constants for the phy framework
+ * based on the STMicroelectronics miphy365x.
+ */
+#ifndef _DT_BINDINGS_PHY_MIPHY
+#define _DT_BINDINGS_PHY_MIPHY
+
+/* Supports 16 ports without a datatype change (u8 & 0xF0). */
+#define MIPHY_PORT_0			0
+#define MIPHY_PORT_1			1
+#define MIPHY_PORT_2			2
+#define MIPHY_PORT_3			3
+
+/* Supports 16 types without a datatype change (u8 & 0x0F). */
+#define MIPHY_TYPE_SHIFT		4
+#define MIPHY_TYPE_SATA			(0 << MIPHY_TYPE_SHIFT)
+#define MIPHY_TYPE_PCIE			(1 << MIPHY_TYPE_SHIFT)
+#define MIPHY_TYPE_USB			(2 << MIPHY_TYPE_SHIFT)
+
+#define MIPHY_SATA_PORT0		(MIPHY_TYPE_SATA) | (MIPHY_PORT_0)
+#define MIPHY_SATA_PORT1		(MIPHY_TYPE_SATA) | (MIPHY_PORT_1)
+#define MIPHY_PCIE_PORT0		(MIPHY_TYPE_PCIE) | (MIPHY_PORT_0)
+#define MIPHY_PCIE_PORT1		(MIPHY_TYPE_PCIE) | (MIPHY_PORT_1)
+
+#endif /* _DT_BINDINGS_PHY_MIPHY */
-- 
1.8.3.2

