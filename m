Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaKRJAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:00:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36025 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaKRJAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:00:01 -0500
X-AuditID: cbfee68e-f79b46d000002b74-64-546b0a80dd21
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 5/5] mfd: s2mps11: Add binding documentation for Samsung
 S2MPS13 PMIC
Date: Tue, 18 Nov 2014 17:59:43 +0900
Message-id: <1416301183-10478-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
References: <1416301183-10478-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSoNvAlR1i0N1hbrHk4lV2i6kPn7BZ
	XP/ynNVi/pFzrBZ/JrSyWUy6P4HF4vULQ4uzTW/YLe5/Pcpo8e1KB5PF5V1z2CyeTrjIZnG6
	m9Xi4oovTA58Hjtn3WX32LSqk83jzrU9bB7zTgZ69G1Zxegxfd5PJo/Pm+QC2KO4bFJSczLL
	Uov07RK4Mh4eW8lScEam4uqXc4wNjCfFuhg5OSQETCQmTJ3GBmGLSVy4tx7I5uIQEljKKDHh
	0gt2mKIdMw4xQySmM0rM7/3OBOE0MUlsbPrCCFLFJqAlsf/FDbBRIgLREsefHmcEKWIW6GGS
	eN+7EaxIWCBSYtbpo6wgNouAqsSWg31MIDavgKvEm2WTodYpSCxbPhOshlPATeLA8cVgQ4WA
	ak53HgQ7Q0LgGrvE1oXnmCEGCUh8m3yIpYuRAyghK7HpADPEHEmJgytusExgFF7AyLCKUTS1
	ILmgOCm9yEivODG3uDQvXS85P3cTIzB+Tv971reD8eYB60OMAhyMSjy8CVOzQoRYE8uKK3MP
	MZoCbZjILCWanA+M0rySeENjMyMLUxNTYyNzSzMlcd4EqZ/BQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhjNrCxVtNvjOpj3XpubNtX15MVHVxYKXLnHOINnx7Y8xtLicv1fZYkqpgW/zsy+
	ZyD6e6+x509De3nrrr1bPiiLJz3fO6X6/6fZWUt3ia+6uk5Za+UW8egUKx5hho0BPZ+0/nUf
	WrWvNkPxJdPH9NCQqM/P7K9eeNnEIXBFruL8Qe21qX+jRLYosRRnJBpqMRcVJwIAFwu/mJoC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQd0GruwQg/nfdC2WXLzKbjH14RM2
	i+tfnrNazD9yjtXiz4RWNotJ9yewWLx+YWhxtukNu8X9r0cZLb5d6WCyuLxrDpvF0wkX2SxO
	d7NaXFzxhcmBz2PnrLvsHptWdbJ53Lm2h81j3slAj74tqxg9ps/7yeTxeZNcAHtUA6NNRmpi
	SmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDFSgpliTmlQKGA
	xOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMh8dWshSckam4+uUcYwPjSbEuRk4OCQET
	iR0zDjFD2GISF+6tZ+ti5OIQEpjOKDG/9zsThNPEJLGx6QsjSBWbgJbE/hc32EBsEYFoieNP
	jzOCFDEL9DBJvO/dCFYkLBApMev0UVYQm0VAVWLLwT4mEJtXwFXizbLJ7BDrFCSWLZ8JVsMp
	4CZx4PhisKFCQDWnOw8yT2DkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjODqfSe1g
	XNlgcYhRgINRiYc3YWpWiBBrYllxZe4hRgkOZiUR3nPdQCHelMTKqtSi/Pii0pzU4kOMpkBX
	TWSWEk3OByaOvJJ4Q2MTMyNLI3NDCyNjcyVx3gOt1oFCAumJJanZqakFqUUwfUwcnFINjJsb
	tj10CpBdneBU1r01+J7l75C68yKXb7CcbH15wqdt7/1zWio3zqikTjHUX+Qiw/2hO7h7ocfb
	x8WFmQZJWZZc7Pt8260Ner6xd/Zt3xIrIOq7se3fgknnb3z+kle83CAitYi98U/WpZUOwk+n
	BtRHOEy+y7oyZKnX7xADcX53+bzyYqFdSizFGYmGWsxFxYkAj4jZ4eQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the binding documentation for Samsung S2MPS13 PMIC
which is similiar with existing S2MPS14 PMIC. S2MPS13 has the different number
of regulators from S2MPS14 and RTC/Clock is the same with the S2MPS14.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index 0e4026a..57a0450 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -1,5 +1,5 @@
 
-* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
+* Samsung S2MPS11, S2MPS13, S2MPS14 and S2MPU02 Voltage and Current Regulator
 
 The Samsung S2MPS11 is a multi-function device which includes voltage and
 current regulators, RTC, charger controller and other sub-blocks. It is
@@ -7,8 +7,8 @@ interfaced to the host controller using an I2C interface. Each sub-block is
 addressed by the host system using different I2C slave addresses.
 
 Required properties:
-- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
-              or "samsung,s2mpu02-pmic".
+- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps13-pmic"
+	      or "samsung,s2mps14-pmic" or "samsung,s2mpu02-pmic".
 - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
 
 Optional properties:
@@ -17,8 +17,8 @@ Optional properties:
 - interrupts: Interrupt specifiers for interrupt sources.
 
 Optional nodes:
-- clocks: s2mps11 and s5m8767 provide three(AP/CP/BT) buffered 32.768 KHz
-  outputs, so to register these as clocks with common clock framework
+- clocks: s2mps11, s2mps13 and s5m8767 provide three(AP/CP/BT) buffered 32.768
+  KHz outputs, so to register these as clocks with common clock framework
   instantiate a sub-node named "clocks". It uses the common clock binding
   documented in :
   [Documentation/devicetree/bindings/clock/clock-bindings.txt]
@@ -30,12 +30,12 @@ Optional nodes:
     the clock which they consume.
     Clock               ID           Devices
     ----------------------------------------------------------
-    32KhzAP		0            S2MPS11, S2MPS14, S5M8767
-    32KhzCP		1            S2MPS11, S5M8767
-    32KhzBT		2            S2MPS11, S2MPS14, S5M8767
+    32KhzAP		0            S2MPS11, S2MPS13, S2MPS14, S5M8767
+    32KhzCP		1            S2MPS11, S2MPS13, S5M8767
+    32KhzBT		2            S2MPS11, S2MPS13, S2MPS14, S5M8767
 
-  - compatible: Should be one of: "samsung,s2mps11-clk", "samsung,s2mps14-clk",
-		"samsung,s5m8767-clk"
+  - compatible: Should be one of: "samsung,s2mps11-clk", "samsung,s2mps13-clk",
+		"samsung,s2mps14-clk", "samsung,s5m8767-clk"
 
 - regulators: The regulators of s2mps11 that have to be instantiated should be
 included in a sub-node named 'regulators'. Regulator nodes included in this
@@ -81,12 +81,14 @@ as per the datasheet of s2mps11.
 	- LDOn
 		  - valid values for n are:
 			- S2MPS11: 1 to 38
+			- S2MPS13: 1 to 40
 			- S2MPS14: 1 to 25
 			- S2MPU02: 1 to 28
 		  - Example: LDO1, LDO2, LDO28
 	- BUCKn
 		  - valid values for n are:
 			- S2MPS11: 1 to 10
+			- S2MPS13: 1 to 10
 			- S2MPS14: 1 to 5
 			- S2MPU02: 1 to 7
 		  - Example: BUCK1, BUCK2, BUCK9
-- 
1.8.5.5

