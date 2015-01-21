Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbbAUH4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:56:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8460 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbAUH4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:56:08 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-28-54bf5b967a3e
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND 1/2] ARM: dts: exynos3250-rinato: Add regulator-haptic
 node for haptics
Date: Wed, 21 Jan 2015 16:55:59 +0900
Message-id: <1421826960-26491-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421826960-26491-1-git-send-email-jaewon02.kim@samsung.com>
References: <1421826960-26491-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkWHda9P4Qg4aHXBbXvzxntdjRcITV
	ov/xa2aLm5++sVpc3jWHzWLG+X1MDmwem1Z1snn0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJX
	xoG+pcwFN1grnt7Ua2C8ydLFyMkhIWAi8ab3FJQtJnHh3nq2LkYuDiGBpYwSs+61scEULf+x
	mBEisYhR4vCB1UwQThuTxObmP8wgVWwC2hLf1y9m7WLk4BARUJTYvEABpIZZYCOjxJ9tfWAr
	hAUSJNq/3wWzWQRUJc7MOcAIYvMKeEh0vprODNIrIaAgMWeSDYjJKeApcXWmHEiFEFDFgfcP
	WEFGSgg0s0vsbZzNDDFGQOLb5EMsEK2yEpsOMEPcLClxcMUNlgmMwgsYGVYxiqYWJBcUJ6UX
	megVJ+YWl+al6yXn525iBAbx6X/PJuxgvHfA+hCjAAejEg/vC8X9IUKsiWXFlbmHGE2BNkxk
	lhJNzgfGSl5JvKGxmZGFqYmpsZG5pZmSOO9rqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODil
	GhjNY0o3rz9gsj3p4D0p21Wuqll/SiLrIg9ujvp2ceMCnzq39v7XTas2ZBQ+E9yfNd3nrsef
	OSazlXzfW3b7n/7dJyv7XmjSsknrprCvbbgw977GPL87+9bN3qbySOgYl9bVrm96G41lGtp3
	vMks+9UTllb7IbPjAoPaDZ2QqNvH390t3pjYe8hKiaU4I9FQi7moOBEAdN/f6F0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAd1p0ftDDGZ1MFpc//Kc1WJHwxFW
	i/7Hr5ktbn76xmpxedccNosZ5/cxObB5bFrVyebRt2UVo8fnTXIBzFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBkH+pYyF9xgrXh6U6+B8SZLFyMnh4SAicTyH4sZIWwx
	iQv31rN1MXJxCAksYpQ4fGA1E4TTxiSxufkPM0gVm4C2xPf1i1m7GDk4RAQUJTYvUACpYRbY
	yCjxZ1sf2FRhgQSJ9u93wWwWAVWJM3MOgG3gFfCQ6Hw1nRmkV0JAQWLOJBsQk1PAU+LqTDmQ
	CiGgigPvH7BOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Rp5J72Bc1WBxiFGA
	g1GJh/eF4v4QIdbEsuLK3EOMEhzMSiK8ihJAId6UxMqq1KL8+KLSnNTiQ4ymQDdNZJYSTc4H
	xm9eSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFqEUwfEwenVAPjMuWI0E7ZqbJ2
	PlczGfarTDuznCGFsWDF9t1uxtuvhPVV2rSdPsAe0C7u+MtCnbGMvaSonEEw/tMLfWF9UQbH
	ZT73tUKXpyfsnByRKXvgcrdP3XyO5Sd2+QR3W7RHax4/fmmL693E8vWSqrs3H518P1m3bMn7
	M+5XpKcy33AO2XG0+45rxmElluKMREMt5qLiRACFSVmipwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds regulator-haptic device node controlled by regulator.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 80aa8b4..0e3d499 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -100,6 +100,13 @@
 			};
 		};
 	};
+
+	haptics {
+		compatible = "regulator-haptic";
+		haptic-supply = <&motor_reg>;
+		min-microvolt = <1100000>;
+		max-microvolt = <2700000>;
+	};
 };
 
 &adc {
-- 
1.7.9.5

