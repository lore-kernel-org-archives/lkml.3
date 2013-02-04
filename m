Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3BDNTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:19:07 -0500
Received: from 8bytes.org ([85.214.48.195]:33807 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215Ab3BDNTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:19:03 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>, Stuart Yoder <b08248@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/5] iommu: Make sure DOMAIN_ATTR_MAX is really the maximum
Date: Mon,  4 Feb 2013 14:18:39 +0100
Message-Id: <1359983924-28952-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359983924-28952-1-git-send-email-joro@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb  4 14:19:02 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510fb54622971745917414
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it to the end of the list.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 include/linux/iommu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f3b99e1..7e6ce72 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -58,8 +58,8 @@ struct iommu_domain {
 #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
 enum iommu_attr {
-	DOMAIN_ATTR_MAX,
 	DOMAIN_ATTR_GEOMETRY,
+	DOMAIN_ATTR_MAX,
 };
 
 #ifdef CONFIG_IOMMU_API
-- 
1.7.9.5


