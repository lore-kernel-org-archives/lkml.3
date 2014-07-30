Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaG3AgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:36:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38770 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaG3AgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:36:20 -0400
From: Suman Anna <s-anna@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Jassi Brar <jaswinder.singh@linaro.org>, Dave Gerlach <d-gerlach@ti.com>,
        Markus Mayer <markus.mayer@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCHv3 5/5] ARM: dts: OMAP2+: Add #mbox-cells property to all mailbox nodes
Date: Tue, 29 Jul 2014 19:34:39 -0500
Message-ID: <1406680479-18446-6-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406680479-18446-1-git-send-email-s-anna@ti.com>
References: <1406680479-18446-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The '#mbox-cells' property is added to all the OMAP mailbox
nodes. This property is mandatory with the new mailbox framework.

Cc: "Benoît Cousson" <bcousson@baylibre.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi   |  1 +
 arch/arm/boot/dts/am4372.dtsi   |  1 +
 arch/arm/boot/dts/dra7.dtsi     | 13 +++++++++++++
 arch/arm/boot/dts/omap2420.dtsi |  1 +
 arch/arm/boot/dts/omap2430.dtsi |  1 +
 arch/arm/boot/dts/omap3.dtsi    |  1 +
 arch/arm/boot/dts/omap4.dtsi    |  1 +
 arch/arm/boot/dts/omap5.dtsi    |  1 +
 8 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index e4f165a..5663ff5 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -352,6 +352,7 @@
 			reg = <0x480C8000 0x200>;
 			interrupts = <77>;
 			ti,hwmods = "mailbox";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <8>;
 			mbox_wkupm3: wkup_m3 {
diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 3be2a87..8619519 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -166,6 +166,7 @@
 			reg = <0x480C8000 0x200>;
 			interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mailbox";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <8>;
 			mbox_wkupm3: wkup_m3 {
diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 99c40d4..626137f 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -342,6 +342,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x4a0f4000 0x200>;
 			ti,hwmods = "mailbox1";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <3>;
 			ti,mbox-num-fifos = <8>;
 			status = "disabled";
@@ -351,6 +352,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x4883a000 0x200>;
 			ti,hwmods = "mailbox2";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -360,6 +362,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x4883c000 0x200>;
 			ti,hwmods = "mailbox3";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -369,6 +372,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x4883e000 0x200>;
 			ti,hwmods = "mailbox4";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -378,6 +382,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48840000 0x200>;
 			ti,hwmods = "mailbox5";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -387,6 +392,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48842000 0x200>;
 			ti,hwmods = "mailbox6";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -396,6 +402,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48844000 0x200>;
 			ti,hwmods = "mailbox7";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -405,6 +412,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48846000 0x200>;
 			ti,hwmods = "mailbox8";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -414,6 +422,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x4885e000 0x200>;
 			ti,hwmods = "mailbox9";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -423,6 +432,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48860000 0x200>;
 			ti,hwmods = "mailbox10";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -432,6 +442,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48862000 0x200>;
 			ti,hwmods = "mailbox11";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -441,6 +452,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48864000 0x200>;
 			ti,hwmods = "mailbox12";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
@@ -450,6 +462,7 @@
 			compatible = "ti,omap4-mailbox";
 			reg = <0x48802000 0x200>;
 			ti,hwmods = "mailbox13";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <12>;
 			status = "disabled";
diff --git a/arch/arm/boot/dts/omap2420.dtsi b/arch/arm/boot/dts/omap2420.dtsi
index d14f16c..bea6f07 100644
--- a/arch/arm/boot/dts/omap2420.dtsi
+++ b/arch/arm/boot/dts/omap2420.dtsi
@@ -157,6 +157,7 @@
 			interrupts = <26>, <34>;
 			interrupt-names = "dsp", "iva";
 			ti,hwmods = "mailbox";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <6>;
 			mbox_dsp: dsp {
diff --git a/arch/arm/boot/dts/omap2430.dtsi b/arch/arm/boot/dts/omap2430.dtsi
index db02be2..689bd08 100644
--- a/arch/arm/boot/dts/omap2430.dtsi
+++ b/arch/arm/boot/dts/omap2430.dtsi
@@ -247,6 +247,7 @@
 			reg = <0x48094000 0x200>;
 			interrupts = <26>;
 			ti,hwmods = "mailbox";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <4>;
 			ti,mbox-num-fifos = <6>;
 			mbox_dsp: dsp {
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index b2ae8b8..75c290f 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -332,6 +332,7 @@
 			ti,hwmods = "mailbox";
 			reg = <0x48094000 0x200>;
 			interrupts = <26>;
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <2>;
 			ti,mbox-num-fifos = <2>;
 			mbox_dsp: dsp {
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index bc54d66..d08b98a 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -654,6 +654,7 @@
 			reg = <0x4a0f4000 0x200>;
 			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mailbox";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <3>;
 			ti,mbox-num-fifos = <8>;
 			mbox_ipu: mbox_ipu {
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index f7ec4cd..0b8cf23 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -641,6 +641,7 @@
 			reg = <0x4a0f4000 0x200>;
 			interrupts = <GIC_SPI 26 IRQ_TYPE_LEVEL_HIGH>;
 			ti,hwmods = "mailbox";
+			#mbox-cells = <1>;
 			ti,mbox-num-users = <3>;
 			ti,mbox-num-fifos = <8>;
 			mbox_ipu: mbox_ipu {
-- 
2.0.0

