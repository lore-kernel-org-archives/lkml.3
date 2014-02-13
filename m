Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaBMJOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:14:54 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:54968 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaBMJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:37 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-9b-52fc8cf21241
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 10/14] Documentation: mfd: s2mps11: Document support for
 S2MPS14
Date: Thu, 13 Feb 2014 10:14:03 +0100
Message-id: <1392282847-25444-11-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7qfe/4EGVxRttg4Yz2rxdSHT9gs
	5h85x2rR/2Yhq8W5VysZLV6/MLQ42/SG3eL+16OMFt+udDBZXN41h81ixvl9TBZrj9xlt1h6
	/SKTxYTpa1ksWvceYbc43c1qcXHFFyaL9TNeszgIeayZt4bR43JfL5PHzll32T1WLv/C5rFp
	VSebx51re9g85p0M9OjbsorR4/MmuQDOKC6blNSczLLUIn27BK6MhTvaGQuWCVTsufuCqYFx
	CW8XIyeHhICJxLN5e1kgbDGJC/fWs3UxcnEICSxllDiycCEzhNPHJLFp8VtmkCo2AWOJzcuX
	gFWJCGxmlFj8/SoriMMs0MMisfl0CyNIlbBAqMT+l6dZQWwWAVWJbXeb2EBsXgEPiQO3lzF1
	MXIA7VOQmDPJBiTMCRT+9+M32AIhAXeJnsWz2Ccw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqX
	rpecn7uJERLmX3YwLj5mdYhRgINRiYfXYtnvICHWxLLiytxDjBIczEoivDISf4KEeFMSK6tS
	i/Lji0pzUosPMTJxcEo1MLYEf9jxLeSJ9VHxR1rTO3MKtqbLlq6uWVbVGPH77PQFjq4cbaL3
	exTT27+2lK+59+6oblXJ3qeJp9rmbTA26xIonWdgZniVSWHh6lKubXXmDBbH9+1MlJ6r4JV3
	rrOAQ+i0za+19g3GUp9il32OfF3DwXxI63Rembr9lvN/9h6+YxpU5rHniRJLcUaioRZzUXEi
	AI+AoYtRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bindings documentation for S2MPS14 device to the s2mps11 driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index 15ee89c3cc7b..f69bec294f02 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -1,5 +1,5 @@
 
-* Samsung S2MPS11 Voltage and Current Regulator
+* Samsung S2MPS11 and S2MPS14 Voltage and Current Regulator
 
 The Samsung S2MPS11 is a multi-function device which includes voltage and
 current regulators, RTC, charger controller and other sub-blocks. It is
@@ -7,7 +7,7 @@ interfaced to the host controller using an I2C interface. Each sub-block is
 addressed by the host system using different I2C slave addresses.
 
 Required properties:
-- compatible: Should be "samsung,s2mps11-pmic".
+- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic".
 - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
 
 Optional properties:
@@ -59,10 +59,14 @@ supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
 as per the datasheet of s2mps11.
 
 	- LDOn
-		  - valid values for n are 1 to 38
+		  - valid values for n are:
+			- S2MPS11: 1 to 38
+			- S2MPS14: 1 to 25
 		  - Example: LDO1, LD02, LDO28
 	- BUCKn
-		  - valid values for n are 1 to 10.
+		  - valid values for n are:
+			- S2MPS11: 1 to 10
+			- S2MPS14: 1 to 5
 		  - Example: BUCK1, BUCK2, BUCK9
 
 Example:
-- 
1.7.9.5

