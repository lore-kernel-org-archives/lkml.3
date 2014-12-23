Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaLWH7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:59:50 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42136 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbaLWH7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:59:35 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Baruch Siach <baruch@tkos.co.il>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH 8/8] clocksource: devicetree: document Conexant Digicolor timer binding
Date: Tue, 23 Dec 2014 09:58:45 +0200
Message-Id: <f2e3c6e9975ad08b63d7643caba79a06f7616d95.1419318109.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1419318109.git.baruch@tkos.co.il>
References: <cover.1419318109.git.baruch@tkos.co.il>
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
index 000000000000..623812da03b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/digicolor-timer.txt
@@ -0,0 +1,18 @@
+Conexant Digicolor SoCs Timer Controller
+
+Required properties:
+
+- compatible : should be "cnxt,cx92755-timer"
+- reg : Specifies base physical address and size of the MISC area, that is
+  where the "Agent Communication" registers are located
+- interrupts : Contains 8 interrupts, one for each timer
+- clocks: phandle to the main clock
+
+Example:
+
+	timer@f0000000 {
+		compatible = "cnxt,cx92755-timer";
+		reg = <0xf0000000 0x1000>;
+		interrupts = <19>, <31>, <34>, <35>, <52>, <53>, <54>, <55>;
+		clocks = <&main_clk>;
+	};
-- 
2.1.3

