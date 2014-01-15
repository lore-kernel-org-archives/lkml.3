Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaAOStE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:49:04 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:49435 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaAOSrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:47:46 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: [PATCH v5 13/14] devicetree: bindings: Document qcom,gcc
Date: Wed, 15 Jan 2014 10:47:33 -0800
Message-Id: <1389811654-21397-14-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
References: <1389811654-21397-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the global clock controller found on Qualcomm devices.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/clock/qcom,gcc.txt          | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc.txt

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
new file mode 100644
index 000000000000..767401f42871
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
@@ -0,0 +1,21 @@
+Qualcomm Global Clock & Reset Controller Binding
+------------------------------------------------
+
+Required properties :
+- compatible : shall contain only one of the following:
+
+			"qcom,gcc-msm8660"
+			"qcom,gcc-msm8960"
+			"qcom,gcc-msm8974"
+
+- reg : shall contain base register location and length
+- #clock-cells : shall contain 1
+- #reset-cells : shall contain 1
+
+Example:
+	clock-controller@900000 {
+		compatible = "qcom,gcc-msm8960";
+		reg = <0x900000 0x4000>;
+		#clock-cells = <1>;
+		#reset-cells = <1>;
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

