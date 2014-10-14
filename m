Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaJNIDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:03:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53823 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbaJNIDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:03:30 -0400
X-AuditID: cbfee691-f79b86d000004a5a-05-543cd8c1b86d
From: Thomas Abraham <thomas.ab@samsung.com>
To: lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: mfd: s2mps11: add documentation for s2mps15
 PMIC
Date: Tue, 14 Oct 2014 13:44:27 +0530
Message-id: <1413274468-8765-2-git-send-email-thomas.ab@samsung.com>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1413274468-8765-1-git-send-email-thomas.ab@samsung.com>
References: <1413274468-8765-1-git-send-email-thomas.ab@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkRvfQDZsQg837mSwOzH7IajH/yDlW
	i94FV9ks7n89ymhxedccNgdWjzvX9rB5nJ+xkNGjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mk7dPs9S0MJf8ar5CWsD43/uLkYODgkBE4l1Hxy7GDmBTDGJC/fWs3UxcnEICSxllLjfepoN
	ImEi8bLjODtEYjqjxPPW+awQThuTxOxFv9lBqtgEdCRuvPnNCGKLCNhKTLsMYTMLhEpMaVwM
	ViMsECIxd/FbsDiLgKrEuYMvwOK8Ai4SbT8uM0FsU5LY0HsUzOYUcJXYvHI92BVCQDUNz3+z
	QtT8ZpO412UHMUdA4tvkQywQ38hKbDrADFEiKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ6hUn
	5haX5qXrJefnbmIEhvHpf88m7mC8f8D6EKMAB6MSD29hpE2IEGtiWXFl7iFGU6ANE5mlRJPz
	gdGSVxJvaGxmZGFqYmpsZG5ppiTOqyP9M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDozsj
	X1DgthSOWU7Zn9dHipwrMbnZH7/63pz4M3tsigL/e4b/tZXccWnx/U0nb30ulBM38ebz1dYM
	i4ibu2m7NJfv23ttMtsbOCfmLZzK8sjyRf7u3fFral0vaSVdfONlks/z7M0TBq4FfWH5xzuO
	aEdFsz3T+bPLKkDP6BeDD+c03Xch+8+wKbEUZyQaajEXFScCAGk7V+FeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jQd2DN2xCDBqvmFscmP2Q1WL+kXOs
	Fr0LrrJZ3P96lNHi8q45bA6sHneu7WHzOD9jIaNH35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1WUihLzCkFCgUkFhcr6dth
	mhAa4qZrAdMYoesbEgTXY2SABhLWMGacun2epaCFv+JV8xPWBsb/3F2MnBwSAiYSLzuOs0PY
	YhIX7q1n62Lk4hASmM4o8bx1PiuE08YkMXvRb7AqNgEdiRtvfjOC2CICthLTLkPYzAKhElMa
	F4PVCAuESMxd/BYsziKgKnHu4AuwOK+Ai0Tbj8tMENuUJDb0HgWzOQVcJTavBNnMCbTMRaLh
	+W/WCYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER8oz6R2MqxosDjEKcDAq8fAW
	RNqECLEmlhVX5h5ilOBgVhLhNV4IFOJNSaysSi3Kjy8qzUktPsRoCnTVRGYp0eR8YBTnlcQb
	GpuYmxqbWppYmJhZKonzHmy1DhQSSE8sSc1OTS1ILYLpY+LglGpgtL927oWm/FmtorO9fp9m
	lUxQNf8zp/MWixzfj0QP1c9y1+prg1KvprnOENpW6FP2jFG+ILvI14jH+2JA8QaHlTfPfW6y
	2Jg/+cDaufu05mrcrjurkTWnQSHI8qDAzbtCm0/PSj5b9Tv/ddimiKM3Fp69usZM0HHXSo26
	/V0MKxr69aLOf1KdrsRSnJFoqMVcVJwIACoYcbCqAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dt-binding documentation for s2mps15 PMIC device. The s2mps15 device
is similar to s2mps11/14 PMIC device and has 27 LDO and 10 buck regulators.

Cc: devicetree@vger.kernel.org
Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index 0e4026a..41ee3f5 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -1,5 +1,5 @@
 
-* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
+* Samsung S2MPS11/14/15 and S2MPU02 Voltage and Current Regulator
 
 The Samsung S2MPS11 is a multi-function device which includes voltage and
 current regulators, RTC, charger controller and other sub-blocks. It is
@@ -7,8 +7,11 @@ interfaced to the host controller using an I2C interface. Each sub-block is
 addressed by the host system using different I2C slave addresses.
 
 Required properties:
-- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
-              or "samsung,s2mpu02-pmic".
+- compatible: Should be one of the following
+	- "samsung,s2mps11-pmic"
+	- "samsung,s2mps14-pmic"
+	- "samsung,s2mps15-pmic"
+	- "samsung,s2mpu02-pmic"
 - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
 
 Optional properties:
@@ -82,12 +85,14 @@ as per the datasheet of s2mps11.
 		  - valid values for n are:
 			- S2MPS11: 1 to 38
 			- S2MPS14: 1 to 25
+			- S2MPS15: 1 to 27
 			- S2MPU02: 1 to 28
 		  - Example: LDO1, LDO2, LDO28
 	- BUCKn
 		  - valid values for n are:
 			- S2MPS11: 1 to 10
 			- S2MPS14: 1 to 5
+			- S2MPS15: 1 to 10
 			- S2MPU02: 1 to 7
 		  - Example: BUCK1, BUCK2, BUCK9
 
-- 
1.6.6.rc2

