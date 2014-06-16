Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbaFPEnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:43:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48519 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaFPEmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:42:55 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-f8-539e75c33e7d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com
Cc: k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCHv5 3/3] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Mon, 16 Jun 2014 13:42:37 +0900
Message-id: <1402893757-18957-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
References: <1402893757-18957-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWyRsSkRPdw6bxgg90dbBabrl9ntbj+5Tmr
	xfwj51gt+t8sZLU492olo8XrF4YWZ5vesFvc/3qU0WJh2xIWi8u75rBZLL1+kcniduMKNosJ
	09eyWLy9M53FonXvEXaLk396GS1Od7NaXFzxhcli/YzXLBZzpr9jchDxWDNvDaPH5b5eJo+V
	y7+weWxeoeWxaVUnm8eda3vYPOadDPTo27KK0ePzJrkAzigum5TUnMyy1CJ9uwSujPk//zMX
	HBaqmDnpE2MD4yL+LkZODgkBE4mJn26yQdhiEhfurQeyuTiEBJYySiy79pAZpuhy71RWiMQi
	RokL59azgySEBJqYJGZ1VoLYbAJaEvtf3ACbJCLgIrGk+x3YJGaByywSix/2sYAkhAW8JGZv
	PwBmswioSkzadBlsA6+Aq8SOe/9ZILbJSXzY8whsAaeAm8Tfvm1MEMtcJW5d7mIBGSohMJVD
	Ys+dH4wQgwQkvk0+BJTgAErISmw6AHW1pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtc
	mpeul5yfu4kRGIun/z2buIPx/gHrQ4zJQOMmMkuJJucDYzmvJN7Q2MzIwtTE1NjI3NKMNGEl
	cd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhh3P3FbGRN/+KxIWpJ9eeyTJZ8VdifX
	bWTdJZV8/Xf45x3fv2dut5yi+DOtaeayjiuTj55ev1ZjB5fPwmsxK0St/y0U1wr8deGbsaqU
	5/lv5+ftDUyQNLJWqt951k2A6YRq99K2LLv7iS2GBvM711XnTo2RuvHqTtuEo7rx4S1n9DqM
	2wxNw+WUWIozEg21mIuKEwGhIok+2wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jAd1DpfOCDXpfWVlsun6d1eL6l+es
	FvOPnGO16H+zkNXi3KuVjBavXxhanG16w25x/+tRRouFbUtYLC7vmsNmsfT6RSaL240r2Cwm
	TF/LYvH2znQWi9a9R9gtTv7pZbQ43c1qcXHFFyaL9TNes1jMmf6OyUHEY828NYwel/t6mTxW
	Lv/C5rF5hZbHplWdbB53ru1h85h3MtCjb8sqRo/Pm+QCOKMaGG0yUhNTUosUUvOS81My89Jt
	lbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgB5TUihLzCkFCgUkFhcr6dthmhAa4qZr
	AdMYoesbEgTXY2SABhLWMGbM//mfueCwUMXMSZ8YGxgX8XcxcnJICJhIXO6dygphi0lcuLee
	rYuRi0NIYBGjxIVz69lBEkICTUwSszorQWw2AS2J/S9usIHYIgIuEku634E1MAtcZpFY/LCP
	BSQhLOAlMXv7ATCbRUBVYtKmy8wgNq+Aq8SOe/9ZILbJSXzY8whsAaeAm8Tfvm1MEMtcJW5d
	7mKZwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwpD+T3sG4qsHiEKMAB6MSD+8E
	x3nBQqyJZcWVuYcYJTiYlUR47X2AQrwpiZVVqUX58UWlOanFhxiTga6ayCwlmpwPTEJ5JfGG
	xiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCofGGXz6Nmz391TDmb
	pnIZXGhdVLn9UqL0yp2yjw4unPlSL46xvvl629yYBXGVz8pUVHRz4gqS7Sac83xy4uFmFSu2
	H58mCRu5Tmx6rKtxVZDjfNrzNeGyV/SLfWyCVB/+PHqc9+Lyv5e9T+q4OL8PM7oyg9VB+fQX
	r+hTXO9OOYWrpBVY661SYinOSDTUYi4qTgQATVMEOzgDAAA=
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

