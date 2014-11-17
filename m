Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaKQAng (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 19:43:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8213 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbaKQAnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:43:33 -0500
X-AuditID: cbfee691-f79b86d000004a5a-c7-54694496cc3b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org, mturquette@linaro.org,
        a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 5/5] mfd: s2mps11: Add binding documentation for Samsung
 S2MPS13 PMIC
Date: Mon, 17 Nov 2014 09:43:00 +0900
Message-id: <1416184980-532-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSoDvNJTPE4NUzG4slF6+yW0x9+ITN
	4vqX56wW84+cY7X4M6GVzWLS/QksFmeb3rBb3P96lNHi25UOJovLu+awWTydcJHN4nQ3q8XF
	FV+YHHg9ds66y+6xaVUnm8eda3vYPOadDPTo27KK0WP6vJ9MHp83yQWwR3HZpKTmZJalFunb
	JXBlLFw5ia1gm3TFnV+3GBsYD4l2MXJySAiYSOze8J4JwhaTuHBvPVsXIxeHkMBSRon+1c9Z
	YYom/HnICpGYzigxtXUZM4TTxCSxd08bM0gVm4CWxP4XN9hAbBGBaInjT48zghQxC3xmlHh2
	aRN7FyMHh7BAuMSRl9wgNSwCqhIT5nwDq+cVcJZ4evI9I8Q2BYlly2eCbeYUcJHY0LwMbL4Q
	UM2bzzfAzpMQuMYu0b/3CyvEIAGJb5MPsYDMlxCQldh0gBlijqTEwRU3WCYwCi9gZFjFKJpa
	kFxQnJReZKpXnJhbXJqXrpecn7uJERg1p/89m7iD8f4B60OMAhyMSjy8HNYZIUKsiWXFlbmH
	GE2BNkxklhJNzgfGZl5JvKGxmZGFqYmpsZG5pZmSOK+O9M9gIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYwrH2YWb2V583v6WotV90Na6ve+fMDJ8FQ3/lbFzd7rG3KLeMxP1h9g7Hv+X3Pm
	640275aurZ3+eoLi227+DvkXHFd8XxrejX9llK04r+xR//fy5NyHh0QV5y6ScTfYEf27Zn+j
	cI75iZiWHXsOcO4saZwxTdJmUouiSsnEn+27gg10noj8vc6oxFKckWioxVxUnAgAH1XGe5UC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t9jQd1pLpkhBvtmm1gsuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WS0u
	rvjC5MDrsXPWXXaPTas62TzuXNvD5jHvZKBH35ZVjB7T5/1k8vi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bClZPYCrZJV9z5dYuxgfGQaBcjJ4eEgInEhD8P
	WSFsMYkL99azdTFycQgJTGeUmNq6jBnCaWKS2LunjRmkik1AS2L/ixtsILaIQLTE8afHGUGK
	mAU+M0o8u7SJvYuRg0NYIFziyEtukBoWAVWJCXO+gdXzCjhLPD35nhFim4LEsuUzwTZzCrhI
	bGheBjZfCKjmzecbbBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7JZ9I7GFc1
	WBxiFOBgVOLh3WCRESLEmlhWXJl7iFGCg1lJhHeJTmaIEG9KYmVValF+fFFpTmrxIUZToKsm
	MkuJJucD00VeSbyhsYmZkaWRuaGFkbG5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbG5Z/D
	ZbsfnAw44P/iWNP5+8z2i3iKlaadWF6Y6t9wNfiA/Svhfy8tJsuumLTUWoDp2psHH3/lbFmz
	sXvDdaXX6Y9fpZqKZzULH77CaBSh4v3xscCCy4kfp5TN8hNUtOCIbXnAuXt7cKXO3nWitx/b
	bjyTNXVH4OQkvw97hfv/p8YnR9uWsl9XV2Ipzkg01GIuKk4EAB5fptHfAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the binding documentation for Samsung S2MPS13 PMIC
which is similiar with existing S2MPS14 PMIC. S2MPS13 has the different number
of regulators from S2MPS14 and RTC/Clock is the same with the S2MPS14.

Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index 0e4026a..57a0450 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -1,5 +1,5 @@
 
-* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
+* Samsung S2MPS11, S2MPS13, S2MPS14 and S2MPU02 Voltage and Current Regulator
 
 The Samsung S2MPS11 is a multi-function device which includes voltage and
 current regulators, RTC, charger controller and other sub-blocks. It is
@@ -7,8 +7,8 @@ interfaced to the host controller using an I2C interface. Each sub-block is
 addressed by the host system using different I2C slave addresses.
 
 Required properties:
-- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
-              or "samsung,s2mpu02-pmic".
+- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps13-pmic"
+	      or "samsung,s2mps14-pmic" or "samsung,s2mpu02-pmic".
 - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
 
 Optional properties:
@@ -17,8 +17,8 @@ Optional properties:
 - interrupts: Interrupt specifiers for interrupt sources.
 
 Optional nodes:
-- clocks: s2mps11 and s5m8767 provide three(AP/CP/BT) buffered 32.768 KHz
-  outputs, so to register these as clocks with common clock framework
+- clocks: s2mps11, s2mps13 and s5m8767 provide three(AP/CP/BT) buffered 32.768
+  KHz outputs, so to register these as clocks with common clock framework
   instantiate a sub-node named "clocks". It uses the common clock binding
   documented in :
   [Documentation/devicetree/bindings/clock/clock-bindings.txt]
@@ -30,12 +30,12 @@ Optional nodes:
     the clock which they consume.
     Clock               ID           Devices
     ----------------------------------------------------------
-    32KhzAP		0            S2MPS11, S2MPS14, S5M8767
-    32KhzCP		1            S2MPS11, S5M8767
-    32KhzBT		2            S2MPS11, S2MPS14, S5M8767
+    32KhzAP		0            S2MPS11, S2MPS13, S2MPS14, S5M8767
+    32KhzCP		1            S2MPS11, S2MPS13, S5M8767
+    32KhzBT		2            S2MPS11, S2MPS13, S2MPS14, S5M8767
 
-  - compatible: Should be one of: "samsung,s2mps11-clk", "samsung,s2mps14-clk",
-		"samsung,s5m8767-clk"
+  - compatible: Should be one of: "samsung,s2mps11-clk", "samsung,s2mps13-clk",
+		"samsung,s2mps14-clk", "samsung,s5m8767-clk"
 
 - regulators: The regulators of s2mps11 that have to be instantiated should be
 included in a sub-node named 'regulators'. Regulator nodes included in this
@@ -81,12 +81,14 @@ as per the datasheet of s2mps11.
 	- LDOn
 		  - valid values for n are:
 			- S2MPS11: 1 to 38
+			- S2MPS13: 1 to 40
 			- S2MPS14: 1 to 25
 			- S2MPU02: 1 to 28
 		  - Example: LDO1, LDO2, LDO28
 	- BUCKn
 		  - valid values for n are:
 			- S2MPS11: 1 to 10
+			- S2MPS13: 1 to 10
 			- S2MPS14: 1 to 5
 			- S2MPU02: 1 to 7
 		  - Example: BUCK1, BUCK2, BUCK9
-- 
1.8.5.5

