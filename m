Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbbAGOCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:02:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36467 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbAGOCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:02:02 -0500
X-AuditID: cbfee691-f79b86d000004a5a-23-54ad3c554985
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND 1/2] ARM: dts: exynos3250-rinato: Add regulator-haptic
 node for haptics
Date: Wed, 07 Jan 2015 23:01:52 +0900
Message-id: <1420639313-897-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420639313-897-1-git-send-email-jaewon02.kim@samsung.com>
References: <1420639313-897-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkSDfUZm2Iwd774hbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyYHVY9OqTjaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjjQt5S5
	4AZrxdObeg2MN1m6GDk5JARMJA62TmOHsMUkLtxbz9bFyMUhJLCUUeLOrhXsMEWNN26wQiSm
	M0rsPX+XBcJpY5KYfXgeM0gVm4C2xPf1i4GqODhEBBQlNi9QAKlhFpjEKHHj3gpWkBphgQSJ
	9u8gzRwcLAKqEru6+EHCvAJuEjOPnWcCCUsIKEjMmWQDEuYUcJf4fGUF2KFCQCUPdu1iBBkp
	IfCbTWL+536wtSwCAhLfJh9igeiVldh0gBniZkmJgytusExgFF7AyLCKUTS1ILmgOCm9yFSv
	ODG3uDQvXS85P3cTIzB0T/97NnEH4/0D1ocYBTgYlXh4C/rWhAixJpYVV+YeYjQF2jCRWUo0
	OR8YIXkl8YbGZkYWpiamxkbmlmZK4rw60j+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDu
	2G61fqPzaTXpnA+8R5tKciw37D6VaxJyanaHUdaWaevELzdtebSP9ZtRyeLqTZ3qTD/MJ1Qs
	uqa66YJh6CNzrnU77Dgr3/Z9/3WLd1n1liWbbSY5G66Yx3zE4/bsi/c9j38O2n5jhr/YB+d4
	EXHWOlUFyw0zYi9Pz82pXFa3K/uyWHYr5wwbJZbijERDLeai4kQAS88lpFgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xoG6ozdoQg41rBC2uf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fkwOrx6ZVnWwefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZdu
	q+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RTSaEsMacUKBSQWFyspG+HaUJoiJuu
	BUxjhK5vSBBcj5EBGkhYw5hxoG8pc8EN1oqnN/UaGG+ydDFyckgImEg03rjBCmGLSVy4t56t
	i5GLQ0hgOqPE3vN3WSCcNiaJ2YfnMYNUsQloS3xfvxiog4NDREBRYvMCBZAaZoFJjBI37q0A
	myQskCDR/h2kmYODRUBVYlcXP0iYV8BNYuax80wgYQkBBYk5k2xAwpwC7hKfr6wAu0cIqOTB
	rl2MExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjoxn0jsYVzVYHGIU4GBU4uEt
	6FsTIsSaWFZcmXuIUYKDWUmE980voBBvSmJlVWpRfnxRaU5q8SFGU6CbJjJLiSbnA6M2ryTe
	0NjEzMjSyNzQwsjYXEmcV8m+LURIID2xJDU7NbUgtQimj4mDU6qBUcSqwFlm8Zk9RVF+nhs8
	PB6n8y9tPJPiWy7bNItrjri8TmL+KentFur9v7+/ZtLe93Snu+2MnC99P8v4fO4KTrqvuPZp
	w+qcSpO3rPkZH0+8YxZZFyO/fu86C77X3Okl56yOT9B+d/KURoHZ9qvzZr737eWapf7lWN86
	oYOClslG73XO8dz9osRSnJFoqMVcVJwIAMLUFZKiAgAA
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

