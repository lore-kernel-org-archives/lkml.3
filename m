Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaILOGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:06:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52567 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514AbaILOGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:06:20 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] phy: spear1310-miphy: fix driver dependencies
Date: Fri, 12 Sep 2014 19:36:13 +0530
Message-ID: <1410530774-6715-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530774-6715-1-git-send-email-kishon@ti.com>
References: <1410530774-6715-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

ST SPEAR1310-MIPHY support should be available only on
ST SPEAr1310 machine.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 4ff8cbb..0972c2b 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -214,6 +214,7 @@ config PHY_QCOM_IPQ806X_SATA
 config PHY_ST_SPEAR1310_MIPHY
 	tristate "ST SPEAR1310-MIPHY driver"
 	select GENERIC_PHY
+	depends on MACH_SPEAR1310 || COMPILE_TEST
 	help
 	  Support for ST SPEAr1310 MIPHY which can be used for PCIe and SATA.
 
-- 
1.7.9.5

