Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbaCNJa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:30:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20343 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbaCNJaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:30:19 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-f3-5322cc29a5aa
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, b.zolnierkie@samsaung.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 8/8] Documentation: dt: devfreq: Add device tree binding of
 Exynos4 busfreq
Date: Fri, 14 Mar 2014 18:30:08 +0900
Message-id: <1394789408-14648-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
References: <1394789408-14648-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkUFfzjFKwwa0nChYdPb9ZLK5/ec5q
	Mf/IOVaLc69WMlqcbXrDbrGwbQmLxeVdc9gsPvceYbSYcX4fk8XS6xeZLG43rmCzePPjLJPF
	hOlrWSwer3jLbvHqYBuLA7/HmnlrGD1WLv/C5rF4z0smj5/Lt7N79G1Zxehx/MZ2Jo/Pm+Q8
	Ns4NDeCI4rJJSc3JLEst0rdL4MqYd+YBS8FfsYq1TT9YGhjXCncxcnJICJhI3JrXyA5hi0lc
	uLeeDcQWEljKKPG7xaaLkQOs5vnrrC5GLqDwIkaJx2dXs0I4jUwSnZtngzWzCWhJ7H9xA6xZ
	RMBcYtfSn2wgRcwCz5gkbvX3MYFMEhaIl3g+RROkhkVAVeLPg99gvbwCrhLLz+5ggzhCTuLD
	nkdgcU4BN4m3zdMYIQ5ylejrPsAEMlNC4CO7xKe2j2wQgwQkvk0+xAJxqazEpgPMEHMkJQ6u
	uMEygVF4ASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAiDr971nvDsbbB6wPMSYDjZvI
	LCWanA+MyLySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYExgaeC5xvT33OS3K/clXT93K9xVV7slWumu5vfJ93oT++ZdMFrK3XM8ouyZTP5FrV91
	u9bU/fyVX+/+yixsKuuzbYJ7nU47SZrPWPVj0QYXyQP39T7GR8ofTf73LIlzKvftjWrrOr1t
	2hrCpvMeEIr5GK9ufXJF/rotf98L/Try8ne3Utw5wTlKLMUZiYZazEXFiQCuQwlzvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgK7mGaVgg4PHJSw6en6zWFz/8pzV
	Yv6Rc6wW516tZLQ42/SG3WJh2xIWi8u75rBZfO49wmgx4/w+Joul1y8yWdxuXMFm8ebHWSaL
	CdPXslg8XvGW3eLVwTYWB36PNfPWMHqsXP6FzWPxnpdMHj+Xb2f36NuyitHj+I3tTB6fN8l5
	bJwbGsAR1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuW
	mQN0vZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYxY96ZBywFf8Uq1jb9
	YGlgXCvcxcjBISFgIvH8dVYXIyeQKSZx4d56ti5GLg4hgUWMEo/PrmaFcBqZJDo3z2YHqWIT
	0JLY/+IGG4gtImAusWvpT7AOZoFnTBK3+vuYQKYKC8RLPJ+iCVLDIqAq8efBb7BeXgFXieVn
	d7BBbJOT+LDnEVicU8BN4m3zNEYQWwiopq/7ANMERt4FjAyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYIj9pnUDsaVDRaHGAU4GJV4eB0OKwYLsSaWFVfmHmKU4GBWEuFlmKcULMSbklhZ
	lVqUH19UmpNafIgxGeiqicxSosn5wGSSVxJvaGxiZmRpZG5oYWRsTpqwkjjvgVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2M/YYPasV8b4ve1okpembvMSNVrv8M15p9QvP+3Fis7mp9/DL/oq9B
	X0L4Vs11PlxZerPFNVDnbe6UUI4JW+2KU4JvVTLYSgrxK7V6XZngKfTIccVO7Yvvo+Tuvs8s
	0efnDc95ud3xd6TtWbYQ3Yl9h/NetK97yXqxRefkwuOP9x/v8r60X4pXiaU4I9FQi7moOBEA
	tEGa3BwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduce device tree binding for the Exynos4's busfreq driver.
The Exynos4's busfreq driver support DVFS(Dynamic Voltage Frequency Scaling)
of Exynos4 memory bus to optimize power-consumption on runtime state.
Exynos4's busfreq driver need the utilization of memory bus. So, busfreq driver
use PPMU_DMC0/PPMU_DMC1 IP among various PPMU(Performance Profiling Monitoring
Units) which provide the data of read/write counters on memory bus. This driver
adjust the frequency/voltage of memory bus according to PPMU_DMC0/PPMU_DMC1
counters.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 .../devicetree/bindings/devfreq/exynos4_bus.txt    | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/devfreq/exynos4_bus.txt

diff --git a/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
new file mode 100644
index 0000000..bd397ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/devfreq/exynos4_bus.txt
@@ -0,0 +1,50 @@
+
+Exynos4 Memory Bus frequency driver
+-----------------------------------
+
+Exynos4 SoC need Busfreq (Memory Bus frequency) driver to support DVFS (Dynamic
+Voltage Frequency Scaling) of Exynos4 SoC's memory bus. This driver controls
+dynamically the frequency/voltage of memory bus to optimize power-consumption
+of memory bus. When checking the utilization of memory bus, Exynos4's busfreq
+driver uses PPMU_DMC0/PPMU_DMC1 (Performance Profiling Monitoring Units)
+which provide the data of read/write counters on memory bus.
+
+Required properties:
+- compatible	: should contain Exynos4 SoC type as following:
+		  - "samsung,exynos4210-busfreq" for Exynos4210
+		  - "samsung,exynos4x12-busfreq" for Exynos4x12
+- reg		: physical address of PPMU_DMC0/PPMU_DMC1 register and length
+		  for memory mapping
+- clocks	: phandles to clock-controller and clock number of PPMU_DMC0
+		  /PPMU_DMC1
+- clock-names	: clock names for PPMU_DMC0/PPMU_DMC1
+		  - "ppmudmc0" for PPMU_DMC0
+		  - "ppmudmc1" for PPMU_DMC1
+- vdd_int-supply: regulator for interface block of Exynos4 SoC
+
+Optional properties:
+- vdd_mif-supply: regulator for DMC block if using Exynos4x12 SoC
+
+Example:
+For Exynos4210 busfreq,
+
+	busfreq@106A0000 {
+		compatible = "samsung,exynos4210-busfreq";
+		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
+		clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
+		clock-names = "ppmudmc0", "ppmudmc1";
+
+		vdd_int-supply = <&buck3_reg>;
+	};
+
+For Exynos4x12 busfreq,
+
+	busfreq@106A0000 {
+		compatible = "samsung,exynos4x12-busfreq";
+		reg = <0x106A0000 0x2000>, <0x106B0000 0x2000>;
+		clocks = <&clock CLK_PPMUDMC0>, <&clock CLK_PPMUDMC1>;
+		clock-names = "ppmudmc0", "ppmudmc1";
+
+		vdd_int-supply = <&buck3_reg>;
+		vdd_mif-suppy = <&buck1_reg>;
+	};
-- 
1.8.0

