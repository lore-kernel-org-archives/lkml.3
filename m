Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbbA2BMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:12:55 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35419 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbbA2BMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:12:54 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rajendra Nayak <rnayak@codeaurora.org>
Subject: [PATCH] arm: dts: qcom: Add LCC nodes
Date: Wed, 28 Jan 2015 13:36:12 -0800
Message-Id: <1422480972-4105-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.3.0.rc1.33.g42e4583
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@codeaurora.org>

Add the node for the LPASS clock controller found on a few qcom
SoCs so that the clock driver can probe.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Signed-off-by: Kumar Gala <galak@codeaurora.org>
[sboyd@codeaurora.org: Added apq8064 and msm8960 nodes]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 7 +++++++
 arch/arm/boot/dts/qcom-ipq8064.dtsi | 8 ++++++++
 arch/arm/boot/dts/qcom-msm8960.dtsi | 7 +++++++
 3 files changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index b3154c071652..7705752c212c 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -239,6 +239,13 @@
 			#reset-cells = <1>;
 		};
 
+		lcc: clock-controller@28000000 {
+			compatible = "qcom,lcc-apq8064";
+			reg = <0x28000000 0x1000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
+
 		mmcc: clock-controller@4000000 {
 			compatible = "qcom,mmcc-apq8064";
 			reg = <0x4000000 0x1000>;
diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index cb225dafe97c..568260c387bb 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -279,5 +279,13 @@
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 		};
+
+		lcc: clock-controller@28000000 {
+			compatible = "qcom,lcc-ipq8064";
+			reg = <0x28000000 0x1000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
+
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-msm8960.dtsi b/arch/arm/boot/dts/qcom-msm8960.dtsi
index e1b0d5cd9e3c..41ac308d4d68 100644
--- a/arch/arm/boot/dts/qcom-msm8960.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8960.dtsi
@@ -91,6 +91,13 @@
 			reg = <0x900000 0x4000>;
 		};
 
+		lcc: clock-controller@28000000 {
+			compatible = "qcom,lcc-msm8960";
+			reg = <0x28000000 0x1000>;
+			#clock-cells = <1>;
+			#reset-cells = <1>;
+		};
+
 		clock-controller@4000000 {
 			compatible = "qcom,mmcc-msm8960";
 			reg = <0x4000000 0x1000>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

