Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaARBF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 20:05:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40736 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaARBFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 20:05:23 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] dt-bindings: qcom: Fix warning with duplicate dt define
Date: Fri, 17 Jan 2014 17:05:19 -0800
Message-Id: <1390007119-4544-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/arm/boot/dts/include/dt-bindings/clock/qcom,mmcc-msm8974.h:60:0:
warning: "RBCPR_CLK_SRC" redefined

Rename this to MMSS_RBCPR_CLK_SRC to avoid conflicts with the
RBCPR clock in the gcc header.

Reported-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 include/dt-bindings/clock/qcom,mmcc-msm8974.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/dt-bindings/clock/qcom,mmcc-msm8974.h b/include/dt-bindings/clock/qcom,mmcc-msm8974.h
index 04d318d1187a..032ed87ef0f3 100644
--- a/include/dt-bindings/clock/qcom,mmcc-msm8974.h
+++ b/include/dt-bindings/clock/qcom,mmcc-msm8974.h
@@ -57,7 +57,7 @@
 #define EXTPCLK_CLK_SRC					40
 #define HDMI_CLK_SRC					41
 #define VSYNC_CLK_SRC					42
-#define RBCPR_CLK_SRC					43
+#define MMSS_RBCPR_CLK_SRC				43
 #define CAMSS_CCI_CCI_AHB_CLK				44
 #define CAMSS_CCI_CCI_CLK				45
 #define CAMSS_CSI0_AHB_CLK				46
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

