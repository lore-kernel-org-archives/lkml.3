Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134AbaDJKQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:16:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24382 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbaDJKGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:32 -0400
X-AuditID: cbfee690-b7f266d00000287c-d4-53466d260264
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 25/27] ARM: dts: exynos3250: Add RTC dt node
Date: Thu, 10 Apr 2014 19:06:15 +0900
Message-id: <1397124377-16969-17-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkRFct1y3Y4N0FLYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mr4P+cSW0EHR8Wan7MYGxjPsXUxcnJICJhI7F7W
	zwxhi0lcuLceKM7FISSwlFGiq/sHK0zRzrPrwWwhgUWMEle3SEIUNTFJfGraxQSSYBPQktj/
	4gbYVBGBAIkfx9+B2cwCNxkljr0PA7GFBWwkZi+4x9LFyMHBIqAq8bWhCCTMK+AmseNAF9RB
	chIf9jxiB7E5geIzF51kg9jrKtHz6CIzyF4JgWXsEu9WLgLbyyIgIPFt8iGwmRICshKbDkA9
	IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBIb96X/PJuxgvHfA+hBj
	MtC4icxSosn5wLjJK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q
	8SFGJg5OqQbGrOZbTJcslR1ffFix7FysSOWnC9JFnip9ipu7KsLfvM0Q6vKtr8kR2LPUcsLf
	9D/V/SVzmP8bGtrIuJjw/BCZqhDhXvg/67Tw1cbwziluyUuVcx5YZ54/XDXtavMJj9PZy898
	6Ej0PBXUv0bK8HmlDVtXa3Xrqrne2cbhv7eo9KxZUr/hymQlluKMREMt5qLiRAClRwkGkQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV21XLdgg0kzlS2uf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxv85l9gK
	Ojgq1vycxdjAeI6ti5GTQ0LARGLn2fWsELaYxIV768HiQgKLGCWubpHsYuQCspuYJD417WIC
	SbAJaEnsf3EDrEhEIEDix/F3YDazwE1GiWPvw0BsYQEbidkL7rF0MXJwsAioSnxtKAIJ8wq4
	Sew40AW1V07iw55H7CA2J1B85qKTUHtdJXoeXWSewMi7gJFhFaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwVD2T2sG4ssHiEKMAB6MSD++BZa7BQqyJZcWVuYcYJTiYlUR4d2e6BQvxpiRW
	VqUW5ccXleakFh9iTAY6aiKzlGhyPjDi80riDY1NzIwsjcwNLYyMzUkTVhLnPdBqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBMf99B9NkyYiijtR5T4PcC78fuZLw91hnmb6qbbHlb+t5qwwsJwY8
	efGH6cjiskSLSR+PNBQpb3iocfHrjoCF9rKJelu3cU35GR38LeLJfMU7YoZLlZ8G/GCeb6t3
	zTFIMcLnlNv1grfMNnNmnSjw0xadpvH9gwybyn/715cXzM081PxN6VLhZCWW4oxEQy3mouJE
	ADjz9dnuAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

This patch add rtc dt node for Real Time Clock (RTC) which operates with
a backup battery when the system is off and performs the function of an alarm.

Exynos3250's RTC has following rtc interrupt
- ALARM_INT (alarm interrupt)
- ALAREM_WK (alarm wake-up)

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index c8bd33cf..a61940f 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -88,6 +88,13 @@
 		#clock-cells = <1>;
 	};
 
+	rtc@10070000 {
+		compatible = "samsung,s3c6410-rtc";
+		reg = <0x10070000 0x100>;
+		interrupts = <0 73 0>, <0 74 0>;
+		status = "disabled";
+	};
+
 	gic: interrupt-controller@10481000 {
 		compatible = "arm,cortex-a7-gic";
 		#interrupt-cells = <3>;
-- 
1.8.0

