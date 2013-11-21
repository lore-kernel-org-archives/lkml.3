Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3KUGl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 01:41:28 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:52180 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3KUGl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 01:41:27 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iommu: Add empty stub for iommu_group_get_by_id()
Date: Thu, 21 Nov 2013 17:41:14 +1100
Message-Id: <1385016074-17026-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.4.rc4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112106-1396-0000-0000-000003E7718B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost every function in include/linux/iommu.h has an empty stub
but the iommu_group_get_by_id() did not get one by mistake.

This adds an empty stub for iommu_group_get_by_id() for IOMMU_API
disabled config.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 include/linux/iommu.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 7ea319e..3c7903d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -245,6 +245,11 @@ static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 	return NULL;
 }
 
+static inline struct iommu_group *iommu_group_get_by_id(int id)
+{
+	return NULL;
+}
+
 static inline void iommu_domain_free(struct iommu_domain *domain)
 {
 }
-- 
1.8.4.rc4

