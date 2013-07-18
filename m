Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965313Ab3GRUI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:08:28 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49708 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066Ab3GRUHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:07:36 -0400
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 1/3] ARM: msm: dts: Fix the gpio register address for msm8960
Date: Thu, 18 Jul 2013 13:07:13 -0700
Message-Id: <1374178035-19943-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
References: <1374178035-19943-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rohit Vaswani <rvaswani@codeaurora.org>

Fix the the gpio reg address for the device tree entry.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/msm8960-cdp.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index db2060c..9c1167b0 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -26,7 +26,7 @@
 		cpu-offset = <0x80000>;
 	};
 
-	msmgpio: gpio@fd510000 {
+	msmgpio: gpio@800000 {
 		compatible = "qcom,msm-gpio";
 		gpio-controller;
 		#gpio-cells = <2>;
@@ -34,7 +34,7 @@
 		interrupts = <0 32 0x4>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		reg = <0xfd510000 0x4000>;
+		reg = <0x800000 0x4000>;
 	};
 
 	serial@16440000 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

