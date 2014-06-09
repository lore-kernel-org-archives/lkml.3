Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaFIKVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:21:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61950 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaFIKVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:21:46 -0400
X-AuditID: cbfee690-b7fb56d000003439-b2-53958ab7b70a
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, sbkim73@samsung.com,
        sameo@linux.intel.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
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
Subject: [PATCHv4 3/3] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Mon, 09 Jun 2014 19:21:39 +0900
Message-id: <1402309299-7805-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402309299-7805-1-git-send-email-cw00.choi@samsung.com>
References: <1402309299-7805-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsWyRsSkUHd719Rgg/b/UhZTHz5hs9h0/Tqr
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLTrPPmG2eP3C0OJs0xt2i/tfjzJafLvSwWSxsG0Ji8Xl
	XXPYLJZev8hkcbtxBZvFhOlrWSze3pnOYtG69wi7xck/vYwWp7tZLS6u+MJksX7GaxaLOdPf
	MTmIe6yZt4bR43JfL5PHzll32T1WLv/C5rF5hZbHplWdbB53ru1h85h3MtCjb8sqRo/Pm+QC
	uKK4bFJSczLLUov07RK4Mub//M9ccFioYuakT4wNjIv4uxg5OSQETCR2rp3BBGGLSVy4t56t
	i5GLQ0hgKaPEmYZPrF2MHGBF66bHQcQXMUq0Pe5ihXCamCRavqwD62YT0JLY/+IGWLeIQC+j
	xJv+aWAJZoHzLBJ/PqiB2MICXhJ3ft5hA5nKIqAqcaJPFyTMK+Ai0f73FDvEFXISH/Y8ArM5
	BVwlPp0+xApiCwHVTHnWBjZfQmAHh8S3tl9g81kEBCS+TT7EAnGprMSmA8wQcyQlDq64wTKB
	UXgBI8MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjMCIPf3v2YQdjPcOWB9iTAYaN5FZSjQ5
	HxjxeSXxhsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WCroyyNty2b+aZpGzMb/TvvfKj5dfTFz88sgPplnTdr1m148Crr/yvvKT9PyPzPa4oPSJOOK
	T333yn3kx3CQqdSd7+8uDW3e1C9uV/a4bc6pWvi8+am8amK9+5vcpNZ8E++rCp9mpP2YaD33
	3nRHPwv2qyeUrKUmcLjtmdXnbNahnfut9q6xEktxRqKhFnNRcSIAaiSdCe4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAd3tXVODDRYuELSY+vAJm8Wm69dZ
	La5/ec5qMf/IOVaL/jcLWS3OvVrJaNF59gmzxesXhhZnm96wW9z/epTR4tuVDiaLhW1LWCwu
	75rDZrH0+kUmi9uNK9gsJkxfy2Lx9s50FovWvUfYLU7+6WW0ON3NanFxxRcmi/UzXrNYzJn+
	jslB3GPNvDWMHpf7epk8ds66y+6xcvkXNo/NK7Q8Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQX
	wBXVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/Ss
	kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFj/s//zAWHhSpmTvrE2MC4
	iL+LkYNDQsBEYt30uC5GTiBTTOLCvfVsXYxcHEICixgl2h53sUI4TUwSLV/WMYFUsQloSex/
	cQOsSkSgl1HiTf80sASzwHkWiT8f1EBsYQEviTs/77CBbGARUJU40acLEuYVcJFo/3uKHWKb
	nMSHPY/AbE4BV4lPpw+xgthCQDVTnrWxTWDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOB08k9rBuLLB4hCjAAejEg9vxO8pwUKsiWXFlbmHGCU4mJVEeH1ypgYL8aYkVlalFuXH
	F5XmpBYfYkwGOmois5Rocj4wVeWVxBsam5gZWRqZG1oYGZuTJqwkznug1TpQSCA9sSQ1OzW1
	ILUIZgsTB6dUAyPj7mA+1pTNwcs1ix7ulH15L9b4dPDp5p59/AJP2Ve/9l2Sb7JLOi+gn9+g
	xn45k6+5ruecF3sWzs9iPrpMZ9kBWcc80eQVmae7nhzl93yWa7TtvP5TF+P0C7bVR1ZnMO64
	tVqlRuXHVWbOWq6lt8Ur9j6ZdiVlCZOju47ur5UbBZ13f5B6b6zEUpyRaKjFXFScCADXAoJI
	SwMAAA==
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

