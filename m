Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbaFIK36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:29:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56212 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaFIK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:29:49 -0400
X-AuditID: cbfee690-b7fb56d000003439-41-53958c9a3d69
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] dt-bindings: regulator: Add regulator suspend state for PM
 state
Date: Mon, 09 Jun 2014 19:29:40 +0900
Message-id: <1402309780-8118-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
References: <1402309780-8118-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkQHdWz9Rgg/MrJSymPnzCZnH9y3NW
	i/lHzrFaHPizg9HibNMbdotvVzqYLC7vmsNmcbtxBZtF694j7A6cHjtn3WX32LSqk83jzrU9
	bB59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVsfXFG9aCu3wVt2f5NTBu5+li5OCQEDCRuHTM
	r4uRE8gUk7hwbz1bFyMXh5DAUkaJrpY+RoiEicTK+bOYIRLTGSUubp/DBOE0MUns2XiWFaSK
	TUBLYv+LG2wgU0UEoiTWdoDVMAvMZpRoOd/HDFIjLBAucerWdjYQm0VAVWL+jhtMIDavgIvE
	+cMP2CC2yUl82POIHcTmFHCVWH1yH1iNEFDNt8VLWEGGSgisY5doXTqBCWKQgMS3yYdYIN6R
	ldh0gBlijqTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERj4p/89m7CD
	8d4B60OMyUDjJjJLiSbnAyMnryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoY01I6VitsFTwu//b2l77fXVrrTFq1LvnuzHjAvrZQME5eNW3pAwYz
	aeuIvMQp+zvbGSqX5IvLK1vsZXv/TfL0tJr60Ls/Xk+XedT1sVzN4klHH9uxr6dLLyeL+vHP
	Xlp98MMnj24trYJrRuFm1lvn961Yu/BggAm7Q3hkwMHwtMgjYn/Xna9UYinOSDTUYi4qTgQA
	TgUguZICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd1ZPVODDe42CFhMffiEzeL6l+es
	FvOPnGO1OPBnB6PF2aY37BbfrnQwWVzeNYfN4nbjCjaL1r1H2B04PXbOusvusWlVJ5vHnWt7
	2Dz6tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bWF29Y
	C+7yVdye5dfAuJ2ni5GTQ0LARGLl/FnMELaYxIV769m6GLk4hASmM0pc3D6HCcJpYpLYs/Es
	K0gVm4CWxP4XN4CqODhEBKIk1naA1TALzGaUaDnfBzZJWCBc4tSt7WwgNouAqsT8HTeYQGxe
	AReJ84cfsEFsk5P4sOcRO4jNKeAqsfrkPrAaIaCab4uXsE5g5F3AyLCKUTS1ILmgOCk910iv
	ODG3uDQvXS85P3cTIziynknvYFzVYHGIUYCDUYmHN+L3lGAh1sSy4srcQ4wSHMxKIrw+OVOD
	hXhTEiurUovy44tKc1KLDzEmA101kVlKNDkfGPV5JfGGxiZmRpZG5oYWRsbmpAkrifMebLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cDYtXNHjcwE84a8C1xNx2Wm92UzFzUEB84XFuYS4Dz88ZeG
	/ALlW+7/FiwU+bbe7CXPXKdb+SvMDtV4Zv6ZxKvFWD9h7j1J2+ztAtnV7H+f3eP+dMQousBN
	0Ndglea+Ve17qiymbJu8V37bD0uufVLvDnld7OPJucRd1/JgWlCuVajRN6fTdWZKLMUZiYZa
	zEXFiQDWwIuO8AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add regulator suspend state to constraint in dt file. The regulation_
constraints structure already has regulator suspend state field as following.
The regulator suspend state control the state of regulator according to
PM (Power Management) state.
- struct regulator_state state_disk
- struct regulator_state state_mem
- struct regulator_state state_standby

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 Documentation/devicetree/bindings/regulator/regulator.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index e2c7f1e..b2a4a72 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -19,6 +19,12 @@ Optional properties:
   design requires. This property describes the total system ramp time
   required due to the combination of internal ramping of the regulator itself,
   and board design issues such as trace capacitance and load on the supply.
+- regulator-initial-state: initial state for suspend state
+- regulator-state-[standby/mem/disk] sub-root node for suspend state
+	regulator-volt: voltage consumers may set in suspend state
+	regulator-mode: voltage mode in suspend state
+	regulator-on-in-suspend: regulator should be on in suspend state
+	regulator-off-in-suspend: regulator should be off in suspend state
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
@@ -34,6 +40,12 @@ Example:
 		regulator-max-microvolt = <2500000>;
 		regulator-always-on;
 		vin-supply = <&vin>;
+
+		regulator-state-mem {
+			regulator-volt = <1000000>;
+			regulator-mode = <0x8>;
+			regulator-off-in-suspend;
+		};
 	};
 
 Regulator Consumers:
-- 
1.8.0

