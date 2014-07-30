Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaG3OF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 10:05:57 -0400
Received: from 8bytes.org ([81.169.241.247]:59115 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbaG3OEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 10:04:52 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4/4] iommu/amd: Fix 2 typos in comments
Date: Wed, 30 Jul 2014 16:04:40 +0200
Message-Id: <1406729080-2486-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406729080-2486-1-git-send-email-joro@8bytes.org>
References: <1406729080-2486-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

amd_iommu_pasid_bind -> amd_iommu_bind_pasid

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 2de13be..5f578e8 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -367,7 +367,7 @@ static void free_pasid_states(struct device_state *dev_state)
 		mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
 
 		put_pasid_state_wait(pasid_state); /* Reference taken in
-						      amd_iommu_pasid_bind */
+						      amd_iommu_bind_pasid */
 
 		/* Drop reference taken in amd_iommu_bind_pasid */
 		put_device_state(dev_state);
@@ -749,7 +749,7 @@ void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
 	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
 
 	put_pasid_state_wait(pasid_state); /* Reference taken in
-					      amd_iommu_pasid_bind */
+					      amd_iommu_bind_pasid */
 out:
 	/* Drop reference taken in this function */
 	put_device_state(dev_state);
-- 
1.9.1

