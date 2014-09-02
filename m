Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaIBNWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:22:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:37247 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaIBNWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:22:19 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-e6-5405c489254f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/3] ARM: dts: exynos3250: Add CMU node for DMC domain clocks
Date: Tue, 02 Sep 2014 15:21:16 +0200
Message-id: <1409664077-27121-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409664077-27121-1-git-send-email-k.kozlowski@samsung.com>
References: <1409664077-27121-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7qdR1hDDE5fYrLYOGM9q8WkdQeY
	LOYfOcdq0f9mIavFuVcrGS1evzC06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWqw9
	cpfdYun1i0wWTydcZLOYMH0ti0Xr3iPsFofftLNarJ/xmsVB2GPNvDWMHi3NPWwel/t6mTz+
	rnrB7LFy+Rc2j02rOtk87lzbw+axeUm9R9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGV83DKX
	sWAqW8XFrm+MDYztrF2MnBwSAiYSk35tY4GwxSQu3FvP1sXIxSEksJRR4u/NdiYIp49Jouvb
	PyaQKjYBY4nNy5ewgdgiAk0sEjPvB4AUMQt8YZSYdf0Z2FhhgQCJto1LgWwODhYBVYn+NQUg
	YV4Bd4kbHdegtslJnDw2GaycU8BD4s/Pzywg5UJANRNv1k1g5F3AyLCKUTS1NLmgOCk911Cv
	ODG3uDQvXS85P3cTIyTwv+xgXHzM6hCjAAejEg/vi4XMIUKsiWXFlbmHGCU4mJVEeD32soYI
	8aYkVlalFuXHF5XmpBYfYmTi4JRqYPSotcvo8wovuzvt0h3HCSzqXzLLjHrfF3leeK6b95aX
	7/2zXN85vPETwp6sLii4mPRnYQVTZpvZx18XdXm5i1IX15+8Ht8yoVz85cbPvrNulKjUHP15
	pv85X1+qb/kJgSSDgCi9c+9uzb5UknL65qbX15omh8989ufX749fN77tM45zXLE8g12JpTgj
	0VCLuag4EQAFvcSCWgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CMU (Clock Management Unit) node for DMC (Dynamic Memory Controller)
domain clocks on Exynos3250.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 429a6c6cfcf9..8c3a9cc0a4d1 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -163,6 +163,12 @@
 			#clock-cells = <1>;
 		};
 
+		cmu_dmc: clock-controller@105C0000 {
+			compatible = "samsung,exynos3250-cmu-dmc";
+			reg = <0x105C0000 0x2000>;
+			#clock-cells = <1>;
+		};
+
 		rtc: rtc@10070000 {
 			compatible = "samsung,exynos3250-rtc";
 			reg = <0x10070000 0x100>;
-- 
1.9.1

