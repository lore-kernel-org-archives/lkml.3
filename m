Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaFQA1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:27:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25933 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbaFQA1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:27:21 -0400
X-AuditID: cbfee68f-b7fef6d000003970-41-539f8b6524b6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, sameo@linux.intel.com
Cc: sbkim73@samsung.com, k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, t.figa@samsung.com,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 3/3] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Tue, 17 Jun 2014 09:27:10 +0900
Message-id: <1402964830-24890-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
References: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkRDete36wwYJXLBZTHz5hs7j+5Tmr
	xfwj51gt+t8sZLU492olo8XrF4YWZ5vesFvc/3qU0eLyrjlsFkuvX2SyuN24gs1iwvS1LBZv
	70xnsWjde4Td4uSfXkaL092sFhdXfGGyWD/jNYuDkMeaeWsYPS739TJ5rFz+hc1j8wotj02r
	Otk87lzbw+Yx72SgR9+WVYwenzfJBXBGcdmkpOZklqUW6dslcGVM2/2UraCbr+Lfij6mBsa1
	3F2MnBwSAiYSvfs/skDYYhIX7q1nA7GFBJYySkxdGwlTs2DJLaAaLqD4IkaJrzMWMEE4TUwS
	c9pOsIJUsQloSex/cQOsW0TAWeL7p4lsIEXMAm3MEiuXTmUHSQgLeEkc/tIEVsQioCqxqfkm
	WJxXwFVi7Z+rbBDr5CQ+7HkEFucUcJM42nqMFeIkV4mlzWvZQYZKCDRySPRv/Ac1SEDi2+RD
	QPdxACVkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBMbd
	6X/P+ncw3j1gfYgxGWjcRGYp0eR8YNzmlcQbGpsZWZiamBobmVuakSasJM57/2FSkJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGlS6d+RJmB/vW3p1cyTk9w8364ipmGfVpbMrbtXh/JdRt
	u/KrX3TDTqsTbuyzFp6fsHnPVS9xNt/SGztWTr1hL6ax0jqybrnvbSEr2f/Tr3Oumu5iszvv
	SaSbF09By4eqpVHiy+Y/+KD8PXfj8W8XOPRF+t32tr8++m9iuEmD3vtJip/c/hS1KLEUZyQa
	ajEXFScCAGOp/YTRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd3U7vnBBme2WlpMffiEzeL6l+es
	FvOPnGO16H+zkNXi3KuVjBavXxhanG16w25x/+tRRovLu+awWSy9fpHJ4nbjCjaLCdPXsli8
	vTOdxaJ17xF2i5N/ehktTnezWlxc8YXJYv2M1ywOQh5r5q1h9Ljc18vksXL5FzaPzSu0PDat
	6mTzuHNtD5vHvJOBHn1bVjF6fN4kF8AZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCo
	a2hpYa6kkJeYm2qr5OIToOuWmQP0jpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4j
	AzSQsIYxY9rup2wF3XwV/1b0MTUwruXuYuTkkBAwkViw5BYLhC0mceHeerYuRi4OIYFFjBJf
	ZyxggnCamCTmtJ1gBaliE9CS2P/iBhuILSLgLPH900SwDmaBNmaJlUunsoMkhAW8JA5/aQIr
	YhFQldjUfBMszivgKrH2z1U2iHVyEh/2PAKLcwq4SRxtPQa2QAioZmnzWvYJjLwLGBlWMYqm
	FiQXFCel5xrpFSfmFpfmpesl5+duYgTH9TPpHYyrGiwOMQpwMCrx8D6QnR8sxJpYVlyZe4hR
	goNZSYSXyxwoxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKiyfnAlJNXEm9obGJmZGlkbmhhZGxO
	mrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwLdnna+Mzbtf77d76t87aZOxY52K8sUYn+
	phXVkLBTRGj6VM2d1XphM3nuLZjb+C6QmaWg37bPX7yfhVMh/s3D0N63Ef3ym/dsqjQvvWZ2
	xu17PdPLzEu2fAt1rtY/k+E2um/buGfbLnvWDqlLWTkuqwV+mrYk8lgJdB0yv2LLUqN94NAx
	SSWW4oxEQy3mouJEAJXY5kAvAwAA
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

