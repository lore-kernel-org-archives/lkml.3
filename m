Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3HESJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:09:42 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33550 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3HESJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:09:40 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] ARM: dts: Add USB host node for Exynos4
Date: Tue,  6 Aug 2013 03:09:19 +0900
Message-Id: <1375726159-20486-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds EHCI and OHCI host device nodes for Exynos4.

CC: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Dongjin Kim <tobetter@gmail.com>
---
 arch/arm/boot/dts/exynos4.dtsi |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 3f94fe8..cbe5219 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -155,6 +155,24 @@
 		status = "disabled";
 	};
 
+	ehci@12580000 {
+		compatible = "samsung,exynos4210-ehci";
+		reg = <0x12580000 0x100>;
+		interrupts = <0 70 0>;
+		clocks = <&clock 304>;
+		clock-names = "usbhost";
+		status = "disabled";
+	};
+
+	ohci@12590000 {
+		compatible = "samsung,exynos4210-ohci";
+		reg = <0x12590000 0x100>;
+		interrupts = <0 70 0>;
+		clocks = <&clock 304>;
+		clock-names = "usbhost";
+		status = "disabled";
+	};
+
 	mfc: codec@13400000 {
 		compatible = "samsung,mfc-v5";
 		reg = <0x13400000 0x10000>;
-- 
1.7.9.5

