Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaE3AZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 20:25:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44272 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaE3AZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 20:25:18 -0400
X-AuditID: cbfee68f-b7fef6d000003970-c9-5387cfeaf712
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, k.kozlowski@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCHv2 3/3] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Fri, 30 May 2014 09:25:10 +0900
Message-id: <1401409510-28238-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
References: <1401409510-28238-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkSPfV+fZgg4YJKhZTHz5hs9h0/Tqr
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLTrPPmG2eP3C0OJs0xt2i/tfjzJafLvSwWSxsG0Ji8Xl
	XXPYLJZev8hkcbtxBZvFhOlrWSze3pnOYtG69wi7xck/vYwWp7tZLS6u+MJksX7GaxaLOdPf
	MTmIe6yZt4bR43JfL5PHzll32T1WLv/C5rF5hZbHplWdbB53ru1h85h3MtCjb8sqRo/Pm+QC
	uKK4bFJSczLLUov07RK4Mub//M9ccFioYuakT4wNjIv4uxg5OSQETCSuvdjHAmGLSVy4t56t
	i5GLQ0hgKaNEX9dzVpiiNa0rGSESixglzm2cwQrhNDFJbNx4nRmkik1AS2L/ixtg7SICvYwS
	/TP7mUASzALnWST+fFADsYUFvCTWH7wB1sAioCqxe/90NhCbV8BVouP9X6h1chIf9jxiB7E5
	Bdwk9nffBrtPCKjm/NGdLCALJAS2cEj0XF7OAjFIQOLb5ENANgdQQlZi0wFmiDmSEgdX3GCZ
	wCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZg1J7+96x/B+PdA9aHGJOBxk1klhJN
	zgdGfV5JvKGxmZGFqYmpsZG5pRlpwkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YFwb2pJicnPeGtvWDJ3gdVc2T2Ho2z7D9LXTyvjWzjTlS8d2PlpRFFNoG/bmaXPmqkUWq9sX
	hdc872psV218wnfCgO3QubklnQIycbtnljJ/nLXmvfePwpr76R03VY62XNk5ybTJstbfafpJ
	neDNNQX7dGO6J0z8Zv/eUPpMqbbDKtnfRRw3TyuxFGckGmoxFxUnAgBzsSyx8AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jAd1X59uDDW40SllMffiEzWLT9eus
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktOg8+4TZ4vULQ4uzTW/YLe5/Pcpo8e1KB5PFwrYlLBaX
	d81hs1h6/SKTxe3GFWwWE6avZbF4e2c6i0Xr3iPsFif/9DJanO5mtbi44guTxfoZr1ks5kx/
	x+Qg7rFm3hpGj8t9vUweO2fdZfdYufwLm8fmFVoem1Z1snncubaHzWPeyUCPvi2rGD0+b5IL
	4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAXpW
	SaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gx/+d/5oLDQhUzJ31ibGBc
	xN/FyMkhIWAisaZ1JSOELSZx4d56ti5GLg4hgUWMEuc2zmCFcJqYJDZuvM4MUsUmoCWx/8UN
	sCoRgV5Gif6Z/UwgCWaB8ywSfz6ogdjCAl4S6w/eAGtgEVCV2L1/OhuIzSvgKtHx/i8rxDo5
	iQ97HrGD2JwCbhL7u2+zgNhCQDXnj+5kmcDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcEp4Jr2DcVWDxSFGAQ5GJR7eCentwUKsiWXFlbmHGCU4mJVEeB0PA4V4UxIrq1KL8uOL
	SnNSiw8xJgNdNZFZSjQ5H5iu8kriDY1NzIwsjcwNLYyMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQ
	WgSzhYmDU6qBsW/yl5gEvRnnbtWdOvxnca1UnKnk1pNtpw1/Rf8vOnn+6YkjIpWz28L7wyuV
	HsbdDni8UkwkRXzLq06/w2++6CX+qp122PLdjW8VzfP/rfhxIVmC7SP/34v/jDaVhenl7pHS
	P6n2JWfWx7rTwgfkS285nwop+uK/33jrpxod9tKmophJynU8qkosxRmJhlrMRcWJAIVWQ6xN	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add documentation for S2MPU02 PMIC device. S2MPU02 has a little
difference from S2MPS11/S2MPS14 PMIC and has LDO[1-28]/Buck[1-7].

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index d81ba30..f7c9180 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -1,5 +1,5 @@
 
-* Samsung S2MPS11 and S2MPS14 Voltage and Current Regulator
+* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
 
 The Samsung S2MPS11 is a multi-function device which includes voltage and
 current regulators, RTC, charger controller and other sub-blocks. It is
@@ -7,7 +7,8 @@ interfaced to the host controller using an I2C interface. Each sub-block is
 addressed by the host system using different I2C slave addresses.
 
 Required properties:
-- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic".
+- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
+              or "samsung,s2mpu02-pmic".
 - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
 
 Optional properties:
@@ -81,11 +82,13 @@ as per the datasheet of s2mps11.
 		  - valid values for n are:
 			- S2MPS11: 1 to 38
 			- S2MPS14: 1 to 25
+			- S2MPU02: 1 to 28
 		  - Example: LDO1, LD02, LDO28
 	- BUCKn
 		  - valid values for n are:
 			- S2MPS11: 1 to 10
 			- S2MPS14: 1 to 5
+			- S2MPU02: 1 to 7
 		  - Example: BUCK1, BUCK2, BUCK9
 
 Example:
-- 
1.8.0

