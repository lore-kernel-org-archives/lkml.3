Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaD0Hst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:48:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57842 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaD0HkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:40:09 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-3d-535cb4581b05
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 29/31] ARM: dts: add System MMU nodes of exynos4x12
Date: Sun, 27 Apr 2014 13:08:01 +0530
Message-id: <1398584283-22846-30-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkTjdiS0ywweGpWhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bF7d/Y
	CtrEK1ZvX8jSwHhKqIuRk0NCwETicv9vFghbTOLCvfVsXYxcHEICSxkl3m46yAZT9HzGTnaI
	xCJGiWVLrkM5E5gkVq9ewAhSxSZgKLH93hVWkISIwGpGib6LZ8CqmAXuMknMWfUOrEpYwF2i
	/8xlsLksAqoS9x7MYAaxeQU8JHYubwWKcwDtU5CYM8kGJMwJFH5yZw/YfUJArW9PfQFbICEw
	k0Oid9s3qDkCEt8mH2KB6JWV2HSAGeJsSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4
	NC9dLzk/dxMjMCJP/3vWt4Px5gHrQ4zJQOMmMkuJJucDIzqvJN7Q2MzIwtTE1NjI3NKMNGEl
	cd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDWZLw1fPTl0syUB8bvAwIFH+/xVY8o
	3TljS+zbB2JvF0RcP89heFpZ0bzHJrw+SfDDd7+Z/HMEtRIjNq39VKi4ms00S7HfSfxGIDu/
	+kz5fbrHXEROLf/v9svm+JYL338vyDw8aV4pU+oCvx0zFvxu+yy56fWb6QcPNL6vux7n2dN1
	/+16ZuUjSizFGYmGWsxFxYkAjyTe3N4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd2ILTHBBrd/yVvcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzLm7/xlbQJl6xevtClgbGU0JdjJwcEgImEs9n7GSHsMUkLtxb
	z9bFyMUhJLCIUWLZkuvsEM4EJonVqxcwglSxCRhKbL93hRUkISKwmlGi7+IZsCpmgbtMEnNW
	vQOrEhZwl+g/c5kNxGYRUJW492AGM4jNK+AhsXN5K1CcA2ifgsScSTYgYU6g8JM7e1hAbCGg
	1renvrBOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM43p9J72Bc1WBxiFGAg1GJ
	h/eHdEywEGtiWXFl7iFGCQ5mJRFezulAId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4HpqK8
	knhDYxNzU2NTSxMLEzNL0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamCcvPzb2l8y31aV
	9QSzRKfs8lSfdmvtu+qfR6cq/MnYOc84ic1Oe8XbvU9fzFypxfjd5q5OZ/JPsQ9/rdOE315d
	23Y9ze/4Ov9/TBwPSvJt0v+Y7fko8PFiGety4YSHTcl1q3MOtNfOeOsbdIV5RRmT0OwZ5p4T
	5KZ43vp0cP6P7Iv/6v/cLvjiosRSnJFoqMVcVJwIAESsNbs7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch adds System MMU nodes that are specifict to exynos4x12
series.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi |   78 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index c4a9306..21cb164 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -119,7 +119,7 @@
 		interrupts = <0 72 0>;
 	};
 
-	g2d@10800000 {
+	g2d: g2d@10800000 {
 		compatible = "samsung,exynos4212-g2d";
 		reg = <0x10800000 0x1000>;
 		interrupts = <0 89 0>;
@@ -243,4 +243,80 @@
 		clock-names = "biu", "ciu";
 		status = "disabled";
 	};
+
+	sysmmu_g2d: sysmmu@10A40000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x10A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_G2D>;
+		mmu-masters = <&g2d>;
+	};
+
+	sysmmu_fimc_isp: sysmmu@12260000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 2>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_ISP>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_drc: sysmmu@12270000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 3>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_DRC>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_fd: sysmmu@122A0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x122A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 4>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FD>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@122B0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x122B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 5>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_ISPCX>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@123B0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x123B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 0>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_LITE0>;
+		mmu-masters = <&fimc_lite_0>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@123C0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x123C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 1>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_LITE1>;
+		mmu-masters = <&fimc_lite_1>;
+	};
 };
-- 
1.7.9.5

