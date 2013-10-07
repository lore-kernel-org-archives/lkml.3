Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3JGTP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:15:26 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1534 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3JGTPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:15:19 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Wolfram Sang" <wsa@the-dreams.de>,
        "Grant Likely" <grant.likely@linaro.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] ARM: dts: bcm281xx: Add i2c busses
Date: Mon, 7 Oct 2013 12:15:00 -0700
Message-ID: <1381173301-23830-4-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1381173301-23830-1-git-send-email-tim.kryger@linaro.org>
References: <1381173301-23830-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
X-WSS-ID: 7E4DD7B02L892392553-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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


