Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaDYLie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:38:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35027 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaDYLgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:36:38 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-f3-535a48c4c4a5
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Guenter Roeck <linux@roeck-us.net>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 5/5] Documentation: update samsung pmu binding information
Date: Fri, 25 Apr 2014 20:54:17 +0900
Message-id: <1398426857-5097-6-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
 <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t8zQ90jHlHBBq9eC1gsm3SXzWL+kXOs
	Fr0LrrJZ7Nxyg81i0+NrrBaXd81hs5hxfh+TxZOFZ5gsFm39wm6x7uV0FovWvUfYLdbPeM1i
	saNlNYsDr8emVZ1sHq9Wz2T12Lyk3mPn9wZ2j74tqxg9Pm+SC2CL4rJJSc3JLEst0rdL4Mr4
	9eQRS0E3T8WJRScYGxg7uboYOTkkBEwk/l9fyQhhi0lcuLeeDcQWEljGKPFuvRtMzZ2nn1i6
	GLmA4osYJea9eAbltDFJvD3RxA5SxSagK/Hk/VxmkISIQDujxL+rD9lAHGaByUwStxatZgGp
	Ehbwldh6oBVsB4uAqkTnk/nMIDavgLvEhbvzWLsYOYD2KUjMmWQDEuYU8JA4P2MdO8S2VqCh
	cz5D3XqNXeLDVgWIOQIS3yYfYoHolZXYdIAZokRS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLR
	K07MLS7NS9dLzs/dxAiJlgk7GO8dsD7EmAw0biKzlGhyPjDa8kriDY3NjCxMTUyNjcwtzUgT
	VhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcU697I6rnzn95165yerE5fFwXsyJ
	iXk9d11m8ln/Wighu3aP/5EMff71Drnmlcfn8UzaK8KgtFeoXN43VzF81tTZM1qe8/58yLpC
	uErl36M5C273rLl3KHd5Wudx25tyilZlB3+c9OXN/XZk4rQLCVFOFQ/3s2gvydN+mzc37tWO
	z5Uhiwo/nlBiKc5INNRiLipOBADLjRT0rAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAd0jHlHBBttn8Vgsm3SXzWL+kXOs
	Fr0LrrJZ7Nxyg81i0+NrrBaXd81hs5hxfh+TxZOFZ5gsFm39wm6x7uV0FovWvUfYLdbPeM1i
	saNlNYsDr8emVZ1sHq9Wz2T12Lyk3mPn9wZ2j74tqxg9Pm+SC2CLamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6VEmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMeY8evJI5aCbp6KE4tOMDYwdnJ1MXJySAiYSNx5+okFwhaT
	uHBvPVsXIxeHkMAiRol5L56xQDhtTBJvTzSxg1SxCehKPHk/lxkkISLQzijx7+pDsBZmgclM
	ErcWrQabJSzgK7H1QCsbiM0ioCrR+WQ+M4jNK+AuceHuPNYuRg6gfQoScybZgIQ5BTwkzs9Y
	xw6xrRVo6JzPjBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7HZ9I7GFc1WBxi
	FOBgVOLhnSAbGSzEmlhWXJl7iFGCg1lJhLfdNSpYiDclsbIqtSg/vqg0J7X4EGMy0FUTmaVE
	k/OBqSKvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgTDD/F
	GK968Pf+4nc/p+17Yrm9un9a4fJvO5bvmat98mC155EDh7rzn/4SOzynY4Xv/7CmvFMSq8tl
	th+b7Gk6LzST7faShcIxP5b4LJS/5b80LeG4XWpc15+DUxMrRTUPyO6c7Zi/NoL13Pnngpl+
	FqwvzZ+tNEg7kzUx9a9908WqtT0LJn12VmIpzkg01GIuKk4EAHcD9aMLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates samsung pmu (power management unit) binding information.

CC: Leela Krishna Amudala <l.krishna@samsung.com>
CC: Guenter Roeck <linux@roeck-us.net>
CC: Rob Landley <rob@landley.net>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 Documentation/devicetree/bindings/arm/samsung/pmu.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/samsung/pmu.txt b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
index f1f1552..ac9b45c 100644
--- a/Documentation/devicetree/bindings/arm/samsung/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/pmu.txt
@@ -2,14 +2,21 @@ SAMSUNG Exynos SoC series PMU Registers
 
 Properties:
  - compatible : should contain two values. First value must be one from following list:
+		   - "samsung,exynos4210-pmu" - for Exynos4210 SoC,
+		   - "samsung,exynos4212-pmu" - for Exynos4212 SoC,
+		   - "samsung,exynos4412-pmu" - for Exynos4412 SoC,
 		   - "samsung,exynos5250-pmu" - for Exynos5250 SoC,
 		   - "samsung,exynos5420-pmu" - for Exynos5420 SoC.
 		second value must be always "syscon".
 
  - reg : offset and length of the register set.
 
+ - samsung,syscon-phandle : reference to syscon node. This property points to syscon node
+		holding the PMU base address.
+
 Example :
 pmu_system_controller: system-controller@10040000 {
 	compatible = "samsung,exynos5250-pmu", "syscon";
 	reg = <0x10040000 0x5000>;
+	samsung,syscon-phandle = <&pmu_system_controller>;
 };
-- 
1.7.10.4

