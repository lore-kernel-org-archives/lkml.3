Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaDBHrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 03:47:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026AbaDBHqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 03:46:23 -0400
X-AuditID: cbfee68e-b7f566d000002344-22-533bc02b1f20
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        chow.kim@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 2/3] ARM: dts: Add PMU reg node to exynos4212 and exynos4412
Date: Wed, 02 Apr 2014 17:02:57 +0900
Message-id: <1396425778-4379-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zQ13tA9bBBlOuGFssm3SXzWL+kXOs
	Fv1vFrJanHu1ktGid8FVNotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYtHWL+wWE6avZbFo
	3XuE3YHXY828NYweLc09bB6X+3qZPFYu/8LmsWlVJ5vH5iX1Hn1bVjF6fN4kF8ARxWWTkpqT
	WZZapG+XwJWx72A3c8Emzoptu3rYGxi/sHcxcnJICJhIHPr7kQXCFpO4cG89WxcjF4eQwDJG
	iaerDjPCFC24fYgFIjGdUeLsjAfMEE4bk8Tc6R+YQKrYBHQlnryfC5YQEWhnlHhyeR0jiMMs
	8JJR4uuviWBVwgI+EvPvvgCzWQRUJV6cegG2nFfAXaJpewtQAwfQPgWJOZNsQMKcAh4Sz5Yc
	BSsXAip5segOO8hMCYF77BKrt0xnhZgjIPFtMsh9IL2yEpsOMEOcLSlxcMUNlgmMwgsYGVYx
	iqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihERQ3w7GmwesDzEmA42byCwlmpwPjMC8knhDYzMj
	C1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4hmVHjnD6TP/G
	4MwCpfa1FVOYbxy3e266W/7sw2Ytroh8p1pjgYcRXukr7ZeYpn4PtmV8cuTMlFkf7BjkVA03
	8+x5rrjsde32f3vvsCra3us2/qrYsDP61NGfBckB2tWHfh6z2SKfyTdl4crMiMP//PUsD3nW
	i59qbe+09HObsbNhfZjlp2glluKMREMt5qLiRACKS9xWtgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoK72Aetgg10r9C2WTbrLZjH/yDlW
	i/43C1ktzr1ayWjRu+Aqm8Wmx9dYLS7vmsNmMeP8PiaL25d5LZZev8hksWjrF3aLCdPXsli0
	7j3C7sDrsWbeGkaPluYeNo/Lfb1MHiuXf2Hz2LSqk81j85J6j74tqxg9Pm+SC+CIamC0yUhN
	TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
	kFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYse9gN3PBJs6Kbbt62BsYv7B3MXJySAiY
	SCy4fYgFwhaTuHBvPVsXIxeHkMB0RomzMx4wQzhtTBJzp39gAqliE9CVePJ+LlhCRKCdUeLJ
	5XWMIA6zwEtGia+/JoJVCQv4SMy/+wLMZhFQlXhx6gXYDl4Bd4mm7S1ADRxA+xQk5kyyAQlz
	CnhIPFtyFKxcCKjkxaI77BMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7PZ9I7
	GFc1WBxiFOBgVOLhPXDeKliINbGsuDL3EKMEB7OSCC/nJOtgId6UxMqq1KL8+KLSnNTiQ4zJ
	QEdNZJYSTc4Hpo68knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCU
	amCcvvHIihMHFe0+yIkwz5tjOXUyH4Nr05rOW0y5HOumbbRbkP55bf4VLwPnS2wnp+ql9ihp
	c17l3T01w6OM13tXnLX9tzeqq5MMPDS/3dn6QKKBq3DBh+7lpzu3x5S09Mx2alnK9/3XW3fR
	vJ1b1yhdCPPTbEpkvvU0POSKYuQh/faSO1KVKyOVWIozEg21mIuKEwE7gkYqEwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pmu regnode to exynos4212 and exynos4412 dtsi to
handle PMU register access via DT.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/boot/dts/exynos4212.dtsi |    5 +++++
 arch/arm/boot/dts/exynos4412.dtsi |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 3c00e6e..4661ffa 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -29,4 +29,9 @@
 	gic: interrupt-controller@10490000 {
 		cpu-offset = <0x8000>;
 	};
+
+	pmu_system_controller: system-controller@10020000 {
+		compatible = "samsung,exynos4212-pmu", "syscon";
+		reg = <0x10020000 0x5000>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4412.dtsi b/arch/arm/boot/dts/exynos4412.dtsi
index 15d3c0a..6f4cb22 100644
--- a/arch/arm/boot/dts/exynos4412.dtsi
+++ b/arch/arm/boot/dts/exynos4412.dtsi
@@ -29,4 +29,9 @@
 	gic: interrupt-controller@10490000 {
 		cpu-offset = <0x4000>;
 	};
+
+	pmu_system_controller: system-controller@10020000 {
+		compatible = "samsung,exynos4412-pmu", "syscon";
+		reg = <0x10020000 0x5000>;
+	};
 };
-- 
1.7.10.4

