Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3ILQh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:37:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54471 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab3ILQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:37:24 -0400
From: Kumar Gala <galak@codeaurora.org>
To: davidb@codeaurora.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: msm: Move msm devicetrees under a Qualcomm dir
Date: Thu, 12 Sep 2013 11:37:19 -0500
Message-Id: <1379003839-16068-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the Qualcomm vendor prefix (qcom) as the directory name for
Qualcomm MSM devicetrees going forward.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/boot/dts/Makefile                    | 4 ++--
 arch/arm/boot/dts/{ => qcom}/msm8660-surf.dts | 2 +-
 arch/arm/boot/dts/{ => qcom}/msm8960-cdp.dts  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
 rename arch/arm/boot/dts/{ => qcom}/msm8660-surf.dts (97%)
 rename arch/arm/boot/dts/{ => qcom}/msm8960-cdp.dts (97%)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index cc0f1fb..d784ba0 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -101,8 +101,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-ts219-6282.dtb \
 	kirkwood-openblocks_a6.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
-dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
-	msm8960-cdp.dtb
+dtb-$(CONFIG_ARCH_MSM) += qcom/msm8660-surf.dtb \
+	qcom/msm8960-cdp.dtb
 dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 	armada-370-mirabox.dtb \
 	armada-370-netgear-rn102.dtb \
diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/qcom/msm8660-surf.dts
similarity index 97%
rename from arch/arm/boot/dts/msm8660-surf.dts
rename to arch/arm/boot/dts/qcom/msm8660-surf.dts
index 386d428..8c5ea9a 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/qcom/msm8660-surf.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "skeleton.dtsi"
+/include/ "../skeleton.dtsi"
 
 / {
 	model = "Qualcomm MSM8660 SURF";
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/qcom/msm8960-cdp.dts
similarity index 97%
rename from arch/arm/boot/dts/msm8960-cdp.dts
rename to arch/arm/boot/dts/qcom/msm8960-cdp.dts
index 93e9f7e..fe2659a 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/qcom/msm8960-cdp.dts
@@ -1,6 +1,6 @@
 /dts-v1/;
 
-/include/ "skeleton.dtsi"
+/include/ "../skeleton.dtsi"
 
 / {
 	model = "Qualcomm MSM8960 CDP";
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

