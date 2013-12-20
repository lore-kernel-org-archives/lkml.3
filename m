Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3LTTKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:40 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37444 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3LTTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:38 -0500
From: David Brown <davidb@codeaurora.org>
To: arm@kernel.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 6/7] ARM: dts: MSM8974: Add MMIO architected timer node
Date: Fri, 20 Dec 2013 11:09:19 -0800
Message-Id: <1387566560-23948-7-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
References: <1387566560-23948-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Add the mmio architected timer node.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 59 +++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index df18637..6ac9496 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -30,6 +30,65 @@
 			clock-frequency = <19200000>;
 		};
 
+		timer@f9020000 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
+			compatible = "arm,armv7-timer-mem";
+			reg = <0xf9020000 0x1000>;
+			clock-frequency = <19200000>;
+
+			frame@f9021000 {
+				frame-number = <0>;
+				interrupts = <0 8 0x4>,
+					     <0 7 0x4>;
+				reg = <0xf9021000 0x1000>,
+				      <0xf9022000 0x1000>;
+			};
+
+			frame@f9023000 {
+				frame-number = <1>;
+				interrupts = <0 9 0x4>;
+				reg = <0xf9023000 0x1000>;
+				status = "disabled";
+			};
+
+			frame@f9024000 {
+				frame-number = <2>;
+				interrupts = <0 10 0x4>;
+				reg = <0xf9024000 0x1000>;
+				status = "disabled";
+			};
+
+			frame@f9025000 {
+				frame-number = <3>;
+				interrupts = <0 11 0x4>;
+				reg = <0xf9025000 0x1000>;
+				status = "disabled";
+			};
+
+			frame@f9026000 {
+				frame-number = <4>;
+				interrupts = <0 12 0x4>;
+				reg = <0xf9026000 0x1000>;
+				status = "disabled";
+			};
+
+			frame@f9027000 {
+				frame-number = <5>;
+				interrupts = <0 13 0x4>;
+				reg = <0xf9027000 0x1000>;
+				status = "disabled";
+			};
+
+			frame@f9028000 {
+				frame-number = <6>;
+				interrupts = <0 14 0x4>;
+				reg = <0xf9028000 0x1000>;
+				status = "disabled";
+			};
+		};
+
 		restart@fc4ab000 {
 			compatible = "qcom,pshold";
 			reg = <0xfc4ab000 0x4>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

