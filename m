Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaIEEbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:31:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27077 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaIEEab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:30:31 -0400
X-AuditID: cbfee68e-f79536d000000fd1-56-54093c60557f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, linux-pm@vger.kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        b.zolnierkie@samsung.com, nm@ti.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 5/5] ARM: dts: Add dt node fo PPMU_CPU/DMC0/DMC1 for
 exynos4412-trats2
Date: Fri, 05 Sep 2014 13:30:19 +0900
Message-id: <1409891419-28560-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
References: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkQDfBhjPE4MEHFYvHaxYzWWycsZ7V
	4vqX56wWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+JovbjSvYLN78OMtk8XjFW3aL
	Vbv+MDrweuycdZfdY/Gel0wem5fUe/RtWcXocfzGdiaPz5vkAtiiuGxSUnMyy1KL9O0SuDJW
	zt/EVvCYs2Ld2swGxufsXYycHBICJhIPPnUwQ9hiEhfurWfrYuTiEBJYyiixZOcHZpiiWQcn
	QyWmM0pMOtzNCOE0MUk8f3OJEaSKTUBLYv+LG2wgtoiAmcS+HX9ZQYqYBXYwSVw78AOsSFgg
	RmLV8UVARRwcLAKqEj971UDCvAKuEnevXmCD2CYn8WHPI7DzOAXcJNbev8YEYgsB1Vw8PokZ
	ZKaEwCl2iZlrt7OAJFgEBCS+TT7EAjJTQkBWYtMBqKslJQ6uuMEygVF4ASPDKkbR1ILkguKk
	9CIjveLE3OLSvHS95PzcTYzAWDn971nfDsabB6wPMQpwMCrx8C74zBEixJpYVlyZe4jRFGjD
	RGYp0eR8YETmlcQbGpsZWZiamBobmVuaKYnzJkj9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXA2Nw0teC7ngZfz0JzdVMPjsczHlx53/XC2rGEqzhZYELh2y6pmTNuM7ycFFJkk5T876fx
	3QJl9rK+H+InT5c1JJhYN+qc3N5QvlyF0Tq+muuA1/xa7zKm2KzGrU5d96fxyqhO+fMgQ/rW
	e/fcKztL+AojKtkLVkadWX83sElw3bwN4b11f/qVWIozEg21mIuKEwEmEV+ukAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jQd0EG84Qg28zZC0er1nMZLFxxnpW
	i+tfnrNa9C64ymZxtukNu8Wmx9dYLS7vmsNm8bn3CKPFjPP7mCxuN65gs3jz4yyTxeMVb9kt
	Vu36w+jA67Fz1l12j8V7XjJ5bF5S79G3ZRWjx/Eb25k8Pm+SC2CLamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYsXL+JraCx5wV69ZmNjA+Z+9i5OSQEDCRmHVwMhuELSZx
	4d56IJuLQ0hgOqPEpMPdjBBOE5PE8zeXGEGq2AS0JPa/uAHWISJgJrFvx19WkCJmgR1MEtcO
	/AArEhaIkVh1fBFQEQcHi4CqxM9eNZAwr4CrxN2rF6C2yUl82PMI7ApOATeJtfevMYHYQkA1
	F49PYp7AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAkPpPawbiyweIQowAHoxIP
	74LPHCFCrIllxZW5hxglOJiVRHi93gCFeFMSK6tSi/Lji0pzUosPMZoCHTWRWUo0OR+YJPJK
	4g2NTcyMLI3MDS2MjM2VxHkPtFoHCgmkJ5akZqemFqQWwfQxcXBKNTAe7fAtKv9bcVywgjnJ
	7voMja/XGEP+OgZx66l8sGc1u/5TSLTX7YFDkrKTfqJPAJeSxVntyFPrzRKf6/xmt9h5YOnf
	LI3O19/vBLxevfN8g70Y0840/v6vvN/2vynq7bBsOnlk4fz+GG+pC5OFknrtvU3nrJ9vl79z
	yiaLMsO+N2qLK5ds11ZiKc5INNRiLipOBAB91Xo72gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add dt node for PPMU_CPU/DMC0/DMC1 for exynos4412-trats2 board.
Each PPMU dt node includes one event of 'PPMU Count 3'

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 11967f4..00dcb91 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -770,6 +770,35 @@
 		status = "okay";
 	};
 
+	ppmu_cpu: ppmu_cpu@106c0000 {
+		status = "okay";
+
+		events {
+			ppmu_cpu_3: ppmu-cpu-pmcnt3 {
+				event-name = "ppmu-cpu-pmcnt3";
+			};
+		};
+	};
+
+	ppmu_dmc0: ppmu_dmc0@106a0000 {
+		status = "okay";
+
+		events {
+			ppmu_dmc0_3: ppmu-dmc0-pmcnt3 {
+				event-name = "ppmu-dmc0-pmcnt3";
+			};
+		};
+	};
+
+	ppmu_dmc1: ppmu_dmc1@106b0000 {
+		status = "okay";
+
+		events {
+			ppmu_dmc1_3: ppmu-dmc1-pmcnt3 {
+				event-name = "ppmu-dmc1-pmcnt3";
+		};
+	};
+
 	thermistor-ap@0 {
 		compatible = "ntc,ncp15wb473";
 		pullup-uv = <1800000>;	 /* VCC_1.8V_AP */
-- 
1.8.0

