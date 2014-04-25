Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaDYLgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:36:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62243 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaDYLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:36:34 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-38-535a48c008da
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 1/5] ARM: dts: Add syscon handle in pmu node for exynos5250
Date: Fri, 25 Apr 2014 20:54:13 +0900
Message-id: <1398426857-5097-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
 <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+Zge4Bj6hgg/7zJhbLJt1ls5h/5Byr
	Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLBZt/cJu0br3CLvF+hmvWSx2tKxmceDy2LSqk81j85J6
	j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MpYs+wve8Fx1opZX54zNTDeYOli5OSQEDCRWH+2
	kQ3CFpO4cG89kM3FISSwjFFi3olnbDBFMx53s0IkFgElnl5hhnDamCRebXjFDlLFJqAr8eT9
	XLCEiEA7o8S/qw/BZjELzGWUaG6/AFYlLOAncXPTQrC5LAKqEmfndzCD2LwC7hL/ty0H2sEB
	tE9BYs4kG5Awp4CHxPkZ69ghtrUCDZ3zmRHEkRBYxy4x9dwCZohBAhLfJh9igWiWldh0gBni
	bkmJgytusExgFF7AyLCKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIyT8e3cw3j5gfYgxGWjc
	RGYp0eR8YPzklcQbGpsZWZiamBobmVuakSasJM6b9DApSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAOj9TZxiZLozF9/zm6aJMkVxSf3VdWA4clCzwMX/2959p33svqZwmtznsxOfnA1qvPa
	/EOn90ify0l+qPlhmnLCl1sWHycvnDt1q6lteC7Lij8nPB5vuNP61M/DMi3u1P9vqi3HT7oe
	+PPkrJzbjcDJXfP2yse1LbzkkXCqSK3BuUZs9kztSrVp/EosxRmJhlrMRcWJAObf0FKVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jAd0DHlHBBv9fGVgsm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxpplf9kL
	jrNWzPrynKmB8QZLFyMnh4SAicSMx92sELaYxIV769m6GLk4hAQWMUrMe3qFGcJpY5J4teEV
	O0gVm4CuxJP3c8ESIgLtjBL/rj4Ea2EWmMso0dx+AaxKWMBP4uamhWwgNouAqsTZ+R3MIDav
	gLvE/23LgfZxAO1TkJgzyQYkzCngIXF+xjp2iG2tQEPnfGacwMi7gJFhFaNoakFyQXFSeq6h
	XnFibnFpXrpecn7uJkZwdD2T2sG4ssHiEKMAB6MSD+8HtchgIdbEsuLK3EOMEhzMSiK87a5R
	wUK8KYmVValF+fFFpTmpxYcYk4GumsgsJZqcD4z8vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7Ra
	BwoJpCeWpGanphakFsFsYeLglGpgtM2bsGJ9pcn8h0d371xq+IrjwR/byj83Prz7EHXOL2OL
	qppKaXLH4jdH+v6c9GCcJeLCs0LqWag814Odz/W27dr52sRXr39RzUTWHYXJizwyOWVZu99m
	+EkoOy7Ik+m6bnlEueFe6Jq5F4x/3ZzW5fXa+Io8+9xpP0ReGR6aWTqxc2vKTrv7M5VYijMS
	DbWYi4oTATaKhPryAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add "samsung,syscon-phandle" property pointing to PMU node
to access PMU register via PMU regmap handle.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 3742331..52801af 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -173,6 +173,7 @@
 	pmu_system_controller: system-controller@10040000 {
 		compatible = "samsung,exynos5250-pmu", "syscon";
 		reg = <0x10040000 0x5000>;
+		samsung,syscon-phandle = <&pmu_system_controller>;
 	};
 
 	watchdog@101D0000 {
-- 
1.7.10.4

