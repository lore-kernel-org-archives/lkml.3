Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbbAUH5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:57:13 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26558 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbbAUH4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:56:22 -0500
X-AuditID: cbfee68d-f79296d000004278-22-54bf5b96711a
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND 2/2] ARM: dts: exynos3250-monk: Add regulator-haptic
 node for haptics
Date: Wed, 21 Jan 2015 16:56:00 +0900
Message-id: <1421826960-26491-3-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421826960-26491-1-git-send-email-jaewon02.kim@samsung.com>
References: <1421826960-26491-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWyRsSkUHda9P4Qg4XL+C2uf3nOarGj4Qir
	Rf/j18wWNz99Y7W4vGsOm8WM8/uYHNg8Nq3qZPPo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSu
	jL+3HrIXnGOt+DZtGXsD43mWLkZODgkBE4m/xyezQthiEhfurWcDsYUEljJKHPzKB1NzrX85
	UD0XUHwRo8SO5ydYIZw2JonNzX+YQarYBLQlvq9fDJTg4BARUJTYvEABpIZZYCOjxJ9tfWDb
	hAXiJF6vuA62gUVAVeLNykeMIDavgIfEzU997CC9EgIKEnMm2YCYnAKeEldnykHc4yFx4P0D
	sLUSAs3sEh0ztrJCjBGQ+Db5EAtEq6zEpgPMEDdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWG
	esWJucWleel6yfm5mxiBQXz637PeHYy3D1gfYhTgYFTi4X2huD9EiDWxrLgy9xCjKdCGicxS
	osn5wFjJK4k3NDYzsjA1MTU2Mrc0UxLnVZT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	cXYqv+QNu96UHRYW5dPNFyn/XSWpvWveDcbXcbfU2nZWaDcnyk/eyqZ7JiWo4035mc0BFa2H
	XS7LPPxe8uhQJJvkrfYAu/mLDLMEnjN5/G39YprXK/lsce3po38CU4OC6jZs/PHJ+sAh1bOH
	FwurBr/p263oPydbMkQswVw8uMf+EI/Ahvp4JZbijERDLeai4kQA3dQG5F0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jAd1p0ftDDHq2cFhc//Kc1WJHwxFW
	i/7Hr5ktbn76xmpxedccNosZ5/cxObB5bFrVyebRt2UVo8fnTXIBzFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYQ1jBl/bz1kLzjHWvFt2jL2BsbzLF2MnBwSAiYS1/qXQ9li
	EhfurWfrYuTiEBJYxCix4/kJVginjUlic/MfZpAqNgFtie/rFwMlODhEBBQlNi9QAKlhFtjI
	KPFnWx/YJGGBOInXK66zgdgsAqoSb1Y+YgSxeQU8JG5+6mMH6ZUQUJCYM8kGxOQU8JS4OlMO
	pEIIqOLA+wesExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjpJn0jsYVzVYHGIU
	4GBU4uF9obg/RIg1say4MvcQowQHs5IIr6IEUIg3JbGyKrUoP76oNCe1+BCjKdBNE5mlRJPz
	gRGcVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAmFbXsGNerkj1
	ggXVYcfVN3UoXJjv0b4876TC3V21boXel8zU5L4aXl/+aKZrzZTpT458dp4zc4foNov5nMxh
	jF8WPlWaf8JtuYipZJ/t0qV/k1OanKVE7/e39+QWM0SvnmNyV9LZs2lZYuh6w1+RhyVfu2xk
	W925cP2nsuUB4nGs/DvcTn98pcRSnJFoqMVcVJwIAMcYTNCoAgAA
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
 arch/arm/boot/dts/exynos3250-monk.dts |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-monk.dts b/arch/arm/boot/dts/exynos3250-monk.dts
index 24822aa..7102d88 100644
--- a/arch/arm/boot/dts/exynos3250-monk.dts
+++ b/arch/arm/boot/dts/exynos3250-monk.dts
@@ -109,6 +109,13 @@
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

