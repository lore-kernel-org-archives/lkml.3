Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaBNLYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:24:52 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:58127 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaBNLYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:24:12 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: alexandre.torgue@st.com, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 2/4] phy: miphy365x: Add MiPHY365x header file for DT x Driver defines
Date: Fri, 14 Feb 2014 11:23:54 +0000
Message-Id: <1392377036-12816-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
References: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the shared header file which will be reference from both
the MiPHY365x driver and its associated Device Tree node(s).

Cc: devicetree@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
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

