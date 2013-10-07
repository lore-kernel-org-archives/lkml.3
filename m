Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3JGBws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:52:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13020 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3JGBwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:52:44 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-d9-525213ded341
Date: Mon, 07 Oct 2013 10:52:30 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 01/20] iommu/exynos: do not include removed header
Message-id: <20131007105230.dd412c8aa151c35d9b3aea86@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zQ917wkFBBv17zS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlbHqSFnBYY6KX7f+MDcwTmLvYuTkkBAwkfh8
	/RsjhC0mceHeerYuRi4OIYFljBK7T09hhSl60XiBHSKxiFFi0et2sISQwCQmiQnvikFsFgFV
	ifMdfSwgNpuAlsTquccZQRpEBNqYJL42HmIBcZgFTjNLrNq9ghmkSljATeLax0lgk3gFHCXW
	nDjEBrHOQuJCUwc7RFxQ4sfke2BTmYGmbt7WxAphy0tsXvOWGWSohMBEDolLr98wQ5whIPFt
	Msg2DqCErMSmA8wQMyUlDq64wTKBUWQWkrGzkIydhWTsAkbmVYyiqQXJBcVJ6UUmesWJucWl
	eel6yfm5mxghcTxhB+O9A9aHGJOBVk5klhJNzgemgbySeENjMyMLUxNTYyNzSzPShJXEedVb
	rAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MK7bsKSM6/i2xQtfiyz9O53hVK3oFT72dXcC
	TSc53Wg6zb387UG7Y/GaPN89uCZsXOUsuLxri5Tbmugt1d9jXA6ZOb0+an1y6f1dRRp/XJv2
	qU6VzN7xblPO8/z1JjvKrezmJ+yKdY46kXTc6e+rD0EnM19FtgkGHf1WaBB64YP91vh/N72C
	OeKVWIozEg21mIuKEwF0Hl/r+QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAd17wkFBBp+bjSzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZA/SGkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj1ZGy
	gsMcFb9u/WFuYJzE3sXIySEhYCLxovEClC0mceHeerYuRi4OIYFFjBKLXrezgiSEBCYxSUx4
	VwxiswioSpzv6GMBsdkEtCRWzz3OCNIgItDGJPG18RALiMMscJpZYtXuFcwgVcICbhLXPk4C
	m8Qr4Cix5sQhNoh1FhIXmjrYIeKCEj8m3wObygw0dfO2JlYIW15i85q3zBMY+WYhKZuFpGwW
	krIFjMyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKTxDOpHYwrGywOMQpwMCrx8O64Hxgk
	xJpYVlyZe4hRgoNZSYT3Uh1QiDclsbIqtSg/vqg0J7X4EGMy0N8TmaVEk/OBCSyvJN7Q2MTM
	yNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhjNF/5YtmY+o8DiJY1ScyWu
	1t7NkL8ztW5ufl7LtUkBMRafj7x7vmBFmojJrpaHT3YfXyl30XMnl58/XymTANuMl4eFDm2K
	8bzPmbmLa8uPZ8/iWzi/yz7fPv3X8z/8s1f0iZdeneSnd2vipsDm0yxXLsSEv964h2vyLdOe
	fzUz158V1Qv+PEtQT4mlOCPRUIu5qDgRALs1h7dWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from
exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without
removing remaining use of it from exynos-iommu driver, thus causing a
compilation error.

This patch fixes the error by removing respective include line
from exynos-iommu.c.

CC: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 0740189..4876d35 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -12,6 +12,7 @@
 #define DEBUG
 #endif
 
+#include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -29,8 +30,6 @@
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 
-#include <mach/sysmmu.h>
-
 /* We does not consider super section mapping (16MB) */
 #define SECT_ORDER 20
 #define LPAGE_ORDER 16
-- 
1.7.2.5

