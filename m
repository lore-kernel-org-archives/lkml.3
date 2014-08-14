Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaHNAke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:40:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63327 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaHNAkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:40:19 -0400
X-AuditID: cbfee690-b7f526d000003627-7f-53ec0571a4b6
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 2/2] dt-bindings: regulator: Add regulator suspend state for
 PM state
Date: Thu, 14 Aug 2014 09:40:14 +0900
Message-id: <1407976814-21882-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407976814-21882-1-git-send-email-cw00.choi@samsung.com>
References: <1407976814-21882-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSolvI+ibY4MZ7IYupD5+wWVz/8pzV
	Yv6Rc6wWB/7sYLR4/cLQ4mzTG3aLb1c6mCwu75rDZtG69wi7A6fHzll32T02repk87hzbQ+b
	R9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGVM33WVpeC/ZMXa1nnsDYzvRLsYOTkkBEwkLrya
	yghhi0lcuLeerYuRi0NIYCmjxK+rr5hhiv4svsgCkVjEKDF/djcjhNPEJHHn2VpWkCo2AS2J
	/S9usIHYIkCjbs/pZAYpYha4xyjxZfVDFpCEsECkxIWp05hAbBYBVYnVTV1gu3kFXCV6n36G
	Wicn8WHPI3YQm1PATeLW/Ydg9UJANefanrCDDJUQWMUusXn2NnaIQQIS3yYfAlrAAZSQldh0
	AGqOpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kolecmFtcmpeul5yfu4kRGPyn/z2bsIPx3gHr
	Q4zJQOMmMkuJJucDoyevJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhjrtvYtWR1UXLPG9tJBFrk3sZu14rkvzbNzM2K5b17xkiX7pdCxFx/upldl
	Cdc8VmVbdlz8nMOhNan5ryp2T1o1ZWFrvUXfr8mCn77wZmz5/lDwgeZUCY70oBnftDsW/DNl
	mp/V3121z+r67CYV28YY1QnalvumM2nytlTvX+0bebBUYe3MLzuVWIozEg21mIuKEwFdTfOK
	lAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAd1C1jfBBkefc1lMffiEzeL6l+es
	FvOPnGO1OPBnB6PF6xeGFmeb3rBbfLvSwWRxedccNovWvUfYHTg9ds66y+6xaVUnm8eda3vY
	PPq2rGL0+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxvRdV1kK
	/ktWrG2dx97A+E60i5GTQ0LAROLP4ossELaYxIV769m6GLk4hAQWMUrMn93NCOE0MUncebaW
	FaSKTUBLYv+LG2wgtghQx+05ncwgRcwC9xglvqx+CDZKWCBS4sLUaUwgNouAqsTqpi5GEJtX
	wFWi9+lnZoh1chIf9jxiB7E5Bdwkbt1/CFYvBFRzru0J+wRG3gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgmPrmfQOxlUNFocYBTgYlXh4PaJeBwuxJpYVV+YeYpTgYFYS4VVmfhMs
	xJuSWFmVWpQfX1Sak1p8iNEU6KqJzFKiyfnAuM8riTc0NjEzsjQyN7QwMjZXEuc92GodKCSQ
	nliSmp2aWpBaBNPHxMEp1cDY5tYkqbf0bPdSl1uV8v9+FQWz8rtek33C+WL10oPvRDQdW8+5
	2H5XfLZoB8vCzsREF4W1CoyvihgeJ/+9FJmgzn7ISFdafHa52MK5S6Y0SfUJ63k7SjPJVayf
	fyPguEXWzqMvt5+7rv1ih3YI40/JG6fjsoK32i++Omn+qs/Z5g3Okhs+NkxSYinOSDTUYi4q
	TgQAIce/vcMCAAA=
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
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/regulator/regulator.txt    | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 8607433..c4f566a 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -19,6 +19,33 @@ Optional properties:
   design requires. This property describes the total system ramp time
   required due to the combination of internal ramping of the regulator itself,
   and board design issues such as trace capacitance and load on the supply.
+- regulator-initial-state: initial state for suspend state, cnd set initial
+  state among following defined suspend states:
+  <2>: PM_SUSPEND_STANDBY - Setup regulator according to regulator-state-standby
+  <3>: PM_SUSPEND_MEM - Setup regulator according to regulator-state-mem
+  <4>: PM_SUSPEND_MAX - Setup regulator according to regulator-state-disk
+- regulator-state-standby sub-root node for Standby mode
+  : the device is in a power-saving state, but can also receive certain events,
+  specific behavior depends on the specific device.
+- regulator-state-mem sub-root node for Suspend-to-RAM mode
+  : suspend to memory, the device goes to sleep, but all data stored in memory,
+  only some external interrupt can wake the device.
+- regulator-state-disk sub-root node for Suspend-to-disk mode
+  : suspend to disk, this state operates similarly to Suspend-to-RAM,
+  but includes a final step of writing memory contents to disk.
+- regulator-state-[standby/mem/disk] node has following common properties:
+	- regulator-volt: voltage consumers may set in suspend state.
+	- regulator-mode: voltage mode in suspend state, can set mode among
+	following defined regulator modes:
+	0x1: REGULATOR_MODE_FAST, Regulator can handle fast changes.
+	0x2: REGULATOR_MODE_NORMAL, Normal regulator power supply mode.
+	0x4: REGULATOR_MODE_IDLE, Regulator runs in a more efficient mode.
+	0x8: REGULATOR_MODE_STANDBY, Regulator runs in the most efficient mode.
+	- regulator-on-in-suspend: regulator should be on in suspend state.
+	- regulator-off-in-suspend: regulator should be off in suspend state.
+	If node don't include regulator-[on/off]-in-suspend, can't change
+	regulator state in suspend mode and only should sustain the regulator
+	state of normal state.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
@@ -34,6 +61,11 @@ Example:
 		regulator-max-microvolt = <2500000>;
 		regulator-always-on;
 		vin-supply = <&vin>;
+
+		regulator-state-mem {
+			regulator-volt = <1000000>;
+			regulator-off-in-suspend;
+		};
 	};
 
 Regulator Consumers:
-- 
1.8.0

