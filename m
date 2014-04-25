Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbaDYLgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:36:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38679 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaDYLge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:36:34 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-42-535a48c1aed0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 2/5] ARM: dts: Add PMU node to exynos4210
Date: Fri, 25 Apr 2014 20:54:14 +0900
Message-id: <1398426857-5097-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
References: <1396425778-4379-1-git-send-email-pankaj.dubey@samsung.com>
 <1398426857-5097-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e+Zoe5Bj6hgg9V71SyWTbrLZjH/yDlW
	i94FV9ksNj2+xmpxedccNosZ5/cxWSza+oXdonXvEXaL9TNes1jsaFnN4sDlsWlVJ5vH5iX1
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVxY/c6xoIdbBXbvpU2MK5l7WLk5JAQMJE43r2E
	EcIWk7hwbz1bFyMXh5DAMkaJDQu2M8MU3VjdzQKRWMQo0XV0OhOE08YksXX7Z7B2NgFdiSfv
	5zKDJEQE2hkl/l19CDaLWWAuo0Rz+wV2kCphARuJXysnsoDYLAKqEj+/nWIDsXkF3CU6N58A
	msQBtE9BYs4kG5Awp4CHxPkZ69ghtrUCDZ0Dso0LqGYdu8S0g/uZIQYJSHybfIgFollWYtMB
	qLslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYyQ4O/dwXj7gPUhxmSg
	cROZpUST84HRk1cSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjFebcyJKhEyPOtmpCe1mDP5wPbH7j+rsm7muk0XPV5yezvBpTuBZ5zMuyvpx3Meq
	jQv8CvJ/P0lM0oifqxHytYN7glDw/bADm6sKVat8zL/6G3xn0C5V/XtMMzN3w45An1PPDtf8
	MHwoyv7Ke865lUtvbg4Sbe9qFz1jvvOa7AKVn78/L9z4TomlOCPRUIu5qDgRAKzcao6UAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAd2DHlHBBn+eKlksm3SXzWL+kXOs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jsli09Qu7ReveI+wW62e8ZrHY0bKaxYHLY9OqTjaPzUvq
	Pfq2rGL0+LxJLoAlqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxo3d6xgL
	drBVbPtW2sC4lrWLkZNDQsBE4sbqbhYIW0ziwr31bF2MXBxCAosYJbqOTmeCcNqYJLZu/8wI
	UsUmoCvx5P1cZpCEiEA7o8S/qw/BWpgF5jJKNLdfYAepEhawkfi1ciLYXBYBVYmf306xgdi8
	Au4SnZtPAE3iANqnIDFnkg1ImFPAQ+L8jHXsENtagYbO+cw4gZF3ASPDKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYzg2HomtYNxZYPFIUYBDkYlHt4PapHBQqyJZcWVuYcYJTiYlUR4212j
	goV4UxIrq1KL8uOLSnNSiw8xJgNdNZFZSjQ5Hxj3eSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1
	DhQSSE8sSc1OTS1ILYLZwsTBKdXAuF2v7NDCqNYv/d8cLBdOtjiSZxqm3HHy5fSjflOrZflX
	31I5oKJ+/Z2BY+G6o+UrK6uDtj+03vqbW9bCxVm0nmuSQoi38rlCa8/ADYWF1/XELghN/Jmg
	9u/P9adJcblpb0zjj80/8kqa47NYw6WWq6tksj7uvlKX48ru/MNxEscEYfYtixbfV2Ipzkg0
	1GIuKk4EAF7wAmvxAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pmu regnode to exynos4210 dtsi to handle
PMU register access via DT.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/boot/dts/exynos4210.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index cacf614..042b6d9 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -81,6 +81,12 @@
 		interrupts = <2 2>, <3 2>;
 	};
 
+	pmu_system_controller: system-controller@10020000 {
+		compatible = "samsung,exynos4210-pmu", "syscon";
+		reg = <0x10020000 0x5000>;
+		samsung,syscon-phandle = <&pmu_system_controller>;
+	};
+
 	pinctrl_0: pinctrl@11400000 {
 		compatible = "samsung,exynos4210-pinctrl";
 		reg = <0x11400000 0x1000>;
-- 
1.7.10.4

