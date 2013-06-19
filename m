Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab3FSBDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:03:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38249 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab3FSBCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:02:34 -0400
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] ARM: msm: dts: Fix the gpio register address for msm8960
Date: Tue, 18 Jun 2013 18:02:24 -0700
Message-Id: <1371603747-27436-2-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
References: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the the gpio reg address for the device tree entry.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/boot/dts/msm8960-cdp.dts |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index 52fe253..1599764 100644
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
 
 	serial@19c400000 {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

