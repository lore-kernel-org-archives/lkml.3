Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaBZTNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:13:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:53869 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaBZTGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:06:06 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, <devicetree@vger.kernel.org>
Subject: [PATCH v3 9/9] devicetree: bindings: Document PM8921/8058 vibrators
Date: Wed, 26 Feb 2014 11:06:02 -0800
Message-Id: <1393441562-685-10-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
References: <1393441562-685-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the vibration device found on PM8921 and PM8058 PMICs.

Cc: <devicetree@vger.kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 .../devicetree/bindings/input/qcom,pm8xxx-vib.txt        | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/qcom,pm8xxx-vib.txt

diff --git a/Documentation/devicetree/bindings/input/qcom,pm8xxx-vib.txt b/Documentation/devicetree/bindings/input/qcom,pm8xxx-vib.txt
new file mode 100644
index 000000000000..dca1b8872cf1
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/qcom,pm8xxx-vib.txt
@@ -0,0 +1,16 @@
+Qualcomm PM8xxx PMIC Vibrator
+
+PROPERTIES
+
+- compatible:
+	Usage: required
+	Value type: <string>
+	Definition: must be one of:
+		    "qcom,pm8058-vib"
+		    "qcom,pm8921-vib"
+
+EXAMPLE
+
+	vibrator {
+		compatible = "qcom,pm8058-vib";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

