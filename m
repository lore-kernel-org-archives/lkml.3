Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaKTQxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:53:36 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64509 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbaKTQxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:53:33 -0500
From: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Nikolaus Schulz <nikolaus.schulz@avionic-design.de>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Cc: Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 1/2] iio: document ti-dac8554 devicetree bindings
Date: Thu, 20 Nov 2014 17:54:17 +0100
Message-Id: <1416502461-13980-1-git-send-email-nikolaus.schulz@avionic-design.de>
X-Mailer: git-send-email 2.1.3
X-Provags-ID: V02:K0:a6rXiGADCbZrveumO9Au0ntdkGSWUT9ocBx6stN8Z6k
 UXUonYDW1Xjx4JBci/udTn3hVfxve4koT+OowfyTSUtO0J+xO+
 XNA8mzfeqsjf/EviTHchLF7RlA/xuJWujeqpKDG4sm2jNRh6YS
 K+0/KrKeDGWL8zRz1U7tHe/2e//WWsQx5uUK0PFLj8WgkbaO26
 xh9tGv7NYqRwR7v4YsB9Tt3Bi+SLyGucXUYCfRVSboWTLaFx8t
 pHl5ekH/LJuniLeUFHKaImXtu3qdj97SLC1QmOS8YFFs0wj0O1
 b9gkJNXKCpMjDzOSlkWdalNiLPLtoosn9JBgSiVoRoSyfETm7W
 y0OCu/aT6fT+ejPfF4W/MrtaUCkjyXJpBE0mSJ5It8NJjaYOr5
 vBaM4C1YJ+deyoJbEa+fHZvcUTz4sjUTjkynQMgvszwqrEcwy8
 g+XWzsG8rJ/xLGbH49Vh3mJbTOQ==
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

