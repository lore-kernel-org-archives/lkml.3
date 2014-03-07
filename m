Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCGNBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:01:50 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:59411 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752739AbaCGNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:01:48 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 1/5] r8a7790.dtsi: add vin[0-3] nodes
Date: Fri,  7 Mar 2014 13:01:35 +0000
Message-Id: <1394197299-17528-2-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add nodes for the four video input channels on the R8A7790.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/arm/boot/dts/r8a7790.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790.dtsi b/arch/arm/boot/dts/r8a7790.dtsi
index a1e7c39..4c3eafb 100644
--- a/arch/arm/boot/dts/r8a7790.dtsi
+++ b/arch/arm/boot/dts/r8a7790.dtsi
@@ -395,6 +395,38 @@
 		status = "disabled";
 	};
 
+	vin0: vin@0xe6ef0000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
+		reg = <0 0xe6ef0000 0 0x1000>;
+		interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
+	vin1: vin@0xe6ef1000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN1>;
+		reg = <0 0xe6ef1000 0 0x1000>;
+		interrupts = <0 189 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
+	vin2: vin@0xe6ef2000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN2>;
+		reg = <0 0xe6ef2000 0 0x1000>;
+		interrupts = <0 190 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
+	vin3: vin@0xe6ef3000 {
+		compatible = "renesas,vin-r8a7790";
+		clocks = <&mstp8_clks R8A7790_CLK_VIN3>;
+		reg = <0 0xe6ef3000 0 0x1000>;
+		interrupts = <0 191 IRQ_TYPE_LEVEL_HIGH>;
+		status = "disabled";
+	};
+
 	clocks {
 		#address-cells = <2>;
 		#size-cells = <2>;
-- 
1.9.0

