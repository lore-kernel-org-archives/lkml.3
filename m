Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab3JJFp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:45:58 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61112 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3JJFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:45:53 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-5a-52563f0f0020
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/3] ARM: dts: exynos4212: Add PMU dt data for pmu-irq
Date: Thu, 10 Oct 2013 14:45:34 +0900
Message-id: <1381383936-2627-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1381383936-2627-1-git-send-email-cw00.choi@samsung.com>
References: <1381383936-2627-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkWFfAPizIYOZVFovrX56zWsw/co7V
	4tyrlYwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei6XXLzJZTJi+lsXi8IoDTBav
	DraxWKyf8ZrFgc9jzbw1jB4tzT1sHgs+X2H3WLn8C5vH5iX1Hn1bVjF6fN4k57FxbmgARxSX
	TUpqTmZZapG+XQJXxqlNXSwFP1kqlj17y9zA2MTSxcjJISFgInG58QEzhC0mceHeerYuRi4O
	IYGljBKXr+5khCl69+IbM0RiOqPE4Y+XoJxGJol7cx6DVbEJaEnsf3EDrF1EoJ1RYnXrAhYQ
	h1mglUni6pZdYEuEBTwkJlw8C9bBIqAq8Wf5ArBDeAVcJN69aWGC2Ccn8WHPI3YQm1PAVeLD
	lAVgvUJANct/tICtlhB4xC7xb+dEVohBAhLfJh8CGsQBlJCV2HQA6iFJiYMrbrBMYBRewMiw
	ilE0tSC5oDgpvchYrzgxt7g0L10vOT93EyMwlk7/e9a/g/HuAetDjMlA4yYyS4km5wNjMa8k
	3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJqbxQrK
	Gb9ELAtQlV/EMP/cX5buNIvNW066pxp+tdMUWij0N8cnJKw7s8JnH19sikBx6P3/6pp67iVx
	MbIq1led83yv5f54duLGVGfbLPZbs9M0j+1syH9oZcKz6sjye0nTZ69+vdqrU/WKaOU617v+
	2s0+a3edncrFXZjE3fs3TvzQ3HePlViKMxINtZiLihMBZAxCtrsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+xoC6/fViQwYmTVhbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjqgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBmnNnWxFPxkqVj27C1zA2MTSxcj
	J4eEgInEuxffmCFsMYkL99azdTFycQgJTGeUOPzxEjOE08gkcW/OY0aQKjYBLYn9L26AVYkI
	tDNKrG5dwALiMAu0Mklc3bILbJawgIfEhItnwTpYBFQl/ixfALaPV8BF4t2bFiaIfXISH/Y8
	YgexOQVcJT5MWQDWKwRUs/xHC/MERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIj
	9Zn0DsZVDRaHGAU4GJV4eCvKQoOEWBPLiitzDzFKcDArifBOPwkU4k1JrKxKLcqPLyrNSS0+
	xJgMdNVEZinR5HxgEskriTc0NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYm
	Dk6pBkbGkOesS8wv11T7tM1j+6flX/awR+bsvoqiN4s152heX1Mit18sx5rzdW+VVJDj65bK
	r7Z9l1+3Bnxfoxr7/Zz+UcN303MT3Vafkf4S+GOHfv5TtgVKC3Oa4u+9vl9hY6V26r/jJtUp
	1dNe/k8Xfr5owzOu2+Wd7h+WrvY98mejSIFJ8a9dE/crsRRnJBpqMRcVJwIAtRBSyxgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
- No change

 arch/arm/boot/dts/exynos4212.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4212.dtsi b/arch/arm/boot/dts/exynos4212.dtsi
index 6f34d7f..3081bae 100644
--- a/arch/arm/boot/dts/exynos4212.dtsi
+++ b/arch/arm/boot/dts/exynos4212.dtsi
@@ -56,4 +56,10 @@
 					<0x5 0 &gic 1 12 0>;
 		};
 	};
+
+	pmu {
+		compatible = "arm,cortex-a9-pmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>, <3 2>;
+	};
 };
-- 
1.8.0

