Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbaI2Edx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:33:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50275 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaI2Eds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:33:48 -0400
From: Archit Taneja <architt@codeaurora.org>
To: vinod.koul@intel.com, agross@codeaurora.org
Cc: galak@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        devicetree@vger.kernel.org, Archit Taneja <architt@codeaurora.org>
Subject: [PATCH v2 3/3] dt/bindings: dmaengine: qcom_bam_dma: Add compatible string for BAM v1.3.0
Date: Mon, 29 Sep 2014 10:03:09 +0530
Message-Id: <1411965189-24499-3-git-send-email-architt@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1411965189-24499-1-git-send-email-architt@codeaurora.org>
References: <1411037575-13153-1-git-send-email-architt@codeaurora.org>
 <1411965189-24499-1-git-send-email-architt@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatible string for BAM v1.3.0 in the DT bindings documentation. Mentioned
a few more SoCs which have BAM v1.4.0 in them.

Reviewed-by: Kumar Gala <galak@codeaurora.org>
Reviewed-by: Andy Gross <agross@codeaurora.org>
Signed-off-by: Archit Taneja <architt@codeaurora.org>
---
Update in v2: Added IPQ8064 to the v1.3.0 list

 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
index d75a9d7..f8c3311 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -1,7 +1,9 @@
 QCOM BAM DMA controller
 
 Required properties:
-- compatible: must contain "qcom,bam-v1.4.0" for MSM8974
+- compatible: must be one of the following:
+ * "qcom,bam-v1.4.0" for MSM8974, APQ8074 and APQ8084
+ * "qcom,bam-v1.3.0" for APQ8064, IPQ8064 and MSM8960
 - reg: Address range for DMA registers
 - interrupts: Should contain the one interrupt shared by all channels
 - #dma-cells: must be <1>, the cell in the dmas property of the client device
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

