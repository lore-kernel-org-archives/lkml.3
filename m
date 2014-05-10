Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbaEJG2U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:28:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13803 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaEJG2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:28:12 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-57-536dc6fae739
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 2/3] ARM: dts: Add PMU node to exynos4212 and exynos4412
Date: Sat, 10 May 2014 15:46:24 +0900
Message-id: <1399704385-12508-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704385-12508-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704385-12508-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t8zI91fx3KDDU5etrFYNukum8X8I+dY
	LXoXXGWz2PT4GqvF5V1z2CxmnN/HZLFo6xd2i9a9R9gt1s94zWKxo2U1iwOXx6ZVnWwem5fU
	e/RtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfGvoPdzAWbOCu27ephb2D8wt7FyMkhIWAiMbHx
	HhOELSZx4d56NhBbSGAZo8SfuYkwNQeXLwKKcwHFFzFKzFu7ixmiqI1Jov2yD4jNJqAr8eT9
	XGaQIhGBdkaJf1cfgnUwC8xllGhuvwC2TljAW2LD7y1g3SwCqhJr/s1lAbF5BTwkFq94DFTD
	AbROQWLOJBuQMKeAp8TGj4tZIJZ5SOxoOcQKMlNCYB27xKurBxgh5ghIfJt8iAWiV1Zi0wFm
	iKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYyQwJ+4g/H+AetDjMlA
	4yYyS4km5wMjJ68k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGBdxJT9YmfHlVghv25zNrZujNx5YxCyT9uiF0LIZkre/HTJbM6NITaV0zcrWsyoy
	fQZTrogdc9vkPe335fN9hj5iBiX/q//6vPWKPpavZf77rMnLO7eNn268Wvc4ppRX68f6Dfox
	Xc9/O9mof+dfusU0+5aFycEb0j+Vy1pnHVl8e0uT58H7TLeUWIozEg21mIuKEwGMVDWukgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAd1fx3KDDeY2Wlgsm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxr6D3cwF
	mzgrtu3qYW9g/MLexcjJISFgInFw+SI2CFtM4sK99UA2F4eQwCJGiXlrdzGDJIQE2pgk2i/7
	gNhsAroST97PZQYpEhFoZ5T4d/UhWAezwFxGieb2C2BjhQW8JTb83gLWzSKgKrHm31wWEJtX
	wENi8YrHQDUcQOsUJOZMsgEJcwp4Smz8uJgFYpmHxI6WQ6wTGHkXMDKsYhRNLUguKE5KzzXU
	K07MLS7NS9dLzs/dxAiOrGdSOxhXNlgcYhTgYFTi4S14mxMsxJpYVlyZe4hRgoNZSYR3xcHc
	YCHelMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB0Z9Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1qt
	A4UE0hNLUrNTUwtSi2C2MHFwSjUweiVUfTtgdurK7IhPix6KXGy+7c1QxK1gdz/v6ozsAN27
	tzklm5cLWy3dP3vzaYXOy1tyAv1k46W+fImXaz304e8nc5NyQW5GNYPPKh/jvPO9gm/ceGif
	FNKzXb5q9WKpKOeDRTOFq0wdJ+Tdm3c64NWZj2dPs4mG2Osa31b8Ex/Ztpk94QyDEktxRqKh
	FnNRcSIAZEdFbvACAAA=
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

