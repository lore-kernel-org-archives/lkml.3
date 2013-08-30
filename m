Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3H3Ea7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:30:59 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54222 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3H3EaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:30:02 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 5/6] extcon-gpio: Describe devicetree bindings
Date: Thu, 29 Aug 2013 21:29:37 -0700
Message-Id: <1377836978-24082-6-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 .../devicetree/bindings/extcon/extcon-gpio         |   23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio

diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio b/Documentation/devicetree/bindings/extcon/extcon-gpio
new file mode 100644
index 0000000..091ddc6
--- /dev/null
+++ b/Documentation/devicetree/bindings/extcon/extcon-gpio
@@ -0,0 +1,23 @@
+Device-Tree bindings for extcon/extcon-gpio driver
+
+Required properties:
+	- compatible = "gpio-connector";
+	- presence-detect-gpios - presence detect gpio pin
+
+Optional properties:
+	- debounce-interval - debounce interval in milli-seconds
+	- state-on - on (connected) state
+	- state-off - off (disconnected) state
+	  Depending on the type of connector or cable, states may
+	  for example be reported as "connected"/"disconnected"
+	  or "inserted"/"removed".
+
+Example node:
+
+	some-connector {
+		compatible = "gpio-connector";
+		presence-detect-gpios = <&gpio1 7 1>;
+		debounce-interval = <1>;
+		state-on = "connected";
+		state-on = "disconnected";
+	};
-- 
1.7.9.7

