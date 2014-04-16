Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaDPVpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:45:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38073 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789AbaDPVpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:45:49 -0400
From: Andy Gross <agross@codeaurora.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: devicetree@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, dmaengine@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 2/2] dmaengine: qcom_bam_dma: Add binding for v1.3.0
Date: Wed, 16 Apr 2014 16:45:19 -0500
Message-Id: <1397684719-30065-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
References: <1397684719-30065-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree binding support for the v1.3.0 version of the QCOM BAM DMA
driver.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/dma/qcom_bam_dma.txt       |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
index d75a9d7..802572f 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -1,7 +1,9 @@
 QCOM BAM DMA controller
 
 Required properties:
-- compatible: must contain "qcom,bam-v1.4.0" for MSM8974
+- compatible: must contain one of the following:
+			"qcom,bam-v1.4.0" for MSM8974
+			"qcom,bam-v1.3.0" for APQ8064, IPQ8064, MSM8x64
 - reg: Address range for DMA registers
 - interrupts: Should contain the one interrupt shared by all channels
 - #dma-cells: must be <1>, the cell in the dmas property of the client device
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

