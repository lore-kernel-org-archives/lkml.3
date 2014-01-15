Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaAOJQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:16:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21264 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaAOJQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:16:26 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-84-52d651e95f53
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 6/8 v4] ARM: dts: exynos5250/5420: add dt node for sss module
Date: Wed, 15 Jan 2014 14:46:37 +0530
Message-id: <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkSvdl4LUgg2NH2C1eHtK06H4lY9G7
	4Cqbxf17P5ksLu+aw2Yx4/w+JotF2/4zW6za9YfR4uycQ0wOnB47Z91l99h2QNWjb8sqRo/P
	m+QCWKK4bFJSczLLUov07RK4Mi40rGMuOMdT8fj5HqYGxu1cXYycHBICJhJ/vk9gg7DFJC7c
	Ww9kc3EICSxllPh0/jAbTNHpie2sEIlFjBL73y2AqupnkujeepEZpIpNwEzi4KLV7CC2iICz
	xO/mNWAdzAIHGCXWTT8FNkpYwFdi2bbjYDaLgKrEx9ZTLCA2r4CrRPOGBYxdjBxA6xQk5kyy
	AQlzCrhJbL38BGymEFDJnBNXmSEuWsYu8aSNE2KMgMS3yYdYIFplJTYdgCqRlDi44gbLBEbh
	BYwMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECQ/30v2cTdzDeP2B9iDEZaNxEZinR5Hxg
	rOSVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6OY
	zu1V79Wck7qe201ynLx13k/fDr3AO4bHtlTe4bqV+PjYnJ+T2uRX/5Cf5vllVtX+BYIPlR7r
	X9q/RqTprdcey6lrKt+aBcqWP2bhldn22Xilxs0qwaXma3kSORh6tieVvTq0bQfXpMx9WT9N
	VO+HW17ZMN+wO/7jssANzq/8IrLFbfdf26utxFKckWioxVxUnAgAG4NfsosCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd2XgdeCDE6wWrw8pGnR/UrGonfB
	VTaL+/d+Mllc3jWHzWLG+X1MFou2/We2WLXrD6PF2TmHmBw4PXbOusvuse2AqkffllWMHp83
	yQWwRDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA
	HaKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzLjQsI654BxPxePne5ga
	GLdzdTFyckgImEicntjOCmGLSVy4t56ti5GLQ0hgEaPE/ncLoJx+JonurReZQarYBMwkDi5a
	zQ5iiwg4S/xuXsMKUsQscIBRYt30U2wgCWEBX4ll246D2SwCqhIfW0+xgNi8Aq4SzRsWMHYx
	cgCtU5CYM8kGJMwp4Cax9fITsJlCQCVzTlxlnsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcCQ9k9rBuLLB4hCjAAejEg/vj/CrQUKsiWXFlbmHGCU4mJVEeKV8rgUJ8aYkVlal
	FuXHF5XmpBYfYkwGOmois5Rocj4wyvNK4g2NTcxNjU0tTSxMzCxJE1YS5z3Qah0oJJCeWJKa
	nZpakFoEs4WJg1OqgbHSTfuyvNhSKemr7Ps+fg356SQwP7jK//bbvQ8luJfGHJpxafPfyBX+
	eY+6lgSXZYUXLl3StLp933SOB4Yv57z/N/d1vZl/+lklKf+9+fPXrU4+HaYz2/yV6h4/BYVl
	lxckLpKNWah0Xi4m/35vSF5S7OyNNX+COAuK3PSuLntiIqv5ekIz0wQlluKMREMt5qLiRAAp
	J47e6AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for SSS module
found on Exynos5420 and Exynos5250

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
TO: <linux-samsung-soc@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: <linux-crypto@vger.kernel.org>
---
Changes since v3:
1. Modified the SSS clock ID as per dt-bindings for Exynos5250 in
   samsung-clk.git tree.

 arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
 arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index c341e55..1d249df 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -704,4 +704,12 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 348>;
+		clock-names = "secss";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 11dd202..56a3f3e 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -652,4 +652,14 @@
 		clocks = <&clock 319>, <&clock 318>;
 		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
 	};
+
+	sss@10830000 {
+		compatible = "samsung,exynos4210-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+		samsung,power-domain = <&g2d_pd>;
+	};
+
 };
-- 
1.7.9.5

