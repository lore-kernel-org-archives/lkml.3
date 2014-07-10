Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaGJN0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:26:19 -0400
Received: from 8bytes.org ([85.214.48.195]:52010 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbaGJN0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:26:00 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Oded.Gabbay@amd.com
Subject: [PATCH 0/9] AMD IOMMUv2 driver updates and fixes
Date: Thu, 10 Jul 2014 15:25:41 +0200
Message-Id: <1404998750-15536-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jul 10 15:25:58 2014
X-DSPAM-Confidence: 0.9979
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53be946620862134521002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a queue of patches for the AMD IOMMUv2 driver that came up
during development of the radeon_kfd driver. The enhance the semantics
and fix a number of bugs found in the code.


	Joerg

Diffstat:

 drivers/iommu/amd_iommu_v2.c |  104 ++++++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 33 deletions(-)

Shortlog:

Joerg Roedel (9):
      iommu/amd: Fix typo in amd_iommu_v2 driver
      iommu/amd: Don't call mmu_notifer_unregister in __unbind_pasid
      iommu/amd: Don't free pasid_state in mn_release path
      iommu/amd: Get rid of __unbind_pasid
      iommu/amd: Drop pasid_state reference in ppr_notifer error path
      iommu/amd: Add pasid_state->invalid flag
      iommu/amd: Don't hold a reference to mm_struct
      iommu/amd: Don't hold a reference to task_struct
      iommu/amd: Don't call the inv_ctx_cb when pasid is not set up


