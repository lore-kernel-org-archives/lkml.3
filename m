Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaJFJIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:08:15 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:62329 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbaJFJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:08:13 -0400
Message-ID: <1412586485.4054.40.camel@x220>
Subject: [PATCH 2/4] [media] exynos4-is: Remove optional dependency on
 PLAT_S5P
From: Paul Bolle <pebolle@tiscali.nl>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 11:08:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 09:08:11.0238 (UTC) FILETIME=[0D7DE060:01CFE145]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
removed the Kconfig symbol PLAT_S5P. Remove an optional dependency on
that symbol from this Kconfig file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/media/platform/exynos4-is/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 77c951237744..775c3278d0eb 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -2,7 +2,7 @@
 config VIDEO_SAMSUNG_EXYNOS4_IS
 	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
-	depends on (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
+	depends on (ARCH_EXYNOS || COMPILE_TEST)
 	depends on OF && COMMON_CLK
 	help
 	  Say Y here to enable camera host interface devices for
-- 
1.9.3

