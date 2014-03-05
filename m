Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaCEJYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:24:07 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45753 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaCEJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:23:07 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c5-5316ecf68974
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 3/3] Documentation: mfd: s2mps11: Document support for S2MPS14
Date: Wed, 05 Mar 2014 10:22:53 +0100
Message-id: <1394011373-4057-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xa7rf3ogFG/x9pWKxccZ6VoupD5+w
	Wcw/co7Vov/NQlaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgsri8aw6bxYzz+5gs1h65y26x
	9PpFJosJ09eyWLTuPcJucfJPL6PF6W5Wi4srvjBZrJ/xmsVizvR3TA4iHmvmrWH0uNzXy+Sx
	c9Zddo+Vy7+weWxa1cnmcefaHjaPeScDPfq2rGL0+LxJLoAzissmJTUnsyy1SN8ugStj1uUr
	TAWXBCpefvjJ0sB4mreLkZNDQsBEYtnJP6wQtpjEhXvr2boYuTiEBJYySrzeeRzK6WOS2PH+
	KztIFZuAscTm5UvAEiICvxkles7dZQdxmAXmsUg0H5kPNktYwE/i6JPVYB0sAqoSv26tB4vz
	CrhJ/FgxAyjOAbRPQWLOJBuQMKeAu0TTD5ChnEDb3CSWrm9nmcDIu4CRYRWjaGppckFxUnqu
	kV5xYm5xaV66XnJ+7iZGSPB/3cG49JjVIUYBDkYlHt4XHGLBQqyJZcWVuYcYJTiYlUR4U14A
	hXhTEiurUovy44tKc1KLDzEycXBKNTDefvL9TOiaHXLS507MXCFlWzRbf3LHt0c7VkxjN948
	dQEPt9In09Xme8pX8z74fqGD7d5nCe0ta564+TEZtf7+arrZZcnjSY4uD9X1zYvbRVr4dRMn
	de6662rssUXt2Ns3tZuEFQp7BL9KXa75ULLr4P6zMf+jD+zTMLSYtEKj3vMmu+cXwVWBSizF
	GYmGWsxFxYkAE/NOKFwCAAA=
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
Acked-by: Tomasz Figa <t.figa@samsung.com>
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

