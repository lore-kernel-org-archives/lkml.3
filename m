Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbbAZER2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:17:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35520 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbbAZEQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:16:51 -0500
X-AuditID: cbfee68e-f79b46d000002b74-6a-54c5bfa56d6c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        sangbae90.lee@samsung.com, inki.dae@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v10 6/7] ARM: dts: exynos: Add PPMU node for Exynos3250-based
 Rinato/Monk board
Date: Mon, 26 Jan 2015 13:16:32 +0900
Message-id: <1422245793-8552-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
References: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkQHfp/qMhBotX21g8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFv2PXzNbnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i9a9R9gtjn86yGKxatcfRgdBjzXz1jB67Jx1l91j8Z6XTB6bVnWyeWxeUu/R
	t2UVo8fnTXIB7FFcNimpOZllqUX6dglcGRO6FrAU7BOqOHXdrIHxNV8XIyeHhICJRNPCLjYI
	W0ziwr31YLaQwFJGidlX67sYOcBqDu7K6mLkAgpPZ5T4/fwYM4TTxCSx4dorFpAGNgEtif0v
	boA1iwjoSXQe28MOUsQsMJ1ZYvKCiawgCWGBRImTnYeYQGwWAVWJPevPM4LYvAIuEr333rBA
	XKEgsWz5TLB6TgFXiYkNzxlBrhACqvn+nQtkpoTAV3aJz493skDMEZD4NvkQC8SlshKbDjBD
	jJGUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj6vS/Z307GG8esD7E
	KMDBqMTD29B8NESINbGsuDL3EKMp0IaJzFKiyfnA6M0riTc0NjOyMDUxNTYytzRTEudNkPoZ
	LCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRe/+u+YEbLOdUrMqed9pg3s+qojV+f160rTLL
	ERJjTNjM/D7R25D/Z90CC26fq9/cYuaUVvHL3EhiErrnNlfPIbBHdOEUk73nPLsri7yEBUsO
	/Mg12lCy+uqbFYr+m4yajd31VAz3VPqdV72q6zHzSciH7t9+Z4Wawm5+KZt91zr6uGOl8kEl
	luKMREMt5qLiRAA/Yz2FpgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd2l+4+GGHw8aGzxeM1iJouNM9az
	Wlz/8pzVYtL9CSwWr18YWvQ/fs1scbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVr3HmG3OP7pIIvFql1/GB0EPdbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H
	35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAH2gpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcyY0LWApWCf
	UMWp62YNjK/5uhg5OCQETCQO7srqYuQEMsUkLtxbz9bFyMUhJDCdUeL382PMEE4Tk8SGa69Y
	QKrYBLQk9r+4wQZiiwjoSXQe28MOUsQsMJ1ZYvKCiawgCWGBRImTnYeYQGwWAVWJPevPM4LY
	vAIuEr333rBArFOQWLZ8Jlg9p4CrxMSG54wgFwkB1Xz/zjWBkXcBI8MqRtHUguSC4qT0XCO9
	4sTc4tK8dL3k/NxNjOC4fSa9g3FVg8UhRgEORiUeXo3GoyFCrIllxZW5hxglOJiVRHjLpwCF
	eFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR+YUvJK4g2NTcyMLI3MDS2MjM2VxHmV7NtChATS
	E0tSs1NTC1KLYPqYODilGhgrJT3e++euvrqH0zX04teQSJ/My4diDeRlFhhIvGXpes2pzHji
	mH75Mp1eqVV229a6pm3rdJ2559ur6PWLAuaxioqsOuCb/GDZw2kWEk+drbnKDs+/tW7WekGe
	Qv913nX/s/cX/NKv4Ozn1V6+J25G3oP5d+KmcZ9UU5rcq2LCuOzj+8l/oxYqsRRnJBpqMRcV
	JwIA40tKtvECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato/Monk board. The PPMU node
is used to get the utilization of DMC0/DMC1/LEFTBUS/RIGHTBUS Block.

Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-monk.dts   | 40 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts | 40 +++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..fcceb59 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -420,6 +420,46 @@
 	status = "okay";
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
 &xusbxti {
 	clock-frequency = <24000000>;
 };
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7cc52b5..9dd1ce1 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -595,6 +595,46 @@
 	status = "okay";
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
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

