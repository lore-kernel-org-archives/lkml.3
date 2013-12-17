Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3LQNZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:25:38 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25089 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3LQNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:23:37 -0500
X-AuditID: cbfec7f4-b7fc96d000006cd4-db-52b05057c3ba
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5/5] regulator: s5m8767: Document new bindings for Buck9 GPIO
 control
Date: Tue, 17 Dec 2013 14:23:21 +0100
Message-id: <1387286601-21646-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xK7rhARuCDG7OMbVouBpiMfXhEzaL
	+UfOsVr0v1nIanHgzw5Gi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLJY2LaExeLyrjlsFmuP
	3GW3WHr9IpPFhOlrWSwOrzjAZLHu5XQWi5N/ehktTnezWlxc8YXJ4tiMJYwOoh5r5q1h9Fjw
	+Qq7x+W+XiaPnbPusnusXP6FzWPTqk42j1erZ7J63Lm2h81j3slAj74tqxg9Pm+SC+CO4rJJ
	Sc3JLEst0rdL4MpoP3mSpWCbcMWJhj1MDYwtAl2MnBwSAiYS8851sEHYYhIX7q0Hsrk4hASW
	MkosmdfNDuH0MUksW72aGaSKTcBYYvPyJWAdIgLXWCXOnAntYuTgYBaIkXgxxQ4kLCwQLnH9
	4ywmEJtFQFXixfKljCAlvALuEr+XZoOYEgIKEnMm2YBUcAp4SHxaeoIFJCwEVLF9XtUERt4F
	jAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MULi4csOxsXHrA4xCnAwKvHw7pi/PkiINbGs
	uDL3EKMEB7OSCO83jw1BQrwpiZVVqUX58UWlOanFhxiZODilGhjrNpf+cA3eFR12OMzdIuu8
	jVpZ1oLptUZTHz3PsWJn0vji5WyQ2XeZ5fwLvb4oC5P37l+9Vh/O8G/4t8lt8tYJ98snFCsF
	b3l1SZ8n9d1SLrtoh6kaTLf3RPF8iungOnNo+wP/D3fep0yz81C96iJ6yfwOZ3CY5Mr3LSeu
	LFbdN73/8PLTvPZKLMUZiYZazEXFiQBLMuCpZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for new bindings for controlling (enable/disable) the
Buck9 Converter by GPIO (BUCK9EN).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../bindings/regulator/s5m8767-regulator.txt       |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
index d1660a90fc06..6a921b5582a2 100644
--- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -43,6 +43,7 @@ Optional properties:
 - s5m8767,pmic-buck2-uses-gpio-dvs: 'buck2' can be controlled by gpio dvs.
 - s5m8767,pmic-buck3-uses-gpio-dvs: 'buck3' can be controlled by gpio dvs.
 - s5m8767,pmic-buck4-uses-gpio-dvs: 'buck4' can be controlled by gpio dvs.
+- s5m8767,pmic-buck9-uses-gpio: 'buck9' can be enabled/disabled by GPIO.
 
 Additional properties required if either of the optional properties are used:
 
@@ -54,6 +55,11 @@ Additional properties required if either of the optional properties are used:
 - s5m8767,pmic-buck-dvs-gpios: GPIO specifiers for three host gpio's used
   for dvs. The format of the gpio specifier depends in the gpio controller.
 
+- s5m8767,pmic-buck9-gpio: GPIO specifier for one GPIO controlling buck9.
+  This property is required when 's5m8767,pmic-buck9-uses-gpio' is specified.
+  Additionally for proper GPIO control the buck9 regulator should be also
+  configured with proper opmode (low power or suspend).
+
 Regulators: The regulators of s5m8767 that have to be instantiated should be
 included in a sub-node named 'regulators'. Regulator nodes included in this
 sub-node should be of the format as listed below.
@@ -126,6 +132,9 @@ Example:
 						 <1200000>, <1200000>,
 						 <1200000>, <1200000>;
 
+		s5m8767,pmic-buck9-uses-gpio;
+		s5m8767,pmic-buck9-gpio = <&gpk0 2 0>;
+
 		regulators {
 			ldo1_reg: LDO1 {
 				regulator-name = "VDD_ABB_3.3V";
@@ -148,5 +157,12 @@ Example:
 				regulator-always-on;
 				regulator-boot-on;
 			};
+
+			vemmc_reg: BUCK9 {
+				regulator-name = "VMEM_VDD_2.8V";
+				regulator-min-microvolt = <2800000>;
+				regulator-max-microvolt = <2800000>;
+				op_mode = <3>; /* Standby Mode */
+			};
 		};
 	};
-- 
1.7.9.5

