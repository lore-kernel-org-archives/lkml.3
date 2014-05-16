Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbaEPNDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:03:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55306 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaEPNDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:22 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/11] PHY: Exynos: fix SATA phy license typo
Date: Fri, 16 May 2014 18:32:58 +0530
Message-ID: <1400245387-14445-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400245387-14445-1-git-send-email-kishon@ti.com>
References: <1400245387-14445-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

If the license string doesn't match exactly, the module refuses to load.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-exynos5250-sata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/phy-exynos5250-sata.c b/drivers/phy/phy-exynos5250-sata.c
index c9361b7..0568945 100644
--- a/drivers/phy/phy-exynos5250-sata.c
+++ b/drivers/phy/phy-exynos5250-sata.c
@@ -246,6 +246,6 @@ static struct platform_driver exynos_sata_phy_driver = {
 module_platform_driver(exynos_sata_phy_driver);
 
 MODULE_DESCRIPTION("Samsung SerDes PHY driver");
-MODULE_LICENSE("GPL V2");
+MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
 MODULE_AUTHOR("Yuvaraj C D <yuvaraj.cd@samsung.com>");
-- 
1.7.9.5

