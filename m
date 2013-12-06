Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162573Ab3LFXsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:48:23 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:64325 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161367Ab3LFXsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:48:20 -0500
X-IronPort-AV: E=Sophos;i="4.93,843,1378882800"; 
   d="scan'208";a="603047"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH 1/2] ARM: dts: bcm281xx: Add i2c busses
Date: Fri, 6 Dec 2013 15:45:27 -0800
Message-ID: <1386373528-13045-2-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1386373528-13045-1-git-send-email-tim.kryger@linaro.org>
References: <1386373528-13045-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the DTS nodes for all the i2c busses in the SoC.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Christian Daudt <csd@broadcom.com>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
---
 arch/arm/boot/dts/bcm11351.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
index 1246885..4bfd7e3 100644
--- a/arch/arm/boot/dts/bcm11351.dtsi
+++ b/arch/arm/boot/dts/bcm11351.dtsi
@@ -146,6 +146,46 @@
 		status = "disabled";
 	};
 
+	i2c@3e016000 {
+		compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
+		reg = <0x3e016000 0x80>;
+		interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&bsc1_clk>;
+		status = "disabled";
+	};
+
+	i2c@3e017000 {
+		compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
+		reg = <0x3e017000 0x80>;
+		interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&bsc2_clk>;
+		status = "disabled";
+	};
+
+	i2c@3e018000 {
+		compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
+		reg = <0x3e018000 0x80>;
+		interrupts = <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&bsc3_clk>;
+		status = "disabled";
+	};
+
+	i2c@3500d000 {
+		compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
+		reg = <0x3500d000 0x80>;
+		interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&pmu_bsc_clk>;
+		status = "disabled";
+	};
+
 	clocks {
 		bsc1_clk: bsc1 {
 			compatible = "fixed-clock";
-- 
1.8.0.1

