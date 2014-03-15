Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaCOJh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 05:37:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62270 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaCOJhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 05:37:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] PHY: Exynos: fix SATA phy license typo
Date: Sat, 15 Mar 2014 10:37:12 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        Vasanth Ananthan <vasanth.a@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403151037.12694.arnd@arndb.de>
X-Provags-ID: V02:K0:sEtyZYlF/MyuELCA7F+iWFrW+SRQpCAIAbb7Z7ToDl3
 ecxOBGthyxy+zFLOlRGyWa2PGqHqYWbCtCGRPniZjcCKSaqWzs
 DPR4n6bysgIC5baRhvz/6obo3k4LaR3wr2Onu4YbnQoD/fJUxG
 pbg7xx9C3uPN66iJX9Oy5+ymIUllxxmJKpLuPRUIrM50iLj9/k
 RiItYmGomoRU9WzPUU9C2i0Kx4Uq/RIo+psm5GdVaSDXHyOdPD
 o/wZknaX/mFkDFHapyN3i2QddYlJJkBNzV3lw0Yc4Dhep/CQXL
 vJN5BIUrQGn6VwD07nuc+F3Z9Yr72eoIFb8K2t9a3vF/kgnXZ+
 VfaiTzxtxCzftTQC5p+2TA9xgpTTGGJMcPF4WMXQL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the license string doesn't match exactly, the module refuses to load.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

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
