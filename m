Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaFYHPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:15:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48852 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaFYHOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:14:54 -0400
X-AuditID: cbfee68f-b7fef6d000003970-b3-53aa76eacf71
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, sbkim73@samsung.com, sameo@linux.intel.com,
        broonie@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 3/4] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Date: Wed, 25 Jun 2014 16:14:46 +0900
Message-id: <1403680487-12141-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
References: <1403680487-12141-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkRPdV2apggwlrVCymPnzCZnH9y3NW
	i7NNb9gt7n89ymhxedccNovbjSvYLE53s1pcXPGFyYHDY9OqTjaPO9f2sHnMOxno0bdlFaPH
	501yAaxRXDYpqTmZZalF+nYJXBnTdj9lK+jmq/i3oo+pgXEtdxcjJ4eEgInEg5vHGSFsMYkL
	99azdTFycQgJLGWUeHfsNhNM0dbGa0wQiemMEh1XbrNAOE1MElsv/mAFqWIT0JLY/+IGG4gt
	IhAlMXfhdzCbWaBWYt+1JrAaYQEvifcrG8DWsQioSjTMvwy2gVfAVeL02i9Q2+QkPux5xA5i
	cwq4SfSsPwk2Rwio5vqRc1CnzmOX2PUtDWKOgMS3yYeADuIAistKbDrADFEiKXFwxQ2WCYzC
	CxgZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmIEBvvpf8/6dzDePWB9iDEZaNxEZinR5Hxg
	tOSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsb9
	JoK6vPcehCxMWDpPWP3+vtDUR1kzWfyrD96tvcXPW9/orZ0j8bV01tqs3FKtu8+/ZvWbSfGx
	7nC8f7hOW0f8vtvxvrmBZwy2qcaZqmxz9dw+47mH36GFXL0PU25wx4ut2TtbnnfVbpEVsu8m
	3rqSOLk34Om0fKuW8hezTs25z+rPcP485zUlluKMREMt5qLiRABY88n1jAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jQd1XZauCDf5ckbGY+vAJm8X1L89Z
	Lc42vWG3uP/1KKPF5V1z2CxuN65gszjdzWpxccUXJgcOj02rOtk87lzbw+Yx72SgR9+WVYwe
	nzfJBbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMmLb7KVtBN1/FvxV9
	TA2Ma7m7GDk5JARMJLY2XmOCsMUkLtxbz9bFyMUhJDCdUaLjym0WCKeJSWLrxR+sIFVsAloS
	+1/cYAOxRQSiJOYu/A5mMwvUSuy71gRWIyzgJfF+ZQMjiM0ioCrRMP8y2AZeAVeJ02u/QG2T
	k/iw5xE7iM0p4CbRs/4k2BwhoJrrR84xTmDkXcDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOJqeSe1gXNlgcYhRgINRiYf3wuyVwUKsiWXFlbmHGCU4mJVEeC95rQoW4k1JrKxKLcqP
	LyrNSS0+xGgKdNVEZinR5HxgpOeVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgt
	gulj4uCUamC02ltvNl1U5uDd4NuyS/abbVgtuSviv7XEpWw9a9f5LaU1nt8OF648P9+KM1iL
	s3NVGr9bkm+ohu+7lK5jbuGPFolk/H5vEVbzgO313Nrz81xk5lyYnW9jeZtj562C1xXfFFq2
	X7Y9YeW76YbMldcnmEIm6EbOn/Rr6tW73MwPhZfeON48xee4EktxRqKhFnNRcSIAbVi4L7wC	AAA=
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

