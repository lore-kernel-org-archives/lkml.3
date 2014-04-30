Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945961AbaD3SPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:15:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50043 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaD3SPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:15:15 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Kumar Gala <galak@codeaurora.org>, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH] clk: qcom: Remove accidental merged reject file
Date: Wed, 30 Apr 2014 13:15:11 -0500
Message-Id: <1398881711-5566-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like commit cff558c79f572530bdbbb9b847134094008afcef accidentally
added in a merge reject file, so remove it.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/clock/qcom,gcc.txt.rej | 10 ----------
 1 file changed, 10 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt.rej

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt.rej b/Documentation/devicetree/bindings/clock/qcom,gcc.txt.rej
deleted file mode 100644
index 2e84dbe..0000000
--- a/Documentation/devicetree/bindings/clock/qcom,gcc.txt.rej
+++ /dev/null
@@ -1,10 +0,0 @@
---- Documentation/devicetree/bindings/clock/qcom,gcc.txt
-+++ Documentation/devicetree/bindings/clock/qcom,gcc.txt
-@@ -4,6 +4,7 @@
- Required properties :
- - compatible : shall contain only one of the following:
- 
-+			"qcom,gcc-apq8064"
- 			"qcom,gcc-ipq8064"
- 			"qcom,gcc-msm8660"
- 			"qcom,gcc-msm8960"
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

