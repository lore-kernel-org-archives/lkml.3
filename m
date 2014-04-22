Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaDVSkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:40:35 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:55365 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaDVSka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:40:30 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Signed-off-by: Mark Brown" <broonie@linaro.org>
Subject: [PATCH 2/4] dt: bindings: Typo s/interrupts-names/interrupt-names/g
Date: Tue, 22 Apr 2014 20:40:23 +0200
Message-Id: <1398192025-31523-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
References: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Signed-off-by: Mark Brown <broonie@linaro.org>
---
 .../devicetree/bindings/pinctrl/pinctrl-st.txt     |    4 ++--
 .../bindings/sound/davinci-mcasp-audio.txt         |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
index 4bd5be0e5e7d..26bcb18f4e60 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
@@ -83,7 +83,7 @@ Example:
 		reg 		= <0xfe61f080 0x4>;
 		reg-names	= "irqmux";
 		interrupts 	= <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>;
-		interrupts-names = "irqmux";
+		interrupt-names	= "irqmux";
 		ranges 		= <0 0xfe610000 0x5000>;
 
 		PIO0: gpio@fe610000 {
@@ -165,7 +165,7 @@ sdhci0:sdhci@fe810000{
 	interrupt-parent = <&PIO3>;
 	#interrupt-cells = <2>;
 	interrupts = <3 IRQ_TYPE_LEVEL_HIGH>; /* Interrupt line via PIO3-3 */
-	interrupts-names = "card-detect";
+	interrupt-names = "card-detect";
 	pinctrl-names = "default";
 	pinctrl-0	= <&pinctrl_mmc>;
 };
diff --git a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt
index 569b26c4a81e..60ca07996458 100644
--- a/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt
+++ b/Documentation/devicetree/bindings/sound/davinci-mcasp-audio.txt
@@ -47,7 +47,7 @@ mcasp0: mcasp0@1d00000 {
 	reg = <0x100000 0x3000>;
 	reg-names "mpu";
 	interrupts = <82>, <83>;
-	interrupts-names = "tx", "rx";
+	interrupt-names = "tx", "rx";
 	op-mode = <0>;		/* MCASP_IIS_MODE */
 	tdm-slots = <2>;
 	serial-dir = <
-- 
1.7.9.5

