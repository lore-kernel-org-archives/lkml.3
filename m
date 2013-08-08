Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971Ab3HHJly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 05:41:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50928 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964831Ab3HHJlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 05:41:50 -0400
X-AuditID: cbfee691-b7fef6d000002d62-db-520367dd4ef0
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
Subject: [PATCH v9 16/16] iommu/exynos: return 0 if iommu_attach_device()
 successes
Date: Thu, 08 Aug 2013 18:41:49 +0900
Message-id: <003401ce941b$8113a820$833af860$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6UF8kdvkQgXH7hS9Wbiyk5M4q1dQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t8zQ9276cxBBl/ei1jcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4o7hsUlJzMstSi/TtErgyXt7bx14wgbfiwzudBsZXXF2MnBwSAiYSE/a2MkPYYhIX7q1n
	62Lk4hASWMYosXjJRFaYoim3J7NAJKYzSjyf9A6q6i+jxKIZH8Cq2AS0JFbPPc4IkhAR+M0o
	cevZHFYQh1ngP5PE1ttN7CBVwgKhEg92HgXrYBFQlTg75x1QnIODV8BSYvqqYJAwr4CgxI/J
	91hAbGagoet3HmeCsOUlNq95C3WrgsSOs68ZQWwRAT2JyXt3sEHUiEjse/GOEaJmIYfE309Q
	qwQkvk0+xAKySkJAVmLTAagxkhIHV9xgmcAoNgvJ5llINs9CsnkWkg0LGFlWMYqmFiQXFCel
	F5nqFSfmFpfmpesl5+duYoRE/sQdjPcPWB9iTAZaP5FZSjQ5H5g48kriDY3NjCxMTUyNjcwt
	zUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaPNqduT8pRMm23G1nZS64B1Z
	sG9tyN6fvR9br9bErFm64U5+zX6VDQlXjH9+db344cr9qa+bo8T27Q3zs09b9+KUW2J1aNE1
	k9mMMaxub3qaHwc6pYn9jdp0RtE1LO35gxdycnu71xgK3W/bPfeSg8rzpJWpF9xjH8a0X0w9
	6G5hvODumznd3UosxRmJhlrMRcWJAAWE1JwSAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsVy+t9jQd276cxBBs9n8lvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73MjnweTw5OI/JY3bDRRaPO9f2sHmc37SG2WPzknqPyTeWM3r0bVnF6PF5k5zHlaNn
	mAI4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	jldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZry8t4+9YAJvxYd3Og2M
	r7i6GDk5JARMJKbcnswCYYtJXLi3nq2LkYtDSGA6o8TzSe+gnL+MEotmfGAFqWIT0JJYPfc4
	I0hCROA3o8StZ3NYQRxmgf9MEltvN7GDVAkLhEo82HkUrINFQFXi7Jx3QHEODl4BS4npq4JB
	wrwCghI/Jt8DW80MNHT9zuNMELa8xOY1b5khTlKQ2HH2NSOILSKgJzF57w42iBoRiX0v3jFO
	YBSYhWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYnlmfQOxlUN
	FocYBTgYlXh4F7oxBwmxJpYVV+YeYpTgYFYS4b1YzBQkxJuSWFmVWpQfX1Sak1p8iDEZ6NGJ
	zFKiyfnApJdXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxb
	WOY5JNeoz0x9+jujdavkqwmhj4w3/5mvs+x0rbCZlwrbdokrn1r/XXbLOWvT6n9KOMj9pL3/
	BHf2c0ZbnIvLisV0OyYf0Duo+ypVjL/JtNqpUTe751RFQmCwk6F43r5N0bMXd0uZbd0QMMlh
	v/u7abz1E2MMtNiEWe++cH5RwPmmsrPxshJLcUaioRZzUXEiAGrpqq9wAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_attach_device() against exynos-iommu positive integer on success
if the caller calls iommu_attach_device() with the same iommu_domain
multiple times without call to iommu_detach_device() to inform the
caller how many calls to iommu_detach_device() to really detach iommu.

However the convention of the return value of success of common API is
zero, this patch makes iommu_attach_device() call against exynos-iommu
always return zero if the given device is successfully attached to
the given iommu_domain even though it is already attached to the same
iommu_domain.

Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 2d16fc0..d959e95 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -891,15 +891,16 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-	else
-		dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
-					__func__, __pa(priv->pgtable),
-					(ret == 0) ? "" : ", again");
+		return ret;
+	}
 
-	return ret;
+	dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
+		__func__, __pa(priv->pgtable), (ret == 0) ? "" : ", again");
+
+	return 0;
 }
 
 static void exynos_iommu_detach_device(struct iommu_domain *domain,
-- 
1.7.2.5


