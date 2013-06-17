Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3FQUjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:39:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54379 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3FQUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:39:51 -0400
From: David Brown <davidb@codeaurora.org>
To: Olof Johansson <olof@lixom.net>
Cc: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] ARM: dts: msm: Fix merge resolution
Date: Mon, 17 Jun 2013 13:39:38 -0700
Message-Id: <1371501578-24484-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e45600107b (Merge tag 'msm-cleanup-for-3.11' of
git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm into
next/cleanup) incorrectly resolved a merge conflict, resulting in a
node address that doesn't match the register address.

Fix this node address.

Signed-off-by: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/dts/msm8960-cdp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index e9eb835..db2060c 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -37,7 +37,7 @@
 		reg = <0xfd510000 0x4000>;
 	};
 
-	serial@19440000 {
+	serial@16440000 {
 		compatible = "qcom,msm-hsuart", "qcom,msm-uart";
 		reg = <0x16440000 0x1000>,
 		      <0x16400000 0x1000>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

