Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3IQPvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:51:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55298 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3IQPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:51:46 -0400
From: Kumar Gala <galak@codeaurora.org>
To: davidb@codeaurora.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: msm: Rename msm devicetrees to have standard 'qcom' prefix
Date: Tue, 17 Sep 2013 10:51:43 -0500
Message-Id: <1379433103-23995-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a standard 'qcom' prefix to denotate device trees meant for Qualcomm
based processors.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/boot/dts/Makefile                                    | 4 ++--
 arch/arm/boot/dts/{msm8660-surf.dts => qcom-msm8660-surf.dts} | 0
 arch/arm/boot/dts/{msm8960-cdp.dts => qcom-msm8960-cdp.dts}   | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/arm/boot/dts/{msm8660-surf.dts => qcom-msm8660-surf.dts} (100%)
 rename arch/arm/boot/dts/{msm8960-cdp.dts => qcom-msm8960-cdp.dts} (100%)

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index cc0f1fb..b437846 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -101,8 +101,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
 	kirkwood-ts219-6282.dtb \
 	kirkwood-openblocks_a6.dtb
 dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
-dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
-	msm8960-cdp.dtb
+dtb-$(CONFIG_ARCH_MSM) += qcom-msm8660-surf.dtb \
+	qcom-msm8960-cdp.dtb
 dtb-$(CONFIG_ARCH_MVEBU) += armada-370-db.dtb \
 	armada-370-mirabox.dtb \
 	armada-370-netgear-rn102.dtb \
diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/qcom-msm8660-surf.dts
similarity index 100%
rename from arch/arm/boot/dts/msm8660-surf.dts
rename to arch/arm/boot/dts/qcom-msm8660-surf.dts
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/qcom-msm8960-cdp.dts
similarity index 100%
rename from arch/arm/boot/dts/msm8960-cdp.dts
rename to arch/arm/boot/dts/qcom-msm8960-cdp.dts
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

