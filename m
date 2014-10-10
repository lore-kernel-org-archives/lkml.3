Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaJJLf4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:35:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56311 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaJJLfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:35:43 -0400
X-AuditID: cbfee68d-f79296d000004278-ca-5437c48bb5b8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, javier@dowhile0.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 2/3] dt-bindings: regulator: Add regulator suspend state for
 PM state
Date: Fri, 10 Oct 2014 20:35:34 +0900
Message-id: <1412940935-14721-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
References: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkQLf7iHmIwZELEhZTHz5hs7j+5Tmr
	xfwj51gtDvzZwWhx7fcMNouzTW/YLb5d6WCyuLxrDptF694j7A6cHn9ntzJ77Jx1l91j06pO
	No871/awefRtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGvNNXGQseCVT8mTiDuYFxAl8XIyeH
	hICJxIwTW9kgbDGJC/fWA9lcHEICSxklWp/tZYMperZuB1RiEaPElYfvoZwmJomPj28yg1Sx
	CWhJ7H9xA6xDBGjU7TmdzCBFzAI3GCUObF/GApIQFoiUuNz0mBHEZhFQlXiweTuYzSvgKnHo
	3G1miHVyEh/2PGIHsTkF3CTmTG0AqxECqln68RgLyFAJgXXsEse3bGWFGCQg8W3yIaAEB1BC
	VmLTAag5khIHV9xgmcAovICRYRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYCSc/vesdwfj
	7QPWhxgFOBiVeHgvyJiHCLEmlhVX5h5iNAXaMJFZSjQ5HxhveSXxhsZmRhamJqbGRuaWZkri
	vIpSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJYvKPat7ag3lu3a99nshV3VrgkvFY1D
	9bT2hfCyLmy68eo888QHIvbPPm1/dyx4TrNF6V3WbWqdHEY6rms8FJ9OWarxUJZtcde5fV/l
	HpkoPS1OfaZy+N4m2SkLN9xOcVCyXHvwecTKxIJHmspzF94vPDnbwUCp5jTftieO+XsTxB7c
	NVqbc0GJpTgj0VCLuag4EQBFePepfwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAd3uI+YhBouOC1lMffiEzeL6l+es
	FvOPnGO1OPBnB6PFtd8z2CzONr1ht/h2pYPJ4vKuOWwWrXuPsDtwevyd3crssXPWXXaPTas6
	2TzuXNvD5tG3ZRWjx+dNcgFsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZK
	CnmJuam2Si4+AbpumTlAZykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsY
	M+advspY8Eig4s/EGcwNjBP4uhg5OSQETCSerdvBBmGLSVy4tx7I5uIQEljEKHHl4Xsop4lJ
	4uPjm8wgVWwCWhL7X9wA6xAB6rg9p5MZpIhZ4AajxIHty1hAEsICkRKXmx4zgtgsAqoSDzZv
	B7N5BVwlDp27zQyxTk7iw55H7CA2p4CbxJypDWA1QkA1Sz8eY5nAyLuAkWEVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnCcPZPewbiqweIQowAHoxIP7wUZ8xAh1sSy4srcQ4wSHMxKIrzz
	9wKFeFMSK6tSi/Lji0pzUosPMZoCXTWRWUo0OR+YAvJK4g2NTcyMLI3MDS2MjM2VxHkPtloH
	CgmkJ5akZqemFqQWwfQxcXBKNTAubP/ksGZO8zyFb80TlCVyHI3yFH84KHUcMXyyVao6Ok1/
	mW/ftyczdXf28BZwBD9UUStKN5AWO2D49Vxa/O/dP7L1HjAx/+gNEVp1aOcHF/nWz8dvdQuV
	z2Vz4L36bzb3ssCLbRUTbs/tmJPzP1Jw6Zve9UvLQ3nv9B5+fcpjdke1dt/+pQxKLMUZiYZa
	zEXFiQC5emyTyQIAAA==
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

Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/regulator/regulator.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/regulator/regulator.txt b/Documentation/devicetree/bindings/regulator/regulator.txt
index 8607433..aaad615 100644
--- a/Documentation/devicetree/bindings/regulator/regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/regulator.txt
@@ -19,6 +19,15 @@ Optional properties:
   design requires. This property describes the total system ramp time
   required due to the combination of internal ramping of the regulator itself,
   and board design issues such as trace capacitance and load on the supply.
+- regulator-state-mem sub-root node for Suspend-to-RAM mode
+  : suspend to memory, the device goes to sleep, but all data stored in memory,
+  only some external interrupt can wake the device.
+- regulator-state-disk sub-root node for Suspend-to-DISK mode
+  : suspend to disk, this state operates similarly to Suspend-to-RAM,
+  but includes a final step of writing memory contents to disk.
+- regulator-state-[mem/disk] node has following common properties:
+	- regulator-on-in-suspend: regulator should be on in suspend state.
+	- regulator-off-in-suspend: regulator should be off in suspend state.
 
 Deprecated properties:
 - regulator-compatible: If a regulator chip contains multiple
@@ -34,6 +43,10 @@ Example:
 		regulator-max-microvolt = <2500000>;
 		regulator-always-on;
 		vin-supply = <&vin>;
+
+		regulator-state-mem {
+			regulator-on-in-suspend;
+		};
 	};
 
 Regulator Consumers:
-- 
1.8.0

