Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaFIGQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 02:16:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:60893 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaFIGP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 02:15:56 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-e4-539551199639
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
Subject: [PATCHv3 3/3] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Mon, 09 Jun 2014 15:15:48 +0900
Message-id: <1402294548-10380-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402294548-10380-1-git-send-email-cw00.choi@samsung.com>
References: <1402294548-10380-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsWyRsSkSFcycGqwQU+3usXUh0/YLDZdv85q
	cf3Lc1aL+UfOsVr0v1nIanHu1UpGi86zT5gtXr8wtDjb9Ibd4v7Xo4wW3650MFksbFvCYnF5
	1xw2i6XXLzJZ3G5cwWYxYfpaFou3d6azWLTuPcJucfJPL6PF6W5Wi4srvjBZrJ/xmsVizvR3
	TA7iHmvmrWH0uNzXy+Sxc9Zddo+Vy7+weWxeoeWxaVUnm8eda3vYPOadDPTo27KK0ePzJrkA
	rigum5TUnMyy1CJ9uwSujPk//zMXHBaqmDnpE2MD4yL+LkZODgkBE4m/ix+wQdhiEhfurQey
	uTiEBJYySsydfJkVpqj9zkuoxHRGiflnWtkhnCYmiT/zF7OAVLEJaEnsf3EDrEpEoJdR4k3/
	NCaQBLPAeRaJPx/UQGxhAS+Jb0c/g8VZBFQlHt9dBrabV8BVYsqVj1Dr5CQ+7HnEDmJzCrhJ
	POqYAVYjBFTz4fhnRpAFEgJbOCT2XtrHBjFIQOLb5ENAV3AAJWQlNh1ghpgjKXFwxQ2WCYzC
	CxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIERu3pf88m7mC8f8D6EGMy0LiJzFKiyfnA
	qM8riTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkYL
	ts0TY97V5X05dOX9w786b7RuRT+oM9gWKj03p/VI78GawwGrnigeXdD35oBP8UqLzM15D/9U
	TZU0m+nuYGU3h+XijZe33MV/vK69OK9Tl0lj25wo55mbVxvXbnwV846t6ciTEI2+868EvbRf
	Ot1/sUF4/ko2rUxtjd5vm9zrLE7mnxQqe39JiaU4I9FQi7moOBEAtuMumPACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQV3JwKnBBidvyFhMffiEzWLT9eus
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktOg8+4TZ4vULQ4uzTW/YLe5/Pcpo8e1KB5PFwrYlLBaX
	d81hs1h6/SKTxe3GFWwWE6avZbF4e2c6i0Xr3iPsFif/9DJanO5mtbi44guTxfoZr1ks5kx/
	x+Qg7rFm3hpGj8t9vUweO2fdZfdYufwLm8fmFVoem1Z1snncubaHzWPeyUCPvi2rGD0+b5IL
	4IpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAXpW
	SaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5gx/+d/5oLDQhUzJ31ibGBc
	xN/FyMkhIWAi0X7nJRuELSZx4d56IJuLQ0hgOqPE/DOt7BBOE5PEn/mLWUCq2AS0JPa/uAFW
	JSLQyyjxpn8aE0iCWeA8i8SfD2ogtrCAl8S3o5/B4iwCqhKP7y4DW8Er4Cox5cpHVoh1chIf
	9jxiB7E5BdwkHnXMAKsRAqr5cPwz4wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcx
	glPCM+kdjKsaLA4xCnAwKvHwRvyeEizEmlhWXJl7iFGCg1lJhNfAamqwEG9KYmVValF+fFFp
	TmrxIcZkoKsmMkuJJucD01VeSbyhsYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KL
	YLYwcXBKNTDOthWQFHhXpqKpVOz7UjrvclO/E8u9t50NZj6nTe64LsjffXrPRYvMDe/eHbhy
	r5a177fraiV12981D9eaBYcVXYv/sLnBhPvC2j0u9zKSSm/XXXx7/8Fv6/irW9QPqMlaR20U
	ahWzcU4MP6dpFB81/fStx1+k0l5X8TS+i75QlrPa8LC7cr0SS3FGoqEWc1FxIgCmcKcNTQMA	AA==
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

