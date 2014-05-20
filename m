Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaETNYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:24:13 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35190 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbaETNYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:24:02 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, olof@lixom.net
Cc: linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v3 01/11] ARM: STi: DT: STiH41x: Rename CLK_SYSIN into clk_sysin
Date: Tue, 20 May 2014 15:22:45 +0200
Message-Id: <1400592175-13176-2-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1400592175-13176-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-20_02:2014-05-20,2014-05-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

all-caps node name is not very usual.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
---
 arch/arm/boot/dts/stih415-clock.dtsi | 2 +-
 arch/arm/boot/dts/stih415.dtsi       | 8 ++++----
 arch/arm/boot/dts/stih416-clock.dtsi | 5 +++--
 arch/arm/boot/dts/stih416.dtsi       | 8 ++++----
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/stih415-clock.dtsi b/arch/arm/boot/dts/stih415-clock.dtsi
index d047dbc..8ef9964 100644
--- a/arch/arm/boot/dts/stih415-clock.dtsi
+++ b/arch/arm/boot/dts/stih415-clock.dtsi
@@ -10,7 +10,7 @@
 		/*
 		 * Fixed 30MHz oscillator input to SoC
 		 */
-		CLK_SYSIN: CLK_SYSIN {
+		clk_sysin: clk-sysin {
 			#clock-cells = <0>;
 			compatible = "fixed-clock";
 			clock-frequency = <30000000>;
diff --git a/arch/arm/boot/dts/stih415.dtsi b/arch/arm/boot/dts/stih415.dtsi
index d89064c..a2dafe9 100644
--- a/arch/arm/boot/dts/stih415.dtsi
+++ b/arch/arm/boot/dts/stih415.dtsi
@@ -91,7 +91,7 @@
 			status 		= "disabled";
 			reg		= <0xfe531000 0x2c>;
 			interrupts	= <0 210 0>;
-			clocks		= <&CLK_SYSIN>;
+			clocks		= <&clk_sysin>;
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_sbc_serial1>;
 		};
@@ -126,7 +126,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfe540000 0x110>;
 			interrupts	= <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_SYSIN>;
+			clocks		= <&clk_sysin>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -139,7 +139,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfe541000 0x110>;
 			interrupts	= <GIC_SPI 207 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_SYSIN>;
+			clocks		= <&clk_sysin>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -200,7 +200,7 @@
 			compatible	= "st,comms-irb";
 			reg		= <0xfe518000 0x234>;
 			interrupts	=  <0 203 0>;
-			clocks		= <&CLK_SYSIN>;
+			clocks		= <&clk_sysin>;
 			rx-mode		= "infrared";
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_ir>;
diff --git a/arch/arm/boot/dts/stih416-clock.dtsi b/arch/arm/boot/dts/stih416-clock.dtsi
index a6942c7..10f8389 100644
--- a/arch/arm/boot/dts/stih416-clock.dtsi
+++ b/arch/arm/boot/dts/stih416-clock.dtsi
@@ -6,16 +6,17 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
 / {
 	clocks {
+
 		/*
 		 * Fixed 30MHz oscillator inputs to SoC
 		 */
-		CLK_SYSIN: CLK_SYSIN {
+		clk_sysin: clk-sysin {
 			#clock-cells = <0>;
 			compatible = "fixed-clock";
 			clock-frequency = <30000000>;
-			clock-output-names = "CLK_SYSIN";
 		};
 
 		/*
diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 78746d2..cc616b4 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -102,7 +102,7 @@
 			interrupts	= <0 210 0>;
 			pinctrl-names 	= "default";
 			pinctrl-0 	= <&pinctrl_sbc_serial1>;
-			clocks          = <&CLK_SYSIN>;
+			clocks          = <&clk_sysin>;
 		};
 
 		i2c@fed40000 {
@@ -135,7 +135,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfe540000 0x110>;
 			interrupts	= <GIC_SPI 206 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_SYSIN>;
+			clocks		= <&clk_sysin>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -148,7 +148,7 @@
 			compatible	= "st,comms-ssc4-i2c";
 			reg		= <0xfe541000 0x110>;
 			interrupts	= <GIC_SPI 207 IRQ_TYPE_LEVEL_HIGH>;
-			clocks		= <&CLK_SYSIN>;
+			clocks		= <&clk_sysin>;
 			clock-names	= "ssc";
 			clock-frequency = <400000>;
 			pinctrl-names	= "default";
@@ -206,7 +206,7 @@
 			reg		= <0xfe518000 0x234>;
 			interrupts	=  <0 203 0>;
 			rx-mode         = "infrared";
-			clocks		= <&CLK_SYSIN>;
+			clocks		= <&clk_sysin>;
 			pinctrl-names 	= "default";
 			pinctrl-0	= <&pinctrl_ir>;
 			resets		= <&softreset STIH416_IRB_SOFTRESET>;
-- 
1.9.1

