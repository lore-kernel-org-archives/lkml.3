Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbbAUGgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:36:43 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:43162 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbbAUGgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:36:40 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH v3 1/2] clocksource: devicetree: document Conexant Digicolor timer binding
Date: Wed, 21 Jan 2015 08:36:28 +0200
Message-Id: <6812ad4ac585e40ad7d8282eef1d64be8bc6eaa5.1421821466.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1421821466.git.baruch@tkos.co.il>
References: <cover.1421821466.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 .../devicetree/bindings/timer/digicolor-timer.txt      | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/digicolor-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/digicolor-timer.txt b/Documentation/devicetree/bindings/timer/digicolor-timer.txt
new file mode 100644
index 000000000000..d1b659bbc29f
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/digicolor-timer.txt
@@ -0,0 +1,18 @@
+Conexant Digicolor SoCs Timer Controller
+
+Required properties:
+
+- compatible : should be "cnxt,cx92755-timer"
+- reg : Specifies base physical address and size of the "Agent Communication"
+  timer registers
+- interrupts : Contains 8 interrupts, one for each timer
+- clocks: phandle to the main clock
+
+Example:
+
+	timer@f0000fc0 {
+		compatible = "cnxt,cx92755-timer";
+		reg = <0xf0000fc0 0x40>;
+		interrupts = <19>, <31>, <34>, <35>, <52>, <53>, <54>, <55>;
+		clocks = <&main_clk>;
+	};
-- 
2.1.4

