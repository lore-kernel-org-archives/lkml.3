Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaGIEs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:48:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64243 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaGIEsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:48:25 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-26-53bcc996631e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        geunsik.lim@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCHv2 2/2] dt-bindings: regulator: Add regulator suspend
 state for PM state
Date: Wed, 09 Jul 2014 13:48:11 +0900
Message-id: <1404881291-7949-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1404881291-7949-1-git-send-email-cw00.choi@samsung.com>
References: <1404881291-7949-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSqDvt5J5ggy0fpCymPnzCZnH9y3NW
	i/lHzrFa/JnQymZx4M8ORovXLwwtzja9Ybf4dqWDyeLyrjlsFq17j7A7cHnsnHWX3WPTqk42
	jzvX9rB59G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8b0k5NYCk5JVpzdtIC9gXGfaBcjJ4eE
	gInEmpvzWCFsMYkL99azdTFycQgJLGWUWLP1GQtMUUPXHRaIxHRGiZ7tU5ghnCYmiW0z5zCC
	VLEJaEnsf3GDDcQWARp1e04nWBGzwHdGiTdPj7GDJIQFEiR2nuoB28cioCrRt38JM4jNK+Ai
	8XJuKxvEOjmJD3segdVzCrhKLL/5BMwWAqo5cPA+2FAJgXXsEu1f3kINEpD4NvkQ0H0cQAlZ
	iU0HmCHmSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgXFw+t+z3h2M
	tw9YH2JMBho3kVlKNDkfGEd5JfGGxmZGFqYmpsZG5pZmpAkrifMmPUwKEhJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cAo81z3wpypDxflOkw+VLH/fmyTlkfipqLYXqnN9tvm/dimtPftnvQT
	izi8mm7P6J5R+PYR2y7zkxUGJy/1+R3cdm5+4rOoVZoBv5OLPAt62c+vnTRxd9jNbe+ZDFgX
	3gx8/NfpKGvH/DLjeLWXwhffXXJtYq8w+rIs2E/gt3fsdlueVyV2M+5MVmIpzkg01GIuKk4E
	ACr6PkmZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t9jQd1pJ/cEG3x+IWQx9eETNovrX56z
	Wsw/co7V4s+EVjaLA392MFq8fmFocbbpDbvFtysdTBaXd81hs2jde4Tdgctj56y77B6bVnWy
	edy5tofNo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU
	8hJzU22VXHwCdN0yc4CuUlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm
	TD85iaXglGTF2U0L2BsY94l2MXJySAiYSDR03WGBsMUkLtxbz9bFyMUhJDCdUaJn+xRmCKeJ
	SWLbzDmMIFVsAloS+1/cYAOxRYA6bs/pBCtiFvjOKPHm6TF2kISwQILEzlM9rCA2i4CqRN/+
	JcwgNq+Ai8TLua1sEOvkJD7seQRWzyngKrH85hMwWwio5sDB+8wTGHkXMDKsYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAiOsmdSOxhXNlgcYhTgYFTi4VXg2RMsxJpYVlyZe4hRgoNZSYT3
	mxtQiDclsbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OBCSCvJN7Q2MTMyNLI3NDCyNhcSZz3QKt1
	oJBAemJJanZqakFqEUwfEwenVANj1qQbFewPTkVL/H0rX8Bkt8f4b/q7mX9PHc7dUb6Rd9Ol
	+2ZZlxhbF14Syyr5rL3uwvK1/YeeiJq1OLT28SzKeBZ78PLrX7+emC6b+sWolWPC5tYzsT/v
	5Ah7/LzP26e+tcRRd69ERpLRt9qb2b8Kj6TcUS4pXe608TrbX6ML7/RKKzS4X//aqsRSnJFo
	qMVcVJwIACZKERDIAgAA
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

