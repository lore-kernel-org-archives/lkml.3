Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751AbaFLISX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:18:23 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:43614 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932727AbaFLIST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:18:19 -0400
Message-ID: <53996247.5020203@free.fr>
Date: Thu, 12 Jun 2014 10:18:15 +0200
From: Guillaume Gardet <guillaume.gardet@free.fr>
Reply-To: guillaume.gardet@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
        openSUSE Kernel ML <opensuse-kernel@opensuse.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, Girish K S <ks.giri@samsung.com>,
        Yuvaraj C D <yuvaraj.cd@samsung.com>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] phy: Fix typo in drivers/phy/phy-exynos5250-sata.c module
 which fixes the build
X-Enigmail-Version: 1.6
OpenPGP: url=http://guillaume.gardet.free.fr/GPG/ClefGPGGuillaumeGardet.asc
Content-Type: multipart/mixed;
 boundary="------------040002000306090900000601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040002000306090900000601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

please find in attachment a patch which fixes a typo in drivers/phy/phy-exynos5250-sata.c module license.
It fixes the following build error:
    FATAL: modpost: GPL-incompatible module phy-exynos5250-sata.ko uses GPL-only symbol 'platform_driver_unregister'

Please keep me in CC since I am not subscribed to the linux-kernel@vger.kernel.org ML.

Signed-off-by: Guillaume GARDET <guillaume.gardet@opensuse.org>


Regards,

Guillaume


--------------040002000306090900000601
Content-Type: text/x-patch;
 name="0001-Fix-typo-in-drivers-phy-phy-exynos5250-sata.c-module.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-typo-in-drivers-phy-phy-exynos5250-sata.c-module.pa";
 filename*1="tch"

>From d46b09fbf39bb8820b65e064482b923252379b8a Mon Sep 17 00:00:00 2001
From: Guillaume GARDET <guillaume.gardet@opensuse.org>
Date: Thu, 12 Jun 2014 10:02:15 +0200
Subject: [PATCH] Fix typo in drivers/phy/phy-exynos5250-sata.c module
 license. It fixes the following error: FATAL: modpost:
 GPL-incompatible module phy-exynos5250-sata.ko uses
 GPL-only symbol 'platform_driver_unregister'

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
1.7.10.4


--------------040002000306090900000601--
