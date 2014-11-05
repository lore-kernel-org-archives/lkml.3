Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaKEPQK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:16:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:42519 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932149AbaKEPPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:15:50 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv9 2/2] pwm: sunxi: document OF bindings
Date: Wed,  5 Nov 2014 16:15:45 +0100
Message-Id: <1415200545-26238-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415200545-26238-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1415200545-26238-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the documentation for the Allwinner SoCs PWM bindings.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/devicetree/bindings/pwm/pwm-sun4i.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sun4i.txt

diff --git a/Documentation/devicetree/bindings/pwm/pwm-sun4i.txt b/Documentation/devicetree/bindings/pwm/pwm-sun4i.txt
new file mode 100644
index 000000000000..ae0273e19506
--- /dev/null
+++ b/Documentation/devicetree/bindings/pwm/pwm-sun4i.txt
@@ -0,0 +1,20 @@
+Allwinner sun4i and sun7i SoC PWM controller
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
2.1.0

