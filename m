Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3JDMgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:36:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13608 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab3JDMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:36:48 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-92-524eb65f1bbd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] thermal: offer Samsung thermal support only when ARCH_EXYNOS
 is defined
Date: Fri, 04 Oct 2013 14:36:42 +0200
Message-id: <2958660.aJeCDrTTOe@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jQd34bX5BBpPWClk0XA2xWLP/J5PF
	2aY37BaXd81hs/jce4TRYsb5fUwWTx72sTmweyze85LJo2/LKkaP4ze2M3l83iQXwBLFZZOS
	mpNZllqkb5fAlTFxxiHGgq1sFb07VrI2MG5n7WLk5JAQMJG4Me0KC4QtJnHh3nq2LkYuDiGB
	6YwSn9s3sEI4LUwS8xfeAqtiE7CSmNi+ihHEFhHQk7jx4gkTiM0scI9R4uKXLBBbWCBK4tLf
	ZqB6Dg4WAVWJpq+yIGFeAU2J/+/Xs4PYogKeEp8mLWWGiAtK/Jh8jwVijLzEvv1TWSFsLYn1
	O48zTWDkm4WkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7UZ1I7GFc2
	WBxiFOBgVOLhFaj1DRJiTSwrrsw9xCjBwawkwnt8kl+QEG9KYmVValF+fFFpTmrxIUZpDhYl
	cd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsaW8ATRj9LlpX/D3vr4vDFRP6VRrKTN86gibdfJ
	lH2tu4JLOu4ff/RfV/NP6UaBDWdfn4jsX5l0tiDsX2vd6kprdY8jq/tFdKd4rH1rVrBflyv5
	Rd+U3+7FMoq3DRMX77s+KfpFyqSVdt6qIm3vbs1cwtn6aBKX1yrut4L/nUvUTO8Yv3XKWqrE
	UpyRaKjFXFScCABIFbIEUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Menu for Samsung thermal support is visible on all Samsung
platforms while thermal drivers are currently available only
for EXYNOS SoCs. Fix it by replacing PLAT_SAMSUNG dependency
with ARCH_EXYNOS one.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/thermal/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index a709c63..05cf95c 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -198,7 +198,7 @@ source "drivers/thermal/ti-soc-thermal/Kconfig"
 endmenu
 
 menu "Samsung thermal drivers"
-depends on PLAT_SAMSUNG
+depends on ARCH_EXYNOS
 source "drivers/thermal/samsung/Kconfig"
 endmenu
 
-- 
1.8.2.3


