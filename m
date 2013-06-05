Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3FERpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:45:51 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33188 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab3FERpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:45:50 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: add vmmc regulator support for ODROID-X
Date: Thu,  6 Jun 2013 02:45:24 +0900
Message-Id: <1370454336-13003-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to add vmmc regulator node at MSHC and SDHCI for ODROID-X
board file.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/exynos4412-odroidx.dts |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
index 1786225..3f3d7c8 100644
--- a/arch/arm/boot/dts/exynos4412-odroidx.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -44,6 +44,7 @@
 		pinctrl-0 = <&sd4_clk &sd4_cmd &sd4_bus4 &sd4_bus8>;
 		pinctrl-names = "default";
 		status = "okay";
+		vmmc-supply = <&ldo20_reg &buck8_reg>;
 
 		num-slots = <1>;
 		supports-highspeed;
@@ -78,6 +79,7 @@
 		bus-width = <4>;
 		pinctrl-0 = <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
 		pinctrl-names = "default";
+		vmmc-supply = <&ldo4_reg &ldo21_reg>;
 		status = "okay";
 	};
 
-- 
1.7.9.5

