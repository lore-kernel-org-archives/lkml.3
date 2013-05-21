Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525Ab3EUAun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 20:50:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1490 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3EUAul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 20:50:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,711,1363158000"; 
   d="scan'208";a="49012688"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: dts: msm: Fix bad register addresses
Date: Mon, 20 May 2013 17:50:37 -0700
Message-Id: <1369097437-19217-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc2.10.g0c2b1cf.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bad copy/paste got in as well as too many zeroes. Fix
everything up so that the registers after the @ sign are
consistent with the first reg property.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/msm8660-surf.dts | 4 ++--
 arch/arm/boot/dts/msm8960-cdp.dts  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index 9bf49b3..d347082 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -15,7 +15,7 @@
 		      < 0x02081000 0x1000 >;
 	};
 
-	timer@2000004 {
+	timer@2000000 {
 		compatible = "qcom,scss-timer", "qcom,msm-timer";
 		interrupts = <1 0 0x301>,
 			     <1 1 0x301>,
@@ -26,7 +26,7 @@
 		cpu-offset = <0x40000>;
 	};
 
-	serial@19c400000 {
+	serial@19c40000 {
 		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
 		reg = <0x19c40000 0x1000>,
 		      <0x19c00000 0x1000>;
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index 2e4d87a..7c9ef9b 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -26,7 +26,7 @@
 		cpu-offset = <0x80000>;
 	};
 
-	serial@19c400000 {
+	serial@16440000 {
 		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
 		reg = <0x16440000 0x1000>,
 		      <0x16400000 0x1000>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

