Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207Ab3HHJhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:37:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50208 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964857Ab3HHJh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:37:27 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-be-520366d51d50
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>, "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v9 01/16] iommu/exynos: do not include removed header
Date: Thu, 08 Aug 2013 18:37:25 +0900
Message-id: <002501ce941a$e3d87f40$ab897dc0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF0ttA7tvTqQNRBmHuCApMD1fpQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zI92racxBBp8/m1jcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4o7hsUlJzMstSi/TtErgy+qbNZC+YzFbx6IBpA2MvaxcjJ4eEgInE7ssf2SBsMYkL99aD
	2UICyxgltq4Sh6m5/XElYxcjF1B8OqPEuXMLmCCcv4wSbafvgnWwCWhJrJ57HKxKROA3o8St
	Z3NYQRxmgf9MEltvN7F3MXJwCAu4Svy+EQnSwCKgKnHg8GOwZl4BS4kvcxuYIWxBiR+T77GA
	2MxAQ9fvPM4EYctLbF7zlhniJAWJHWdfM4LYIgJ6EptO7GOHqBGR2PfiHdgREgILOSSePXjD
	CLFMQOLb5EMsIDdICMhKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILi
	pPQiQ73ixNzi0rx0veT83E2MkMjv3cF4+4D1IcZkoPUTmaVEk/OBiSOvJN7Q2MzIwtTE1NjI
	3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwHSxz3bf1uavJ6SSbD4QcL
	TTiXuieEn/vH66vgwL6v78TJ3iqjYzxbpM9opm1pLD58PX6B/AV/xge55RrPfZ4JrJp/ffEj
	Lfk3C5y4vDKYPFcetDdyEs1S3H+zT/HE1asd9/V5WsRj9xxmrWJX3G3IkVLaGXS5vnBu7YT8
	Y3+vsUxiE879zKrEUpyRaKjFXFScCACsnyhhEgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQd2racxBBgd26lvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZvRNm8leMJmt4tEB0wbG
	XtYuRk4OCQETidsfVzJC2GISF+6tZ+ti5OIQEpjOKHHu3AImCOcvo0Tb6btsIFVsAloSq+ce
	ZwRJiAj8ZpS49WwOK4jDLPCfSWLr7Sb2LkYODmEBV4nfNyJBGlgEVCUOHH4M1swrYCnxZW4D
	M4QtKPFj8j0WEJsZaOj6nceZIGx5ic1r3jJDnKQgsePsa7DzRAT0JDad2McOUSMise/FO8YJ
	jAKzkIyahWTULCSjZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOLE8k9rBuLLB
	4hCjAAejEg9vRwBTkBBrYllxZe4hRgkOZiUR3ovFQCHelMTKqtSi/Pii0pzU4kOMyUCfTmSW
	Ek3OBya9vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgnBYq
	o90bolFcVLVNnO9Q3JPiS72H5//f8cxn+aTvn5ZLNolFLFy1OdNZNq8wZaVtXYL8W25Tn+4/
	GRVzenmL+rw+H1hceoNdu1da4K3N2d3f4k8k7mqe8M4lVXu2ttnC7f3v+v/ueuX2WvfOulQP
	+Tffqu9vSJxiPm/7x52fHk117jwtGf+vR4mlOCPRUIu5qDgRAMlqb4ZwAwAA
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


