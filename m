Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaDPVpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:45:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38053 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbaDPVpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:45:46 -0400
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 0/2] dmaengine: qcom_bam_dma: Add support for v1.3.0
Date: Wed, 16 Apr 2014 16:45:17 -0500
Message-Id: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches adds support for the v1.3.0 version of the QCOM BAM
dmaengine driver.  The older version of the BAM is present in the MSM8x64,
APQ8064, and IPQ8064 processors.

Due to register address space changes between versions, all of the register
accesses have to be calculated using different offsets and multipliers that are
specific to that version of the IP block.

Andy Gross (2):
  dmaengine: qcom_bam_dma: Add v1.3.0 driver support
  dmaengine: qcom_bam_dma: Add binding for v1.3.0

 .../devicetree/bindings/dma/qcom_bam_dma.txt       |    4 +-
 drivers/dma/qcom_bam_dma.c                         |  177 +++++++++++++-------
 2 files changed, 117 insertions(+), 64 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

