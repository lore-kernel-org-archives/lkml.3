Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaE1LKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 07:10:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56591 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaE1LKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 07:10:24 -0400
X-AuditID: cbfee68f-b7fef6d000003970-dc-5385c41a071c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 4/4] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Wed, 28 May 2014 20:10:11 +0900
Message-id: <1401275411-21947-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401275411-21947-1-git-send-email-cw00.choi@samsung.com>
References: <1401275411-21947-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkSFfqSGuwwdI/1hZTHz5hs9h0/Tqr
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLTrPPmG2eP3C0OJs0xt2i/tfjzJafLvSwWSxsG0Ji8Xl
	XXPYLJZev8hkcbtxBZvFhOlrWSze3pnOYtG69wi7xck/vYwWp7tZLS6u+MJksX7GaxaLOdPf
	MTmIe6yZt4bR43JfL5PHzll32T1WLv/C5rF5hZbHplWdbB53ru1h85h3MtCjb8sqRo/Pm+QC
	uKK4bFJSczLLUov07RK4MpY/O8VY0C5UsfbANeYGxtd8XYycHBICJhIdGw+yQdhiEhfurQey
	uTiEBJYySsw4c4qli5EDrGjK9EKI+HRGiYtXl0IVNTFJfH3Uww7SzSagJbH/xQ2whIhAL6NE
	/8x+JhCHWeAli8TJnRNZQKqEBTwkJpyexwoylkVAVWLLdSOQMK+Aq8SWjW+hzpCT+LDnEdhQ
	TgE3icXdq8BahYBqzm/sZQaZKSGwg0NiTt8nsASLgIDEt8mHoE6Vldh0gBlijqTEwRU3WCYw
	Ci9gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERizp/8969/BePeA9SHGZKBxE5mlRJPz
	gTGfVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY
	c4P8l+0wP33tSl6S84TG19kTu3aZMztsSqt+tEFMfNGGk5b14Seu1Gu6tt659nVjTsTTqbWc
	GycXiqZdyGI0850c5lD/djZbaHUQi8GjDlvDW9s3qi/XDvlzJm3OFalNHTsYbhiq/eY5s+gX
	Y9bGA58F4jok5hslHf4v97Xt1epvqUveb36ioMRSnJFoqMVcVJwIAEgIm/nvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQV2pI63BBgvOGVpMffiEzWLT9eus
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktOg8+4TZ4vULQ4uzTW/YLe5/Pcpo8e1KB5PFwrYlLBaX
	d81hs1h6/SKTxe3GFWwWE6avZbF4e2c6i0Xr3iPsFif/9DJanO5mtbi44guTxfoZr1ks5kx/
	x+Qg7rFm3hpGj8t9vUweO2fdZfdYufwLm8fmFVoem1Z1snncubaHzWPeyUCPvi2rGD0+b5IL
	4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAXpW
	SaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix/NkpxoJ2oYq1B64xNzC+
	5uti5OCQEDCRmDK9sIuRE8gUk7hwbz1bFyMXh5DAdEaJi1eXQjlNTBJfH/Wwg1SxCWhJ7H9x
	AywhItDLKNE/s58JxGEWeMkicXLnRBaQKmEBD4kJp+exgqxgEVCV2HLdCCTMK+AqsWXjWzaI
	dXISH/Y8AhvKKeAmsbh7FVirEFDN+Y29zBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECE4Iz6R2MK5ssDjEKMDBqMTDe2BxS7AQa2JZcWXuIUYJDmYlEV7zva3BQrwpiZVVqUX5
	8UWlOanFhxiTgY6ayCwlmpwPTFZ5JfGGxiZmRpZG5oYWRsbmpAkrifMeaLUOFBJITyxJzU5N
	LUgtgtnCxMEp1cC4ofVKaHlWBV/LOd2cU6YnWXJfrmLyU4/dHrz8yA8G4TU233ZJHFfNXhWy
	7m3zCYN9U94KrIh8nzbN4ancS8XuaZVLOFOc+79JRN8J9rTVl591xSppXea/Gf5Cm7QZdYNe
	i2xXWzNP0fOdzeorR+dMZ1iYq/rW6Nand2+2rXg8bbLQyyh/1ZAmJZbijERDLeai4kQAkLz4
	akwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add documentation for S2MPU02 PMIC device. S2MPU02 has a little
difference from S2MPS11/S2MPS14 PMIC and has LDO[1-28]/Buck[1-7].

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
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

