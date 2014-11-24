Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaKXTtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:49:13 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:57228 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaKXTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:49:09 -0500
From: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Nikolaus Schulz <nikolaus.schulz@avionic-design.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v2 1/2] iio: document ti-dac8554 devicetree bindings
Date: Mon, 24 Nov 2014 20:50:11 +0100
Message-Id: <1416858614-32265-1-git-send-email-nikolaus.schulz@avionic-design.de>
X-Mailer: git-send-email 2.1.3
X-Provags-ID: V02:K0:0M3CCA+yZt5qU8LuL09MsatsSn4bzZV+AGTiFhz8eMR
 hRprzv9mPfPaCE9yysV9viUvpTKdVH2S/WIO8Kw3e80PyQgJ9Y
 VyJMrZz9RzjyZppDKDNuXvbKqHX7fRwVsCYB5EiaG8ICu9JxR7
 Sf5MVphqLVmKlzaRPULHS5ArBe5kS3ztpDnHus/yQpoj5V4zjf
 +g39p4gH0kRUkXotmwBF7JjbVaj96v2HP89O0O3/hvgl1nEvkr
 yZJ1MCRYG5gCX5Re1SQF+H7GyHADBFEmknZNrfgw6wS0m7wp2p
 HL+f/OvxETUJObR0ebHjAKFAxuJfjz+koO0qasAuCZOyQtTXOw
 apdAA9+kIS2dVhAjNU5GxfZSCW4W15PKbNbPTxu8/XtsalYbys
 peWJo1xGjv3Pvr6IETdYxKf41DL/t+rvpxwyvw0HrxrWIYnCTK
 f8UyinO8nYFjMPMfcnJEkEAac0w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
---
 .../devicetree/bindings/iio/dac/ti-dac8554.txt     | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt

diff --git a/Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt b/Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt
new file mode 100644
index 0000000..16f7178
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt
@@ -0,0 +1,22 @@
+TI DAC8554 Digital to Analog Converter
+
+This driver supports the SPI bus.
+
+Required properties:
+	- compatible: must be "ti,dac8554"
+	- vref-supply: the vref power supply
+	- address: the additional 2-bit chip address
+
+For required properties on SPI, please consult
+Documentation/devicetree/bindings/spi/spi-bus.txt
+
+Example:
+
+	dac8554@0 {
+		compatible = "ti,dac8554";
+		reg = <0>;
+		spi-max-frequency = <50000000>;
+
+		vref-supply = <&vdd_vref>;
+		address = <0>;
+	};
-- 
2.1.3

