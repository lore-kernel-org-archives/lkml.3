Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab3IJMuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:50:04 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:52205 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab3IJMt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:49:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk
Cc: arnd@arndb.de, linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 11/38] Documentation: dt: iio: Add binding for LSM303DLH
Date: Tue, 10 Sep 2013 13:49:12 +0100
Message-Id: <1378817379-8238-12-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LSM303DLH is a Accelerometer Sensor

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/iio/accel/lsm303dlh.txt     | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/accel/lsm303dlh.txt

diff --git a/Documentation/devicetree/bindings/iio/accel/lsm303dlh.txt b/Documentation/devicetree/bindings/iio/accel/lsm303dlh.txt
new file mode 100644
index 0000000..bb59363
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/accel/lsm303dlh.txt
@@ -0,0 +1,21 @@
+* STMicroelectronics Accelerometer Sensor
+
+Required properties:
+  - compatible: Should be "st,lsm303dlh_accel"
+  - reg: The I2C address of the sensor
+
+Optional properties:
+  - vdd-supply: Phandle to the Vdd supply regulator
+  - vddio-supply: Phandle to the Vdd-IO supply regulator
+
+Example:
+
+i2c@80128000 {
+	lsm303dlh_accel@19 {
+		compatible = "st,lsm303dlh_accel";
+		reg = <0x19>;
+
+		vdd-supply = <&ab8500_ldo_aux1_reg>;
+		vddio-supply = <&db8500_vsmps2_reg>;
+	};
+};
-- 
1.8.1.2

