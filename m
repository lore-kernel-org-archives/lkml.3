Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaKDKxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:53:52 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:35288 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbaKDKxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:53:47 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v5 2/8] phy: miphy28lp: Add PHY header file for DT x Driver defines
Date: Tue,  4 Nov 2014 11:51:18 +0100
Message-Id: <1415098284-11182-3-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-04_05:2014-11-03,2014-11-04,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the shared header file which will be reference from both
PHY driver and its associated Device Tree node(s).

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 include/dt-bindings/phy/phy.h | 18 ++++++++++++++++++
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
1.9.1

