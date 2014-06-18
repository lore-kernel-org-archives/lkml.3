Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbaFRXwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:52:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18757 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbaFRXwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:52:34 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-30-53a2263dccef
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 3/4] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Thu, 19 Jun 2014 08:52:24 +0900
Message-id: <1403135545-7451-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
References: <1403135545-7451-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWyRsSkQNdWbVGwwdNWc4upD5+wWVz/8pzV
	4mzTG3aL+1+PMlpc3jWHzeJ24wo2i9PdrBYXV3xhcuDw2LSqk83jzrU9bB7zTgZ69G1Zxejx
	eZNcAGsUl01Kak5mWWqRvl0CV8a03U/ZCrr5Kv6t6GNqYFzL3cXIySEhYCJx6+FTJghbTOLC
	vfVsXYxcHEICSxkltkx9zwZT9GzxNHaIxCJGic/ft0E5TUwSOxetBmtnE9CS2P/iBliHiECU
	xNyF38FsZoFaiX3XmlhBbGEBL4mbP6YxgtgsAqoSzz+8ArN5BVwkFjzdAnWGnMSHPY/YQWxO
	AVeJV38es4DYQkA1vx41sIIslhBYxC7xakEHE8QgAYlvkw8BFXEAJWQlNh1ghpgjKXFwxQ2W
	CYzCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIEhvvpf88m7mC8f8D6EGMy0LiJzFKi
	yfnAeMkriTc0NjOyMDUxNTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BkYu3z3fxT5/Ps64/nDKBEk+y+SVz8+JdUVfLr3LP1HKV9ditWbTqQ2vDJfIHXs/pZVb1WfW
	H7nOaqtnc7cl7Zcxa+v5qcPFWrtvdzjLtw/xTBO+Hp3v869zh++7yAe/WKb0OojHyFp23p2s
	v/8nx8GPWZeyf+xgqbVaxna9K/2l09qDc2ZLirUqsRRnJBpqMRcVJwIA/NdRNI0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAV1btUXBBit2G1hMffiEzeL6l+es
	Fmeb3rBb3P96lNHi8q45bBa3G1ewWZzuZrW4uOILkwOHx6ZVnWwed67tYfOYdzLQo2/LKkaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmTNv9lK2gm6/i34o+
	pgbGtdxdjJwcEgImEs8WT2OHsMUkLtxbz9bFyMUhJLCIUeLz923sEE4Tk8TORauZQKrYBLQk
	9r+4wQZiiwhEScxd+B3MZhaoldh3rYkVxBYW8JK4+WMaI4jNIqAq8fzDKzCbV8BFYsHTLUwQ
	2+QkPux5BLaZU8BV4tWfxywgthBQza9HDawTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dL
	zs/dxAiOpmdSOxhXNlgcYhTgYFTi4fW4uDBYiDWxrLgy9xCjBAezkgiv/C+gEG9KYmVValF+
	fFFpTmrxIcZkoKsmMkuJJucDIz2vJN7Q2MTMyNLI3NDCyNicNGElcd4DrdaBQgLpiSWp2amp
	BalFMFuYODilGhjbJ/OFv0pcMHXX9ISD64yui997E7Ah/fFhGe32e4sFdp3bdHme16y9/Wff
	Bb1ykNyz2HfymXWV8gJLr27Qj2x3PbdvsYlOlIPCcrEL7Gsv7dxqXeUWFqrXP+f9mSccOxum
	svq7zHP+OyGfXfuuW3pvxOPKuXKPnBeLr21weGyjdLP9578PB2xSlFiKMxINtZiLihMBX3Kz
	b+oCAAA=
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

