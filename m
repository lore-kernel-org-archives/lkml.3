Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaIAP01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:26:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12592 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbaIAP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:26:22 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-16-54049019f3a7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] ARM: dts: exynos3250: Add CMU node for DMC domain clocks
Date: Mon, 01 Sep 2014 17:26:01 +0200
Message-id: <1409585162-10523-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409585162-10523-1-git-send-email-k.kozlowski@samsung.com>
References: <1409585162-10523-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xq7qSE1hCDA4807bYOGM9q8WkdQeY
	LOYfOcdq0f9mIavFuVcrGS1evzC06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWqw9
	cpfdYun1i0wWTydcZLOYMH0ti0Xr3iPsFofftLNarJ/xmsVi1a4/jA4iHmvmrWH0aGnuYfO4
	3NfL5PF31Qtmj52z7rJ7rFz+hc1j06pONo871/aweWxeUu/Rt2UVo8fnTXIB3FFcNimpOZll
	qUX6dglcGR+3zGUsmMpWcbHrG2MDYztrFyMnh4SAicTs5xPYIWwxiQv31rN1MXJxCAksZZS4
	cWYvM4TTxySx9c8isCo2AWOJzcuXgFWJCDSzSnw4NYMJxGEWmMEocW/hLhaQKmEBX4nf3fPB
	OlgEVCXW/rzPBmLzCrhLLP28mBFin5zEyWOTge7g4OAU8JBovKUAEhYCKrn69Db7BEbeBYwM
	qxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCIuLrDsalx6wOMQpwMCrx8L5YyBwixJpYVlyZ
	e4hRgoNZSYT3Sx9LiBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGkwZea1ZNn5zyfqfkz7O2kQ9c
	TsRVtcdvZSs7x2hhVSe0uzJ7wo7u50vuLUqcGc53r18kNqBoXd2Jt8yiK12D6gqa1J4JTzdl
	Mz54pHPaoS/XGPWS3nF5bTfo3Zmx+CfvHPYX0k42YW1bXi21S09zMXA2OVKzUXVmm2ql2fbv
	T/SOV8ktnp+kxFKckWioxVxUnAgAeAal0mYCAAA=
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

