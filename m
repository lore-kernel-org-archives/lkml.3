Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3JYUYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:24:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38138 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3JYUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:24:52 -0400
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 0/2] add MSM BAM dmaengine driver
Date: Fri, 25 Oct 2013 15:24:01 -0500
Message-Id: <1382732643-8184-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces the dmaengine driver for the MSM 8x74 Bus Access
Manager (BAM) DMA controller.  A number of the on-chip devices have their own
BAM DMA controller and use it to move data between system memory and peripherals
or between two peripherals.

The initial version of this driver will only support slave DMA operations
between system memory and peripherals.


Andy Gross (2):
  dmaengine: add msm bam dma driver
  dmaengine: msm_bam_dma: Add device tree binding

 .../devicetree/bindings/dma/msm_bam_dma.txt        |   49 ++
 drivers/dma/Kconfig                                |    9 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/msm_bam_dma.c                          |  840 ++++++++++++++++++++
 drivers/dma/msm_bam_dma_priv.h                     |  286 +++++++
 include/linux/msm_bam_dma.h                        |   27 +
 6 files changed, 1212 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/msm_bam_dma.txt
 create mode 100644 drivers/dma/msm_bam_dma.c
 create mode 100644 drivers/dma/msm_bam_dma_priv.h
 create mode 100644 include/linux/msm_bam_dma.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

