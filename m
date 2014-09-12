Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaILOGY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:06:24 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46551 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbaILOGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:06:22 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] phy: spear1340-miphy: fix driver dependencies
Date: Fri, 12 Sep 2014 19:36:14 +0530
Message-ID: <1410530774-6715-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410530774-6715-1-git-send-email-kishon@ti.com>
References: <1410530774-6715-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

ST SPEAR1340-MIPHY support should be available only on
ST SPEAr1340 machine.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Pratyush Anand <pratyush.anand@st.com>
Cc: Mohit Kumar <mohit.kumar@st.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 0972c2b..f833aa2 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -221,6 +221,7 @@ config PHY_ST_SPEAR1310_MIPHY
 config PHY_ST_SPEAR1340_MIPHY
 	tristate "ST SPEAR1340-MIPHY driver"
 	select GENERIC_PHY
+	depends on MACH_SPEAR1340 || COMPILE_TEST
 	help
 	  Support for ST SPEAr1340 MIPHY which can be used for PCIe and SATA.
 
-- 
1.7.9.5

