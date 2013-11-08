Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3KHWNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:13:00 -0500
Received: from ring0.de ([91.143.88.219]:60254 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758286Ab3KHWL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:11:59 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv7 2/4] dt: binding documentation for twl4030-pwrbutton
Date: Fri,  8 Nov 2013 23:11:25 +0100
Message-Id: <1383948687-32279-3-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1383948687-32279-1-git-send-email-sre@debian.org>
References: <1383948687-32279-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for twl4030-pwrbutton.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/input/twl4030-pwrbutton.txt | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt

diff --git a/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
new file mode 100644
index 0000000..c864a46
--- /dev/null
+++ b/Documentation/devicetree/bindings/input/twl4030-pwrbutton.txt
@@ -0,0 +1,21 @@
+Texas Instruments TWL family (twl4030) pwrbutton module
+
+This module is part of the TWL4030. For more details about the whole
+chip see Documentation/devicetree/bindings/mfd/twl-familly.txt.
+
+This module provides a simple power button event via an Interrupt.
+
+Required properties:
+- compatible: should be one of the following
+   - "ti,twl4030-pwrbutton": For controllers compatible with twl4030
+- interrupts: should be one of the following
+   - <8>: For controllers compatible with twl4030
+
+Example:
+
+&twl {
+	twl_pwrbutton: pwrbutton {
+		compatible = "ti,twl4030-pwrbutton";
+		interrupts = <8>;
+	};
+};
-- 
1.8.4.rc3

