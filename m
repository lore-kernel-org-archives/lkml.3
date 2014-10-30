Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbaJ3LWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:22:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59728 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759446AbaJ3LV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:29 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-57-54521f38820d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 13/14] ARM: dts: exynos5420-peach: Update to new max77802
 regulator compatible
Date: Thu, 30 Oct 2014 12:20:52 +0100
Message-id: <1414668053-31370-14-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7oW8kEhBmeXslhsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKeHv0O1vBM9aK05/b2BsY37F0
	MXJySAiYSOx/fZkZwhaTuHBvPVsXIxeHkMBSRolpG44xQzh9TBLnr18Fq2ITMJbYvHwJWJWI
	QCezRM/BXrAqZoHVTBI/r5wCqxIWSJbo/7YWbAeLgKrElj8T2UFsXgEPiWunr7JD7JOTOHls
	MiuIzQkUX/OxHcjmAFrnLnHvm/YERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJC
	/MsOxsXHrA4xCnAwKvHwOmwMCBFiTSwrrsw9xCjBwawkwrtaLChEiDclsbIqtSg/vqg0J7X4
	ECMTB6dUAyP/94xWlu1e0bLlqXvfvekTS2+PnPrtxeW6DWZ/D/V29kWIfLgl9eDEq6RLnktb
	1txO6rwf/anstb1iwBeVu3enRF++OuF4/1ve34dZuOfPmB5u7nuzvHmdd5yhZpT/r9YX2k80
	7eN7VqefV9S0Mp5hFWZ74vqZVSxpW12TDvW33jzYOP1Ud6gSS3FGoqEWc1FxIgBGluzdTwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to new bindings for max77802 regulator driver by adding proper
compatible field for regulators node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos5420-peach-pit.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
index 9a050e19a4dc..1bc25cd9b437 100644
--- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
+++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts
@@ -185,6 +185,8 @@
 		inl10-supply = <&buck7_reg>;
 
 		regulators {
+			compatible = "maxim,max77802-pmic";
+
 			buck1_reg: BUCK1 {
 				regulator-name = "vdd_mif";
 				regulator-min-microvolt = <800000>;
-- 
1.9.1

