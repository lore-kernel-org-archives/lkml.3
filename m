Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab3GEM3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36068 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352Ab3GEM3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:11 -0400
X-AuditID: cbfee68e-b7f276d000002279-31-51d6bc15f347
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
Subject: [PATCH v7 1/9] iommu/exynos: do not include removed header
Date: Fri, 05 Jul 2013 21:29:09 +0900
Message-id: <002901ce797b$3fce5c30$bf6b1490$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55d4SycBJ7YBdlQn+ABRApf5XqYA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t8zY12xPdcCDZY9ZrR4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZfRN
	m8leMJmt4tEB0wbGXtYuRk4OCQETiS0zO9ggbDGJC/fWA9lcHEICyxglpnU2whUtXTeVGSIx
	nVFi0vb97BDOX0aJh5/vg7WzCWhJrJ57nBHEFhG4yyjx8jwPSBGzwA0miQ2f2lhAEsICzhL3
	Xj0Cs1kEVCW+HWkAa+YVsJRY8vcoM4QtKPFj8j2wGmagoet3HmeCsOUlNq95ywxxkoLEjrOv
	oZbpSZy91wNVLyKx78U7RoiaRg6J039yIHYJSHybfAiohgMoLiux6QDUGEmJgytusExgFJuF
	ZPMsJJtnIdk8C8mGBYwsqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCIrpvB+PNA9aHGJOB
	1k9klhJNzgcmhLySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MFrndE9/8fTt6SMHVb4xLDrmzFwWKe4eMHvChnkZplIHOKbEtgWz1pVujTbeuVL1
	wAGba/0Lq60vBd38pBdzo/D1I9E77yZ/iHOsjBBYFb3FmlFyxfqVU3QL7+89+enyJrkPbyaH
	styxnaaXJa/DFB91wytfe0dhqcNejsV7Fhhq8/TMShOxX6HEUpyRaKjFXFScCAAjRy3s/gIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jQV3RPdcCDQ69sbJ4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsqiw6wWLdd7mRx4
	PJ4cnMfkMbvhIovHnWt72Dw2L6n3mHxjOaNH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8zomzaTvWAyW8WjA6YNjL2sXYycHBICJhJL101lhrDFJC7c
	W8/WxcjFISQwnVFi0vb97BDOX0aJh5/vs4FUsQloSayee5wRxBYRuMso8fI8D0gRs8ANJokN
	n9pYQBLCAs4S9149ArNZBFQlvh1pAGvmFbCUWPL3KDOELSjxY/I9sBpmoKHrdx5ngrDlJTav
	eQt1koLEjrOvoZbpSZy91wNVLyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4YTyT2sG4ssHiEKMAB6MSD69F09VAIdbEsuLK3EOMEhzMSiK8
	9gnXAoV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5jM8kriDY1NzIwsjcwsjEzMzUkTVhLn
	PdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBccnkrpgTzQ9195ZsPKvx5d4hviUxkU8TtEMclzkc
	X5wen7VT6Ph3f/HzV9J6z2hP8Tj22JxRSEP4vmtRwE+++KWn2vbPMi5+esdKcbuQqa2g27+W
	ez0rQhYJM15g+n57zw/2Azu+H350+M7jfn+DqYHJTOaNx2/E/Ql7eu3agsb7DLvVTjLkvVBi
	Kc5INNRiLipOBAAhi/ujXAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit remove <mach/sysmmu.h> which is removed.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 3f32d64..233f382 100644
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


