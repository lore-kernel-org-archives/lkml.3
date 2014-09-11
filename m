Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaIKCTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 22:19:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52475 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaIKCTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 22:19:07 -0400
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        dmaengine@vger.kernel.org, Andy Gross <agross@codeaurora.org>
Subject: [RESEND PATCH 0/2] Add Qualcomm ADM dmaengine driver
Date: Wed, 10 Sep 2014 21:18:51 -0500
Message-Id: <1410401933-20621-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am resending this patch set at the request of the maintainer.  The original
text is shown below.

This patch set introduces the dmaengine driver for the Qualcomm Application
Data Mover (ADM) DMA controller present on MSM8960, APQ8064, and IPQ8064
devices.

The initial version of this driver will only support slave DMA operations
between system memory and peripherals.  Flow control via the CRCI (client rate
control interface) is supported and can be configured via device tree
configuration.  Flow control usage is required for some peripheral devices.


Andy Gross (2):
  dmaengine: Add QCOM ADM DMA driver
  dmaengine: qcom_adm: Add device tree binding

 Documentation/devicetree/bindings/dma/qcom_adm.txt |   62 ++
 drivers/dma/Kconfig                                |   10 +
 drivers/dma/Makefile                               |    1 +
 drivers/dma/qcom_adm.c                             |  872 ++++++++++++++++++++
 4 files changed, 945 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/dma/qcom_adm.txt
 create mode 100644 drivers/dma/qcom_adm.c

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

