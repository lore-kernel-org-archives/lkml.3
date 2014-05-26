Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaEZG3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 02:29:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49095 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaEZG3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 02:29:46 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-4d-5382df534a6f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: t.figa@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, ben-linux@fluff.org,
        linux@arm.linux.org.uk, l.krishna@samsung.com,
        chanho61.park@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH] ARM: dts: Add pmu sysreg node to Exynos3250
Date: Mon, 26 May 2014 15:29:36 +0900
Message-id: <1401085776-14212-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkWDf4flOwwdn3HBaT1h1gsri8X9vi
	+pfnrBbzj5xjteh/s5DV4tyrlYwWvQuuslmcbXrDbrFzyw02i02Pr7FaLGxbwmJxedccNosZ
	5/cxWdy+zGux9PpFJosJ09eyWLy9M53FonXvEXaL9TNeszgIe6yZt4bRo6W5h83jcl8vk8ff
	VS+YPVYu/8LmsXmFlsemVZ1AxpJ6j74tqxg9Pm+SC+CK4rJJSc3JLEst0rdL4Mo4uPova8El
	noobF1+zNjDu5+pi5OSQEDCRaNq7lQ3CFpO4cG89kM3FISSwlFHizdIWZpiiG8efs0IkFjFK
	dM/7yA7hNDFJvG35yApSxSagJbH/xQ2wUSICkhJNDX+YQYqYBW4zS+y9tZYRJCEsYCOx5cMC
	JhCbRUBV4ujp7WANvAKuEkdmX4daJyfxYc8jsA0SAj/ZJX53v2GGaBCQ+Db5EEsXIwdQQlZi
	0wGoekmJgytusExgFFzAyLCKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzC6Tv971ruD8fYB
	60OMyUDjJjJLiSbnA6MzryTe0NjMyMLUxNTYyNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFF
	pTmpxYcYmTg4pRoYWY4kT+Ve/H/e31aNnQ8sLN9NWGG0O2fx56N2KXZPZtocnNq2scZEVsbF
	m+9KSMFjYd4z8152CR14wfSJ4cq+1rcGKlFHppy7w9h+8q9WVdEkq6IPz18ecZzwfv/iLKuX
	BzjVnhXNn7b4TZa9Tlnq3NZgh/ZJgpYa245Elb540r3q/VSrj+cDpiqxFGckGmoxFxUnAgDq
	CkDwxAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xgG7Q/aZgg8X7rC0mrTvAZHF5v7bF
	9S/PWS3mHznHatH/ZiGrxblXKxktehdcZbM42/SG3WLnlhtsFpseX2O1WNi2hMXi8q45bBYz
	zu9jsrh9mddi6fWLTBYTpq9lsXh7ZzqLReveI+wW62e8ZnEQ9lgzbw2jR0tzD5vH5b5eJo+/
	q14we6xc/oXNY/MKLY9NqzqBjCX1Hn1bVjF6fN4kF8AV1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mJJCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx4+Dqv6wFl3gqblx8zdrAuJ+ri5GTQ0LAROLG8eesELaYxIV769m6
	GLk4hAQWMUp0z/vIDuE0MUm8bfkIVsUmoCWx/8UNNhBbREBSoqnhDzNIEbPAbWaJvbfWMoIk
	hAVsJLZ8WMAEYrMIqEocPb0drIFXwFXiyOzrzBDr5CQ+7HnEPoGRewEjwypG0dSC5ILipPRc
	I73ixNzi0rx0veT83E2M4Nh9Jr2DcVWDxSFGAQ5GJR7eA95NwUKsiWXFlbmHGCU4mJVEeC/k
	AoV4UxIrq1KL8uOLSnNSiw8xJgNtn8gsJZqcD0wreSXxhsYmZkaWRuaGFkbG5qQJK4nzHmy1
	DhQSSE8sSc1OTS1ILYLZwsTBKdXA6Oq6OkP0lz0L1/1wh+c3Vq2PTLjq7KSqJdx+e7voR20V
	u2WOu1+mh8R/1Ey3OO6wYv6dNr0DdiI7uESvprmIPqt7PbWmJS76z3a7J8EiLSUdqYLXGU0M
	jmTqt2VN5d9wbaWzwZ/TIW7TXRP0GarTD1Zdndi2tH/1imMm0jcuKeSrel6rsfRWYinOSDTU
	Yi4qTgQAW+Ff8iEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add pmusysreg node for Exynos3250 to access PMU (Power Management Unit)
register in a centralized way using syscon driver.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/devicetree/bindings/arm/samsung/pmu.txt | 1 +
 arch/arm/boot/dts/exynos3250.dtsi                     | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
index b562634..2a4ab04 100644
--- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
@@ -2,6 +2,7 @@ SAMSUNG Exynos SoC series PMU Registers
 
 Properties:
  - compatible : should contain two values. First value must be one from following list:
+		   - "samsung,exynos3250-pmu" - for Exynos3250 SoC,
 		   - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
 		   - "samsung,exynos4212-pmu" - for Exynos4212 SoC,
 		   - "samsung,exynos4412-pmu" - for Exynos4412 SoC,
diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index ca28eac..3e678fa 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -125,6 +125,11 @@
 			reg = <0x10010000 0x400>;
 		};
 
+		pmu_system_controller: system-controller@10020000 {
+			compatible = "samsung,exynos3250-pmu", "syscon";
+			reg = <0x10020000 0x4000>;
+		};
+
 		pd_cam: cam-power-domain@10023C00 {
 			compatible = "samsung,exynos4210-pd";
 			reg = <0x10023C00 0x20>;
-- 
1.8.0

