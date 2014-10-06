Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaJFJHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:07:40 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52243 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbaJFJHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:07:35 -0400
Message-ID: <1412586453.4054.39.camel@x220>
Subject: [PATCH 1/4] [media] Remove optional dependencies on PLAT_S5P
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 11:07:33 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 09:07:33.0819 (UTC) FILETIME=[F73030B0:01CFE144]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
removed the Kconfig symbol PLAT_S5P. Remove three optional dependencies
on that symbol from this Kconfig file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/media/platform/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index bee9074ebc13..19774b60ba38 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -166,7 +166,7 @@ config VIDEO_MEM2MEM_DEINTERLACE
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -178,7 +178,7 @@ config VIDEO_SAMSUNG_S5P_G2D
 config VIDEO_SAMSUNG_S5P_JPEG
 	tristate "Samsung S5P/Exynos3250/Exynos4 JPEG codec driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
@@ -189,7 +189,7 @@ config VIDEO_SAMSUNG_S5P_JPEG
 config VIDEO_SAMSUNG_S5P_MFC
 	tristate "Samsung S5P MFC Video Codec"
 	depends on VIDEO_DEV && VIDEO_V4L2
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_EXYNOS || COMPILE_TEST
 	depends on HAS_DMA
 	select VIDEOBUF2_DMA_CONTIG
 	default n
-- 
1.9.3

