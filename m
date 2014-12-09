Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaLIOQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:16:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:11064 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaLIONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:13 -0500
X-AuditID: cbfee68d-f79296d000004278-0b-54870374db66
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 7/7] ARM: dts: exynos: Add PPMU dt node to
 Exynos3250-based Rinato board
Date: Tue, 09 Dec 2014 23:13:06 +0900
Message-id: <1418134386-14681-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWyRsSkULeEuT3EoKVb3+LxmsVMFhtnrGe1
	uP7lOavF/CPnWC1evzC06F1wlc3ibNMbdotNj6+xWlzeNYfN4nPvEUaLGef3MVncblzBZvF4
	xVt2i1W7/jA68HnsnHWX3WPxnpdMHpuX1Hv0bVnF6PF5k1wAaxSXTUpqTmZZapG+XQJXxpEr
	c5kKOnkr7lxoY25g3MLVxcjJISFgItF5cAkrhC0mceHeejYQW0hgKaPEpLdyMDV3Zkxl72Lk
	AoovYpRY9e8oC4TTxCTxZtdusG42AS2J/S9ugHWLCFhJnP7fwQxSxCxwnkliycL9QA4Hh7BA
	gsTTBhaQGhYBVYmNR9czgYR5BVwlbnaKQSxTkFi2fCbYSE4BN4mm3Y0sEAe5Snw40Qp2hITA
	KXaJy7/Os0PMEZD4NvkQC8gcCQFZiU0HmCHmSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFhnrF
	ibnFpXnpesn5uZsYgXFy+t+z3h2Mtw9YH2IU4GBU4uHVsGwLEWJNLCuuzD3EaAq0YSKzlGhy
	PjAa80riDY3NjCxMTUyNjcwtzZTEeRWlfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNSv
	Elg9VelT363rRwMe2a01vKl17uz3zb4nr2RWzi3MfR3x6qQ3nw/3vJoOr9X7Z2n5/i6+cz/8
	fMCM/AWci9c4lfFbl1/9e+fyh3L52Pt/NLQes79XFzNK8eB0luVyP7UhbtH1SzbXVv2K3WDy
	aV4kt93j1Wu+/r544/iVPrlPlicrV0ucSghXYinOSDTUYi4qTgQAJG+Hzo4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t9jAd0S5vYQg/Ot6haP1yxmstg4Yz2r
	xfUvz1kt5h85x2rx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8niduMKNovH
	K96yW6za9YfRgc9j56y77B6L97xk8ti8pN6jb8sqRo/Pm+QCWKMaGG0yUhNTUosUUvOS81My
	89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgA5VUihLzCkFCgUkFhcr6dthmhAa
	4qZrAdMYoesbEgTXY2SABhLWMGYcuTKXqaCTt+LOhTbmBsYtXF2MnBwSAiYSd2ZMZYewxSQu
	3FvP1sXIxSEksIhRYtW/oywQThOTxJtdu1lBqtgEtCT2v7jBBmKLCFhJnP7fwQxSxCxwnkli
	ycL9QA4Hh7BAgsTTBhaQGhYBVYmNR9czgYR5BVwlbnaKQSxTkFi2fCbYSE4BN4mm3Y1g5UJA
	JR9OtLJPYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Dp9J7WBc2WBxiFGAg1GJ
	h1fTsi1EiDWxrLgy9xCjBAezkgjvlKNAId6UxMqq1KL8+KLSnNTiQ4ymQEdNZJYSTc4Hpoi8
	knhDYxMzI0sjc0MLI2NzJXFeJXugJoH0xJLU7NTUgtQimD4mDk6pBkbefpOoezV7d0zce9Y3
	+tIMgQ/SayqdPHZcYTmxXOhfatPiyBlnGSs/HdzWbNk9wfRcZMWN44GXLlXOPVih19epyvoi
	3v8Zl+yJvb8NLc9mnlA9mnaXvVYkwaT0NcfT/uWvpsxzUb8+Yd6u7j/fPq5QjbFv/9J4jdeR
	yfLLJN7b+iFMZd6Su6WUWIozEg21mIuKEwH5kB5r2QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU dt node to Exynos3250-base Rinato board. The PPMU dt node
is used to get the utilization of DMC0/DMC1/CPU Block.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 55 +++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 7789442..9a0ffe4 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -542,6 +542,61 @@
 	status = "okay";
 };
 
+&ppmu_cpu {
+	status = "okay";
+
+	events {
+		ppmu_cpu_0: ppmu-cpu-pmcnt0 {
+			event-name = "ppmu-cpu-pmcnt0";
+		};
+
+		ppmu_cpu_1: ppmu-cpu-pmcnt1 {
+			event-name = "ppmu-cpu-pmcnt1";
+		};
+
+		ppmu_cpu_2: ppmu-cpu-pmcnt2 {
+			event-name = "ppmu-cpu-pmcnt2";
+		};
+
+		ppmu_cpu_3: ppmu-cpu-pmcnt3 {
+			event-name = "ppmu-cpu-pmcnt3";
+		};
+	};
+};
+
+&ppmu_dmc0 {
+	status = "okay";
+
+	events {
+		ppmu_dmc0_0: ppmu-dmc0-pmcnt0 {
+			event-name = "ppmu-dmc0-pmcnt0";
+		};
+
+
+		ppmu_dmc0_1: ppmu-dmc0-pmcnt1 {
+			event-name = "ppmu-dmc0-pmcnt1";
+		};
+
+		ppmu_dmc0_2: ppmu-dmc0-pmcnt2 {
+			event-name = "ppmu-dmc0-pmcnt2";
+		};
+
+		ppmu_dmc0_3: ppmu-dmc0-pmcnt3 {
+			event-name = "ppmu-dmc0-pmcnt3";
+		};
+	};
+};
+
+&ppmu_dmc1 {
+	status = "okay";
+
+	events {
+		ppmu_dmc1_3: ppmu-dmc1-pmcnt3 {
+			event-name = "ppmu-dmc1-pmcnt3";
+		};
+	};
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

