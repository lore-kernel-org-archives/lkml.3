Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbbATHKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:10:50 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbATHKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:10:40 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-09-54bdff56ba03
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v9 7/7] ARM: dts: exynos: Add PPMU node for Exynos4412-based
 TRATS2 board
Date: Tue, 20 Jan 2015 16:10:09 +0900
Message-id: <1421737809-4010-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
References: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSoBv2f2+IwfrZ1haP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgyphx/TpTwXruilXHfrM1MC7g7GLk5JAQMJHYOHEyK4QtJnHh
	3nq2LkYuDiGBpYwSky72sMEUNe16A1YkJLCIUeLRgjiIoiYmiQMz74EVsQloSex/cQPMFhHQ
	k+g8tocdxGYW+MMk0bSJpYuRg0NYIFriyV9DkDCLgKpE38ROsJm8Ai4Se8+8ZYfYpSCxbPlM
	sDingKvE9i2XGSH2ukg0f37PBFHzkl2iZ5E7xBwBiW+TD4GNlxCQldh0gBmiRFLi4IobLBMY
	hRcwMqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECIym0/+eTdjBeO+A9SFGAQ5GJR7eF6v2
	hgixJpYVV+YeYjQF2jCRWUo0OR8Ys3kl8YbGZkYWpiamxkbmlmZK4ryvpX4GCwmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamCsclPZL/hNwG8xY9S+zEccplP+vJlj8DJbuaZS+fxn2avvREW1
	mVsk9U96CLM+TK21NpY6Erkv4fJbjoz/oXW/8o00NJ7qbU5k9xVfuH3XI6f3yq6LDSM3Pa6O
	LBX677tgRfXpaKOCH7YZTtUSOheb02XetzX72ZR+LuKV3R8uaR98jseKWYmlOCPRUIu5qDgR
	AHAtCU6hAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAd2w/3tDDBb/NrJ4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMGdevMxWs565Ydew3
	WwPjAs4uRk4OCQETiaZdb1ghbDGJC/fWs4HYQgKLGCUeLYjrYuQCspuYJA7MvAeWYBPQktj/
	4gaYLSKgJ9F5bA87iM0s8IdJomkTSxcjB4ewQLTEk7+GIGEWAVWJvomdYPN5BVwk9p55yw6x
	S0Fi2fKZYHFOAVeJ7VsuM0LsdZFo/vyeaQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwdH6TGoH48oGi0OMAhyMSjy8Dmv3hgixJpYVV+YeYpTgYFYS4Z3wFCjEm5JYWZValB9f
	VJqTWnyI0RToqonMUqLJ+cBEklcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKanZpakFoE
	08fEwSnVwFjdMcVaof5CQ+Huo6xdR7ZKn0yJjT+qvUpnZqjB3rK/UZJqT69cNX91a3ldld7a
	N3xno7y9nzxdfFxP0u/s+d+b3UV9gu7yn/teNuPXQ1eu+RO+1e7z8ClTWKNVFBPEd2T6hRP+
	DNy+9zk4lvVJ2Ob2VtW/eqi6T5nLiZHz1Ka5mbt+n1h4SEqJpTgj0VCLuag4EQB3a8oY7AIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add dt node for PPMU_{DMC0|DMC1|LEFTBUS|RIGHTBUS} for
exynos4412-trats2 board. Each PPMU dt node includes one event of 'PPMU Count3'.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b4..70eac85 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -865,6 +865,46 @@
 	};
 };
 
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_3: ppmu-event3-dmc0 {
+			event-name = "ppmu-event3-dmc0";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-event3-dmc1 {
+			event-name = "ppmu-event3-dmc1";
+		};
+	};
+};
+
+&ppmu_leftbus {
+	status = "okay";
+
+	events {
+		ppmu_leftbus_3: ppmu-event3-leftbus {
+			event-name = "ppmu-event3-leftbus";
+		};
+	};
+};
+
+&ppmu_rightbus {
+	status = "okay";
+
+	events {
+		ppmu_rightbus_3: ppmu-event3-rightbus {
+			event-name = "ppmu-event3-rightbus";
+		};
+	};
+};
+
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
1.8.5.5

