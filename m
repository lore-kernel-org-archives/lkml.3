Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3DPJa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:30:27 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44270 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839Ab3DPJaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:30:23 -0400
From: Girish K S <girishks2000@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com
Subject: [PATCH V2 2/2] ARM: dts: add dts node for the ahci sata exynos5440
Date: Tue, 16 Apr 2013 15:00:11 +0530
Message-Id: <1366104611-14315-1-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dts support for the sata controller

Signed-off-by: Girish K S <ks.giri@samsung.com>
---
 arch/arm/boot/dts/exynos5440.dtsi |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 7c5dc38..2dc4ffa 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -220,4 +220,13 @@
 		clock-names = "rtc";
 		status = "disabled";
 	};
+
+	sata@210000 {
+		compatible = "snps,exynos5440-ahci";
+		reg = <0x210000 0x10000>;
+		interrupts = <0 30 0>;
+		clocks = <&clock 10>;
+		clock-names = "sata";
+	};
+
 };
-- 
1.7.5.4

