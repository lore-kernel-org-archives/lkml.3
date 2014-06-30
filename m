Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaF3NDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 09:03:50 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:39144 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaF3NCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 09:02:18 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH 2/5] phy: miphy365x: Add MiPHY365x header file for DT x Driver defines
Date: Mon, 30 Jun 2014 14:01:54 +0100
Message-Id: <1404133317-25953-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org>
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

