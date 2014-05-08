Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaEHOr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:47:59 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:54417 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaEHOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:47:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH 2/2] phy: exynos: fix SATA phy license typo
Date: Thu,  8 May 2014 16:46:54 +0200
Message-Id: <1399560433-1402630-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/0l7M1b7toiL37SHD+QCZXI00U6aXY543eXndi/wPRN
 VWOzouEltJakg7dH9TKBnmFdaeNJOps3ysS8xlsg6SsgTqYW/H
 IeXIjpL0ALbGkXXJ4539NzUcbgbPfzGJsTeJ1kO/lUC43LKVrg
 4pvuoye9jI4rk201ec0mUHiscB6Pj/4kgrR4gLXKFR9Jbn13w3
 ncwviW3uuKShCqbCZhL8cSaJk74Q71qTlKTvyZIKubJq7CSpYK
 m1xYTWRxdoZrU/Rhekrox7xBQYboIKBVRDVQCLt03aOkeeGKjM
 Ule4/fZnubqDjbeQKyBaH3eZvukGctSnz0X+4VgKNn5WhSTST9
 zs0eZkSOT83YoduRdpi0akx/qCzVC9PiCJlvYEyy+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the license string doesn't match exactly, the module refuses
to load.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org
---
 drivers/phy/phy-exynos5250-sata.c | 2 +-
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
1.8.3.2

