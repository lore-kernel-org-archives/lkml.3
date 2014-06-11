Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaFKAls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 20:41:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52379 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaFKAlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 20:41:36 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-de-5397a5beeae3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 2/2] dt-bindings: regulator: Add regulator suspend state for
 PM state
Date: Wed, 11 Jun 2014 09:41:23 +0900
Message-id: <1402447283-11356-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1402447283-11356-1-git-send-email-cw00.choi@samsung.com>
References: <1402447283-11356-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWyRsSkUHff0unBBvM6uCymPnzCZnH9y3NW
	i/lHzrFaHPizg9HibNMbdotvVzqYLC7vmsNmcbtxBZtF694j7A6cHjtn3WX32LSqk83jzrU9
	bB59W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVsa1nGlvBKcmKBytusTQw7hPtYuTgkBAwkVj2
	lauLkRPIFJO4cG89G4gtJLCUUaL1li9Myf0VIl2MXEDh6YwSS6//YYVwmpgkFu4+zQzSwCag
	JbH/xQ02kAYRgSiJtR1MIDXMArMZJVrO94HVCAtESjQemsgCUsMioCqxbrUCiMkr4CpxYToL
	xAlyEh/2PGIHsTkF3CRuTN8EdY6rxOJL7WwQNevYJc61F4LYLAICEt8mH2KBOFNWYtMBZogS
	SYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMOBP/3s2cQfj/QPWhxiT
	gcZNZJYSTc4HRkxeSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTA2b9DjOXwle9V9jtu/ik9oz4jO9dJbnPjq/o2Iv38WHZjIc/uGtfGhdedKXFht
	FyRennfu5EuFhZP+r3jsqPl/3eRZa7SCJWXem/R2BP7887FQ+UTk7N1Xk6eWJLbaaGs++iD3
	Uf20Q08yQ+KTvY0P2G+qWZ4R1p1U4/HZft22Ob7/5ggkqRYuVGIpzkg01GIuKk4EAGHIxLqO	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQd19S6cHG1w8zWQx9eETNovrX56z
	Wsw/co7V4sCfHYwWZ5vesFt8u9LBZHF51xw2i9uNK9gsWvceYXfg9Ng56y67x6ZVnWwed67t
	YfPo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBnbeqax
	FZySrHiw4hZLA+M+0S5GDg4JAROJ+ytEuhg5gUwxiQv31rN1MXJxCAlMZ5RYev0PK4TTxCSx
	cPdpZpAqNgEtif0vbrCBNIsIREms7WACqWEWmM0o0XK+D6xGWCBSovHQRBaQGhYBVYl1qxVA
	TF4BV4kL01kgdslJfNjziB3E5hRwk7gxfRMbiC0EVLL4UjvbBEbeBYwMqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCo+qZ9A7GVQ0WhxgFOBiVeHglpKcHC7EmlhVX5h5ilOBgVhLhtUkD
	CvGmJFZWpRblxxeV5qQWH2JMBrppIrOUaHI+MOLzSuINjU3MjCyNzA0tjIzNSRNWEuc92God
	KCSQnliSmp2aWpBaBLOFiYNTqoFROjDNauPE2TMWzGKa2MPleGjyEbXdF9Q2rG01Wy90YmlX
	7nyJvFXXHF51zQ3pWWintLZs9V7J+e2LUqKPVVulmWiu3bN2abf/SsGsVfWyEQfiO/xeHvX5
	9Xb+8m1zZ86eH/fXwsPmwiH28JUnVPc1PtKJY2x0Wseq5GN9aUPBXsn3N3dv7jP4rsRSnJFo
	qMVcVJwIAHrFi2HuAgAA
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
 .../devicetree/bindings/regulator/regulator.txt    | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index e2c7f1e..7a85191 100644
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

