Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaCATdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 14:33:54 -0500
Received: from ring0.de ([5.45.105.125]:46615 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420AbaCATdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 14:33:51 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv1 6/9] Documentation: DT: Document twl4030-madc binding
Date: Sat,  1 Mar 2014 20:32:42 +0100
Message-Id: <1393702365-26429-7-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393702365-26429-1-git-send-email-sre@debian.org>
References: <1393444990-28140-1-git-send-email-sre@debian.org>
 <1393702365-26429-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree binding documentation for twl4030-madc
analog digital converter.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/iio/adc/twl4030-madc.txt   | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt

diff --git a/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt b/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
new file mode 100644
index 0000000..6bdd214
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
@@ -0,0 +1,24 @@
+* TWL4030 Monitoring Analog to Digital Converter (MADC)
+
+The MADC subsystem in the TWL4030 consists of a 10-bit ADC
+combined with a 16-input analog multiplexer.
+
+Required properties:
+  - compatible: Should contain "ti,twl4030-madc".
+  - interrupts: IRQ line for the MADC submodule.
+  - #io-channel-cells: Should be set to <1>.
+
+Optional properties:
+  - ti,system-uses-second-madc-irq: boolean, set if the second madc irq register
+				    should be used, which is intended to be used
+				    by Co-Processors (e.g. a modem).
+
+Example:
+
+&twl {
+	madc {
+		compatible = "ti,twl4030-madc";
+		interrupts = <3>;
+		#io-channel-cells = <1>;
+	};
+};
-- 
1.9.0

