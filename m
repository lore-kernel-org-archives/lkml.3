Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646Ab3FSKNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:13:32 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63974 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934265Ab3FSKN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:13:28 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH] ARM: dts: Update range for vdd_arm on EXYNOS4412-origen board
Date: Wed, 19 Jun 2013 15:28:39 +0530
Message-Id: <1371635919-16288-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXYNOS4412 cpufreq driver requires the range of vdd_arm regulator to
be from .9v to 1.35v. Since vdd_arm regulator (BUCK2 on S5M8767) has
a supported range of .6v to 1.6v, the constraints are updated to
match the requirement from cpufreq driver.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 arch/arm/boot/dts/exynos4412-origen.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index 7993641..309a583 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -450,8 +450,8 @@
 
 				buck2_reg: BUCK2 {
 					regulator-name = "vdd_arm";
-					regulator-min-microvolt = <925000>;
-					regulator-max-microvolt	= <1300000>;
+					regulator-min-microvolt = <900000>;
+					regulator-max-microvolt	= <1350000>;
 					regulator-always-on;
 					regulator-boot-on;
 					op_mode = <1>; /* Normal Mode */
-- 
1.7.9.5

