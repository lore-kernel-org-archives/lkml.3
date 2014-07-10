Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaGJN0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:26:15 -0400
Received: from 8bytes.org ([85.214.48.195]:52011 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbaGJN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:00 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 1/9] iommu/amd: Fix typo in amd_iommu_v2 driver
Date: Thu, 10 Jul 2014 15:25:42 +0200
Message-Id: <1404998750-15536-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404998750-15536-1-git-send-email-joro@8bytes.org>
References: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:25:58 2014
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946620862102911951
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Fix typo in a comment.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu_v2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 92fb77c..0e29f6f 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -49,7 +49,7 @@ struct pasid_state {
 						   calls */
 	struct task_struct *task;		/* Task bound to this PASID */
 	struct mm_struct *mm;			/* mm_struct for the faults */
-	struct mmu_notifier mn;                 /* mmu_otifier handle */
+	struct mmu_notifier mn;                 /* mmu_notifier handle */
 	struct pri_queue pri[PRI_QUEUE_SIZE];	/* PRI tag states */
 	struct device_state *device_state;	/* Link to our device_state */
 	int pasid;				/* PASID index */
-- 
1.7.9.5


