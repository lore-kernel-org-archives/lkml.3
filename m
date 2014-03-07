Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaCGKLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:11:22 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25815 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaCGKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:11:08 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-58-53199b39e8cb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 3/3] Documentation: mfd: s2mps11: Document support for
 S2MPS14
Date: Fri, 07 Mar 2014 11:10:52 +0100
Message-id: <1394187052-591-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
References: <1394187052-591-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t/xa7qWsyWDDVo281lsnLGe1WLqwyds
	FvOPnGO16H+zkNXi3KuVjBavXxhanG16w27x7UoHk8XlXXPYLGac38dksfbIXXaLpdcvMllM
	mL6WxaJ17xF2i4srvjBZrJ/xmsVizvR3TA6CHmvmrWH0uNzXy+Sxc9Zddo+Vy7+weWxa1cnm
	0bdlFaPH501yAexRXDYpqTmZZalF+nYJXBmzLl9hKrgkUPHyw0+WBsbTvF2MnBwSAiYScxdt
	YISwxSQu3FvP1sXIxSEksJRRYtvKWcwgCSGBPiaJVcejQGw2AWOJzcuXgBWJCGxklDi4/zAr
	iMMs8IVZYvbfBqAODg5hgWCJr/PrQRpYBFQl/hyZwgJi8wq4ShzZ3ssKUiIhoCAxZ5INSJhT
	wE3i0bG77BC7XCU2LHjFNIGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkFD+soNx
	8TGrQ4wCHIxKPLwGCySChVgTy4orcw8xSnAwK4nwdjVLBgvxpiRWVqUW5ccXleakFh9iZOLg
	lGpg7Lyy8Jb219d7jT/mCPiGnTd+ZvHkXA3zZ8bVzMd5F3vJTXRS+SAQP2XbsUzXWz2HZi/W
	+btmySqZ5UZBUYf7LoopxgfFn3PtcVJg+e5w7UeL72SXn5kTv08QsEh/dszUOFzVpkfOmlcy
	qWvFg5tfd/lXm7NPeGo/aeFyxtXr7n2Q1mwM6tdpUWIpzkg01GIuKk4EADuBUI9DAgAA
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

