Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaIOTOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:14:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40619 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752725AbaIOTOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:14:05 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv6 2/2] pwm: sunxi: document OF bindings
Date: Mon, 15 Sep 2014 21:13:56 +0200
Message-Id: <1410808436-21460-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410808436-21460-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1410808436-21460-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the documentation for the Allwinner SoCs PWM bindings.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/devicetree/bindings/pwm/pwm-sunxi.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sunxi.txt

diff --git a/Documentation/devicetree/bindings/pwm/pwm-sunxi.txt b/Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
new file mode 100644
index 000000000000..215d33d94870
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
@@ -0,0 +1,20 @@
+Allwinner SoC PWM controller
+
+Required properties:
+  - compatible: should be one of:
+    - "allwinner,sun4i-a10-pwm"
+    - "allwinner,sun7i-a20-pwm"
+  - reg: physical base address and length of the controller's registers
+  - #pwm-cells: should be 3. See pwm.txt in this directory for a description of
+    the cells format.
+  - clocks: From common clock binding, handle to the parent clock.
+
+Example:
+
+	pwm: pwm@01c20e00 {
+		compatible = "allwinner,sun7i-a20-pwm";
+		reg = <0x01c20e00 0xc>;
+		clocks = <&osc24M>;
+		#pwm-cells = <3>;
+		status = "disabled";
+	};
-- 
1.9.1

