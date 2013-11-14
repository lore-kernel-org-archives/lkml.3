Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3KNMjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 07:39:39 -0500
Received: from ring0.de ([91.143.88.219]:55344 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab3KNMjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 07:39:35 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@debian.org>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/2] dt: binding documentation for isp1704 charger
Date: Thu, 14 Nov 2013 12:38:54 +0000
Message-Id: <1384432734-1490-2-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384432734-1490-1-git-send-email-sre@debian.org>
References: <1384432734-1490-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for isp1704-charger.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 Documentation/devicetree/bindings/power/isp1704.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/isp1704.txt

diff --git a/Documentation/devicetree/bindings/power/isp1704.txt b/Documentation/devicetree/bindings/power/isp1704.txt
new file mode 100644
index 0000000..bbeec11
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/isp1704.txt
@@ -0,0 +1,17 @@
+Binding for NXP ISP1704 USB Charger Detection
+
+Required properties:
+- compatible: Should contain one of the following:
+ * "nxp,isp1704"
+- nxp,enable-gpio: Should contain a phandle to the
+  GPIO pin connected to the chip's enable pin.
+- usb-phy: Should contain a phandle to the USB PHY
+  the ISP1704 is connected to.
+
+Example:
+
+isp1704 {
+	compatible = "nxp,isp1704";
+	nxp,enable-gpio = <&gpio3 3 GPIO_ACTIVE_LOW>;
+	usb-phy = <&usb2_phy>;
+};
-- 
1.8.4.2

