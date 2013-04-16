Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3DPI7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:59:33 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51834 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab3DPI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:59:10 -0400
From: Girish K S <girishks2000@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com
Subject: [PATCH 2/2] ARM: dts: add dts node for the ahci sata exynos5440
Date: Tue, 16 Apr 2013 14:28:53 +0530
Message-Id: <1366102733-3570-2-git-send-email-ks.giri@samsung.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1366102733-3570-1-git-send-email-ks.giri@samsung.com>
References: <1366102733-3570-1-git-send-email-ks.giri@samsung.com>
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
+		compatible = "samsung,exynos5440-ahci";
+		reg = <0x210000 0x10000>;
+		interrupts = <0 30 0>;
+		clocks = <&clock 10>;
+		clock-names = "sata";
+	};
+
 };
-- 
1.7.5.4

