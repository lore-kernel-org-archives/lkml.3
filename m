Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaBKNGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:06:39 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34136 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaBKNES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-a5-52fa1fd1aeec
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
Subject: [PATCH 10/14] Documentation: mfd: s2mps11: Document support for S2MPS14
Date: Tue, 11 Feb 2014 14:03:53 +0100
Message-id: <1392123837-5517-11-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xK7oX5X8FGcxdwGaxccZ6VoupD5+w
	Wcw/co7Vov/NQlaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y26x
	9PpFJosJ09eyWLTuPcJucbqb1eLiii9MFutnvGZxEPJYM28No8flvl4mj52z7rJ7rFz+hc1j
	06pONo871/awecw7GejRt2UVo8fnTXIBnFFcNimpOZllqUX6dglcGQt3tDMWLBOo2HP3BVMD
	4xLeLkZODgkBE4kPb+YzQthiEhfurWcDsYUEljJKbHrpDWH3MUnMuFIMYrMJGEtsXr4EqIaL
	Q0RgM6PE4u9XWUEcZoEeFonNp1vAJgkLBEj0XFzGAmKzCKhK9DUdB7N5Bdwl5k/vA7I5gLYp
	SMyZZAMS5gQK9336zwYSFhJwk1jeHzuBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxN
	jJAQ/7KDcfExq0OMAhyMSjy8GxR/BgmxJpYVV+YeYpTgYFYS4f0i/CtIiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA2Oh2fe2+iMB94UbIsQP7dY60tFWuCPu8OF/rVZHLS+uVImsfpfWeHZiwNK4
	EudUnWM98sU7PtzbEnGkKruAa/XS2//YVhUVenHn7vx653VpP1esSmarwbswvQsqVcoVdfG3
	dq4zWXkjpYl/Vs6K2er/XshPWqy/fXcD4+JJP1UWb/20wEptSpMSS3FGoqEWc1FxIgBeXzzC
	TwIAAA==
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

