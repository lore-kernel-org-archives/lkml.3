Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbaCCLP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:15:26 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56401 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaCCLPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:15:23 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: grant.likely@linaro.org, t.figa@samsung.com, jg1.han@samsung.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, joshi@samsung.com,
        ks.giri@samsung.com, thomas.ab@samsung.com,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [PATCH] ARM: dts: exynos5250: turn on the LDO10 on SMDK5250
Date: Mon,  3 Mar 2014 16:45:10 +0530
Message-Id: <1393845310-1898-1-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 275dcd2 "ARM: dts: add max77686 pmic node for smdk5250" added
required LDO's for SMDK5250 boards.Currently LDO10 is turned off.As LDO10,
enable/disable the LDO22 which is required for VDDQ_MMC2_AP.So this patch 
makes LDO10 turn's on always.

Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index f76946e..27a33d7 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -103,6 +103,7 @@
 					regulator-name = "P1.8V_LDO_OUT10";
 					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
 				};
 
 				ldo11_reg: LDO11 {
-- 
1.7.10.4

