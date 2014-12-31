Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaLaFVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:21:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:23020 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaLaFUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:20:04 -0500
X-AuditID: cbfee68f-f791c6d000004834-30-54a3877b487b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 7/8] ARM: dts: Add memory bus node for Exynos3250-based
 Rinato board
Date: Wed, 31 Dec 2014 14:19:51 +0900
Message-id: <1420003192-5576-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
References: <1420003192-5576-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplkeLIzCtJLcpLzFFi42JZI2JSrFvdvjjEYOF/UYvHaxYzWWycsZ7V
	4vqX56wWk+5PYLF4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Sx9PpFJovb
	jSvYLB6veMtusWrXH0YHfo8189YweuycdZfdY/Gel0wem5fUe/RtWcXo8XmTXABbFJdNSmpO
	Zllqkb5dAlfGneftzAX7OCtmty1hbmBs5ehi5OSQEDCRWLJ1ASOELSZx4d56ti5GLg4hgaWM
	En1ztjPCFP0+e4cJIrGIUeL0zCZGCKeJSWLKraksIFVsAloS+1/cYAOxRQRkJK5u3M4CUsQs
	8J9J4vGr5axdjBwcwgIxErP/24PUsAioSsy6ewMszCvgIvHlgjvEMgWJZctngoU5BVwlJnxx
	BgkLAVXM2NIMdoOEwC12ibcfFjNCjBGQ+Db5EAtIvYSArMSmA8wQYyQlDq64wTKBUXgBI8Mq
	RtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMDYOf3vWf8OxrsHrA8xCnAwKvHw3rRbHCLEmlhW
	XJl7iNEUaMNEZinR5HxghOaVxBsamxlZmJqYGhuZW5opifMulPoZLCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoGR0/HVklfOmtec+Bbmvk+6e3jthTeHjd+tmpz2bcY+s6q6M2LLrvV2c+Ry
	pBg3HN3lqcDHmXIh84KEp8L/ADN99u1ar/e931n0bXfBaom+/93aQTv2fpCY27n+iuXNW8/2
	Jyh3f01dlXjramAYz6oocbsPu5Vaz7Z+vPe65ch0v8UfmHY0mxr/VWIpzkg01GIuKk4EAMqx
	M/+YAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t9jAd3q9sUhBh9/8Fk8XrOYyWLjjPWs
	Fte/PGe1mHR/AovF6xeGFr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2Lyk3qNvyypGj8+b5ALYohoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlZSKEvMKQUK
	BSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZtx53s5csI+zYnbbEuYGxlaOLkZODgkB
	E4nfZ+8wQdhiEhfurWfrYuTiEBJYxChxemYTI4TTxCQx5dZUFpAqNgEtif0vbrCB2CICMhJX
	N25nASliFvjPJPH41XLWLkYODmGBGInZ/+1BalgEVCVm3b0BFuYVcJH4csEdYpmCxLLlM8HC
	nAKuEhO+OIOEhYAqZmxpZprAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBkPpPa
	wbiyweIQowAHoxIP7w27xSFCrIllxZW5hxglOJiVRHgvawKFeFMSK6tSi/Lji0pzUosPMZoC
	3TSRWUo0OR+YNPJK4g2NTcyMLI3MDS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhiZ
	N20uYHvGFaolGshx4DPTyndNmtwxRjNq5z7jui1+rOxGO3v7venLXPn6rn1KcFlZudMuY6fB
	MYnIP9c/puXcl8k6eezPGYOUPWt2RkTrOkSqLfTP7Jm05sY/wW8XJWXzLjD/UepsfWm0g6nS
	6LzF6Y2y/MeVOPb0bV/Mwyv2Rkl6ssCpvUxKLMUZiYZazEXFiQDSLRiD4gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Exynos3250 memory-bus node which includes the regulator
and devfreq-event phandle. The devfreq-event phandle is used for the
governor of devfreq device and provide the current usage state of
MIF (Memory Interface) / INT (Internal) memory bus group.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 60948ae..6722555 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -564,6 +564,18 @@
 	};
 };
 
+&memory_bus_mif {
+	devfreq-events = <&ppmu_dmc0_3>, <&ppmu_dmc1_3>;
+	vdd-mem-supply = <&buck1_reg>;
+	status = "okay";
+};
+
+&memory_bus_int {
+	devfreq-events = <&ppmu_leftbus_3>, <&ppmu_rightbus_3>;
+	vdd-mem-supply = <&buck3_reg>;
+	status = "okay";
+};
+
 &xusbxti {
 	clock-frequency = <24000000>;
 };
-- 
1.8.5.5

