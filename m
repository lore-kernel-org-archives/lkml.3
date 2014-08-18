Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaHRG1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:27:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26492 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaHRG1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:27:16 -0400
X-AuditID: cbfee691-b7f306d000003d81-85-53f19cbfd67c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, k.kozlowski@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 2/2] dt-bindings: regulator: Add regulator suspend state for
 PM state
Date: Mon, 18 Aug 2014 15:27:03 +0900
Message-id: <1408343223-4043-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408343223-4043-1-git-send-email-cw00.choi@samsung.com>
References: <1408343223-4043-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSoLt/zsdgg87duhZTHz5hs7j+5Tmr
	xfwj51gtDvzZwWjx+oWhxdmmN+wW3650MFlc3jWHzaJ17xF2B06PnbPusntsWtXJ5nHn2h42
	j74tqxg9Pm+SC2CN4rJJSc3JLEst0rdL4Mp49mI7a8F2kYoZ09cwNTBOEexi5OSQEDCReLNs
	CRuELSZx4d56IJuLQ0hgKaPErZVT2GCKztxtZYJITGeUWN9ygRHCaWKSuPTnPjNIFZuAlsT+
	FzfAOkSARt2e08kMUsQscI9R4svqhywgCWGBSIlvL/eBNbAIqEr8mv6QHcTmFXCR+D7zOdQ6
	OYkPex4BxTk4OAVcJSb0iYCEhYBKFjUcZAGZKSGwjl1i+osmVog5AhLfJh9iAamXEJCV2HSA
	GWKMpMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeul5yfu4kRGPqn/z2buIPx/gHr
	Q4zJQOMmMkuJJucDYyevJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhj9LR/ufRvMOPHHy6zgLQG3yvWq9d6KPNgdnnt2T4ygL/+0g2U1KX+va0st
	+S2W/uLs7MLjdj68h5/c1da/5nerwmjRJX1J9fMTOlXaTaOVNy25qca3xzaWWys4NHOP5QrG
	S3Mnf2uz7XvmtaDp9MZdEyZu9H6rw2e8bT/Hvdeu97u3idoGvolXYinOSDTUYi4qTgQAxPcz
	D5MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jQd39cz4GGzxbqGox9eETNovrX56z
	Wsw/co7V4sCfHYwWr18YWpxtesNu8e1KB5PF5V1z2Cxa9x5hd+D02DnrLrvHplWdbB53ru1h
	8+jbsorR4/MmuQDWqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGc9ebGct
	2C5SMWP6GqYGximCXYycHBICJhJn7rYyQdhiEhfurWfrYuTiEBKYziixvuUCI4TTxCRx6c99
	ZpAqNgEtif0vbrCB2CJAHbfndDKDFDEL3GOU+LL6IQtIQlggUuLby31gDSwCqhK/pj9kB7F5
	BVwkvs98zgaxTk7iw55HQHEODk4BV4kJfSIgYSGgkkUNB1kmMPIuYGRYxSiaWpBcUJyUnmuo
	V5yYW1yal66XnJ+7iREcWc+kdjCubLA4xCjAwajEw+vx+kOwEGtiWXFl7iFGCQ5mJRHedU0f
	g4V4UxIrq1KL8uOLSnNSiw8xmgIdNZFZSjQ5Hxj1eSXxhsYmZkaWRuaGFkbG5krivAdarQOF
	BNITS1KzU1MLUotg+pg4OKUaGCc9Z9vd39ydKxXl1yplNl0mpnmjaU+Kc5zzjzOrHuuYlvMu
	fGr7LvpUAVfupD81y78caH+7eRl70lfeWPfNeivO9jBtPn+pZlNlu/mF3fMFtly+O/UTL5OQ
	muiZsodz/qQum6DU89Wx6cmV+VtXpq4MWbe+rNR7lo+Mvk/x51DRBw//h+5Wk1BiKc5INNRi
	LipOBADGjgYYwgIAAA==
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

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/regulator/regulator.txt    | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 8607433..ccba90b 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -19,6 +19,23 @@ Optional properties:
   design requires. This property describes the total system ramp time
   required due to the combination of internal ramping of the regulator itself,
   and board design issues such as trace capacitance and load on the supply.
+- regulator-initial-state: initial state for suspend state, cnd set initial
+  state among following defined suspend states:
+  <3>: PM_SUSPEND_MEM - Setup regulator according to regulator-state-mem
+  <4>: PM_SUSPEND_MAX - Setup regulator according to regulator-state-disk
+- regulator-state-mem sub-root node for Suspend-to-RAM mode
+  : suspend to memory, the device goes to sleep, but all data stored in memory,
+  only some external interrupt can wake the device.
+- regulator-state-disk sub-root node for Suspend-to-disk mode
+  : suspend to disk, this state operates similarly to Suspend-to-RAM,
+  but includes a final step of writing memory contents to disk.
+- regulator-state-[mem/disk] node has following common properties:
+	- regulator-volt: voltage consumers may set in suspend state.
+	- regulator-on-in-suspend: regulator should be on in suspend state.
+	- regulator-off-in-suspend: regulator should be off in suspend state.
+	If node don't include regulator-[on/off]-in-suspend, can't change
+	regulator state in suspend mode and only should sustain the regulator
+	state of normal state.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
@@ -34,6 +51,11 @@ Example:
 		regulator-max-microvolt = <2500000>;
 		regulator-always-on;
 		vin-supply = <&vin>;
+
+		regulator-state-mem {
+			regulator-volt = <1000000>;
+			regulator-on-in-suspend;
+		};
 	};
 
 Regulator Consumers:
-- 
1.8.0

