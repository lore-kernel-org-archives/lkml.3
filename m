Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaLOLi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:38:29 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:58885 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLOLi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:38:27 -0500
From: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
To: linux-iio@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Nikolaus Schulz <nikolaus.schulz@avionic-design.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v3 1/2] iio: document ti-dac8554 devicetree bindings
Date: Mon, 15 Dec 2014 12:39:56 +0100
Message-Id: <1418643605-15554-1-git-send-email-nikolaus.schulz@avionic-design.de>
X-Mailer: git-send-email 2.1.3
X-Provags-ID: V03:K0:9RX+SGHcooXRycOCiO5rTCGAGqG0CDW6xlHEwrk+eHoBlh+Al2O
 ZbYJ+B74PJ5hfzy7mKSEm9jS6c3jmqhathgzMB/vbDgU6ILeqlVToWMcTim4dAeNKxbZJGB
 Ur79PnYEYTUzsZGXP+0Wk5zoLgC4b2zP0u+8UwBngZU/Ktu2yNJpeEhFiqzYOlZPryuzcVy
 H3ch5YDg/KTy2rsppJ/1A==
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
index 0000000..32e96859
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
+	- ti,address: the additional 2-bit chip address
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
+		ti,address = <0>;
+	};
-- 
2.1.3

