Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725Ab3CZJNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:13:40 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51013 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759544Ab3CZJNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:13:35 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] ARM: sunxi: dt: Update interrupt controller compatible string
Date: Tue, 26 Mar 2013 10:13:15 +0100
Message-Id: <1364289198-11589-9-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1364289198-11589-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/sun4i-a10.dtsi |    2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index be71782..805d704 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -121,7 +121,7 @@
 		ranges;
 
 		intc: interrupt-controller@01c20400 {
-			compatible = "allwinner,sunxi-ic";
+			compatible = "allwinner,sun4i-ic";
 			reg = <0x01c20400 0x400>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
index 7a81aaf..760222c 100644
--- a/arch/arm/boot/dts/sun5i-a13.dtsi
+++ b/arch/arm/boot/dts/sun5i-a13.dtsi
@@ -122,7 +122,7 @@
 		ranges;
 
 		intc: interrupt-controller@01c20400 {
-			compatible = "allwinner,sunxi-ic";
+			compatible = "allwinner,sun4i-ic";
 			reg = <0x01c20400 0x400>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
-- 
1.7.10.4

