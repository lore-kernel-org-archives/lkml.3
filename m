Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3LOHCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 02:02:44 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:5919 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab3LOHCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 02:02:02 -0500
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 4/4] pinctrl-msm: Rename compatible to be more specific
Date: Sat, 14 Dec 2013 23:01:54 -0800
Message-ID: <1387090914-4755-5-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1387090914-4755-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more specific form 8974 for the compatible to reduce the
risk of future mishaps.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 ...sm8x74-pinctrl.txt => qcom,msm8974-pinctrl.txt} |    4 ++--
 drivers/pinctrl/pinctrl-msm8x74.c                  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)
 rename Documentation/devicetree/bindings/pinctrl/{qcom,msm8x74-pinctrl.txt => qcom,msm8974-pinctrl.txt} (97%)

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
similarity index 97%
rename from Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
rename to Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
index 70ab78f..4c352be 100644
--- a/Documentation/devicetree/bindings/pinctrl/qcom,msm8x74-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,msm8974-pinctrl.txt
@@ -1,4 +1,4 @@
-Qualcomm MSM8x74 TLMM block
+Qualcomm MSM8974 TLMM block
 
 Required properties:
 - compatible: "qcom,msm8x74-pinctrl"
@@ -59,7 +59,7 @@ Valid values for qcom,function are:
 Example:
 
 	msmgpio: pinctrl@fd510000 {
-		compatible = "qcom,msm8x74-pinctrl";
+		compatible = "qcom,msm8974-pinctrl";
 		reg = <0xfd510000 0x4000>;
 
 		gpio-controller;
diff --git a/drivers/pinctrl/pinctrl-msm8x74.c b/drivers/pinctrl/pinctrl-msm8x74.c
index c702e77..f944bf2 100644
--- a/drivers/pinctrl/pinctrl-msm8x74.c
+++ b/drivers/pinctrl/pinctrl-msm8x74.c
@@ -603,7 +603,7 @@ static int msm8x74_pinctrl_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id msm8x74_pinctrl_of_match[] = {
-	{ .compatible = "qcom,msm8x74-pinctrl", },
+	{ .compatible = "qcom,msm8974-pinctrl", },
 	{ },
 };
 
-- 
1.7.9.5

