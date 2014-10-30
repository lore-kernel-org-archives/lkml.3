Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbaJ3LVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:21:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64132 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759475AbaJ3LVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:30 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-bd-54521f38e635
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
Subject: [PATCH v3 14/14] ARM: dts: exynos5800-peach: Update to new max77802
 regulator compatible
Date: Thu, 30 Oct 2014 12:20:53 +0100
Message-id: <1414668053-31370-15-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7oW8kEhBpuO6ltsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK6Jx/kK3gIWvF64Y2xgbGlyxd
	jJwcEgImEvMWzGSFsMUkLtxbz9bFyMUhJLCUUeLo9ivMEE4fk8T561eZQarYBIwlNi9fAlYl
	ItDJLNFzsBesillgNZPEzyunwKqEBZIlOq/MYwexWQRUJRYt/MEIYvMKeEjsvnOOCWKfnMTJ
	Y5PBdnMCxdd8bAeyOYDWuUvc+6Y9gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ
	EP+6g3HpMatDjAIcjEo8vBHHAkKEWBPLiitzDzFKcDArifCuFgsKEeJNSaysSi3Kjy8qzUkt
	PsTIxMEp1cB4rXz+A80VTjcUpxzeHvHE8ZtAum2Asdvv42u2/3HSOrdx/5970yTTa5ge3OD2
	dn5n57nCsaZstV3oxtcXc+2MGSXW/T5uY24ga8j0KiIm7OPWn/o3/PWeTzqT/Ld/dl5cv6r+
	43DzHzF7MqS2BdQFfRXa/1c5fVFXRcTfs4dnxwloXfgy9+YKJZbijERDLeai4kQA6I0yP08C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to new bindings for max77802 regulator driver by adding proper
compatible field for regulators node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos5800-peach-pi.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5800-peach-pi.dts b/arch/arm/boot/dts/exynos5800-peach-pi.dts
index e8fdda827fc9..689c6bc84fd3 100644
--- a/arch/arm/boot/dts/exynos5800-peach-pi.dts
+++ b/arch/arm/boot/dts/exynos5800-peach-pi.dts
@@ -184,6 +184,8 @@
 		inl10-supply = <&buck7_reg>;
 
 		regulators {
+			compatible = "maxim,max77802-pmic";
+
 			buck1_reg: BUCK1 {
 				regulator-name = "vdd_mif";
 				regulator-min-microvolt = <800000>;
-- 
1.9.1

