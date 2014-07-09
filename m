Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbaGILlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:41:32 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:49398 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbaGILla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:41:30 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com
Cc: lee.jones@linaro.org, kernel@stlinux.com
Subject: [PATCH v3 2/5] phy: miphy365x: Add MiPHY365x header file for DT x Driver defines
Date: Wed,  9 Jul 2014 12:41:11 +0100
Message-Id: <1404906074-31992-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
References: <1404906074-31992-1-git-send-email-lee.jones@linaro.org>
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
 include/dt-bindings/phy/phy-miphy365x.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 include/dt-bindings/phy/phy-miphy365x.h

diff --git a/include/dt-bindings/phy/phy-miphy365x.h b/include/dt-bindings/phy/phy-miphy365x.h
new file mode 100644
index 0000000..8ef8aba
--- /dev/null
+++ b/include/dt-bindings/phy/phy-miphy365x.h
@@ -0,0 +1,14 @@
+/*
+ * This header provides constants for the phy framework
+ * based on the STMicroelectronics MiPHY365x.
+ *
+ * Author: Lee Jones <lee.jones@linaro.org>
+ */
+#ifndef _DT_BINDINGS_PHY_MIPHY
+#define _DT_BINDINGS_PHY_MIPHY
+
+#define MIPHY_TYPE_SATA		1
+#define MIPHY_TYPE_PCIE		2
+#define MIPHY_TYPE_USB		3
+
+#endif /* _DT_BINDINGS_PHY_MIPHY */
-- 
1.8.3.2

