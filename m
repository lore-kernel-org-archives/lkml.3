Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJTMJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:09:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25635 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJTMIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:08:50 -0400
X-AuditID: cbfee68f-f791c6d000004834-e6-5444fb50ea27
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, thomas.ab@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 4/4] ARM: dts: Add CPU OPP and regulator supply property for
 Exynos3250
Date: Mon, 20 Oct 2014 21:08:42 +0900
Message-id: <1413806922-22722-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
References: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkRDfgt0uIweLXihbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8miYxmjxapdfxgtNn71cOD22DnrLrvH
	nWt72Dw2L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsErozb7xYzFzziqDh64yNjA+MXti5G
	Tg4JAROJias+MEPYYhIX7q0HinNxCAksZZS4/PEjkMMBVnRnkyREfDqjxLdN9xkhnCYmiTtH
	74NNYhPQktj/4gaYLSJgJLFq51JWkCJmgT4mif+Ln7CDJIQFoiWu3t8NVsQioCrx+uwpMJtX
	wFXizaWV7BBnyEl82PMIzOYUcJNYc38WmC0EVHOrpwlsqITAJnaJqVdfMUEMEpD4NvkQC8Sp
	shKbDkC9IylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525iBMbC6X/P+ncw
	3j1gfYhRgINRiYd3h5lLiBBrYllxZe4hRlOgDROZpUST84ERl1cSb2hsZmRhamJqbGRuaaYk
	zrtQ6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZ9MfGPOETebM11k99bIFJbLy/zeFVN
	nviFTfKu8/vu7HDZpd105cbFYo0FPutNEy/36a9MjLx5Rfh8ZZXC9d/cb3hkWZfvnTN3ecfV
	psRXDvcXin5dzXnPI15ym9UE2xcO1c2Wgv+LdmqFX9zLXnLoxuEvsuvON4T1N5S2hvQa7DB3
	PipVq6nEUpyRaKjFXFScCAAS35tCgAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd2A3y4hBscOSVlc//Kc1WLS/Qks
	Fr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLjmWMFqt2/WG02PjVw4HbY+esu+we
	d67tYfPYvKTeo2/LKkaPz5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jBm3H63mLngEUfF0RsfGRsYv7B1MXJwSAiYSNzZJNnFyAlkiklcuLceKMzFISQwnVHi26b7
	jBBOE5PEnaP32UCq2AS0JPa/uAFmiwgYSazauZQVpIhZoI9J4v/iJ+wgCWGBaImr93eDFbEI
	qEq8PnsKzOYVcJV4c2klO8Q6OYkPex6B2ZwCbhJr7s8Cs4WAam71NLFOYORdwMiwilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyM40p5J72Bc1WBxiFGAg1GJh3eHmUuIEGtiWXFl7iFGCQ5m
	JRHeqG9AId6UxMqq1KL8+KLSnNTiQ4ymQFdNZJYSTc4HJoG8knhDYxMzI0sjc0MLI2NzJXHe
	g63WgUIC6YklqdmpqQWpRTB9TBycUg2MgoVn/27eo+zy2qV23omS30+8HVZYnP1TwZPRqHcg
	VHNhpodaTvfWkr2d8wx4kp1XnjM5E7RUpOWHp+Qv/70vVskuYKp8YDvjfuj+CWrpB+MuvA+Z
	LZTeOUlP+E33/uY5WxanxErwVaw0MsyZ93Gn0oRfM6WPOi59fixymlutv2lO9v5clcnPlFiK
	MxINtZiLihMBPVa2lMoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add CPU operating points which include CPU frequency and regulator
voltage to use generic cpufreq drivers.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Thomas Abraham <thomas.ab@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 693a327..0b5bea8 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -52,6 +52,21 @@
 			compatible = "arm,cortex-a7";
 			reg = <0>;
 			clock-frequency = <1000000000>;
+			clocks = <&cmu CLK_DIV_CORE2>;
+			clock-names = "cpu";
+
+			operating-points = <
+				1000000 1150000
+				900000  1112500
+				800000  1075000
+				700000  1037500
+				600000  1000000
+				500000  962500
+				400000  925000
+				300000  887500
+				200000  850000
+				100000  850000
+			>;
 		};
 
 		cpu1: cpu@1 {
-- 
1.8.0

