Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab3IJM7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:59:03 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:64429 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3IJMt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:49:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/38] Documentation: dt: iio: Add binding for LPS001WP
Date: Tue, 10 Sep 2013 13:49:11 +0100
Message-Id: <1378817379-8238-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LPS001WP is a Pressure and Temperature sensor.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/iio/pressure/lps001wp.txt   | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/pressure/lps001wp.txt

diff --git a/Documentation/devicetree/bindings/iio/pressure/lps001wp.txt b/Documentation/devicetree/bindings/iio/pressure/lps001wp.txt
new file mode 100644
index 0000000..3294a65c6
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/pressure/lps001wp.txt
@@ -0,0 +1,21 @@
+* STMicroelectronics Pressure Sensor
+
+Required properties:
+  - compatible: Should be "st,lps001wp_press"
+  - reg: The I2C address of the sensor
+
+Optional properties:
+  - vdd-supply: Phandle to the Vdd supply regulator
+  - vddio-supply: Phandle to the Vdd-IO supply regulator
+
+Example:
+
+i2c@80128000 {
+        lps001wp@5c {
+                compatible = "st,lps001wp_press";
+                reg = <0x5c>;
+
+                vdd-supply = <&ab8500_ldo_aux1_reg>;
+                vddio-supply = <&db8500_vsmps2_reg>;
+        };
+};
-- 
1.8.1.2

