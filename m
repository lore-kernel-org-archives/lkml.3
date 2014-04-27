Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaD0Hud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:50:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31247 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbaD0HkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:40:04 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-22-535cb452e77c
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
Subject: [PATCH v12 27/31] ARM: dts: add System MMU nodes of exynos4 series
Date: Sun, 27 Apr 2014 13:07:59 +0530
Message-id: <1398584283-22846-28-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkVjd4S0ywwbqlHBZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8bs3W/Y
	Ch5KV8z79oe9gXGLWBcjJ4eEgInEyQlNTBC2mMSFe+vZuhi5OIQEljJKdM87wwRT1L9tDSNE
	YhGjxJW+K8wQzgQmid+/zrGCVLEJGEpsv3eFFSQhIrCaUaLv4hl2EIdZ4C6TxJxV7xhBqoQF
	vCU+TD/JDmKzCKhK3Hp0BCzOK+Ah8bfrLlA3B9A+BYk5k2xAwpxA4Sd39rCA2EIC7hJvT30B
	WyAhMJND4n/7fDaIOQIS3yYfYoHolZXYdIAZ4mxJiYMrbrBMYBRewMiwilE0tSC5oDgpvchI
	rzgxt7g0L10vOT93EyMwIk//e9a3g/HmAetDjMlA4yYyS4km5wMjOq8k3tDYzMjC1MTU2Mjc
	0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MC65vyfAVaud1TtLe3dRO1fu
	feuzFr0W27eur/ko+V5sXWqf/6UlnhaVb5k1WW+7y56Mu/yUw6rusNyOJMvfl128Lrj4cD4r
	1F+2kS18l7yu1drY1FcXt2/UXdPO0X1ji+V/DoEjnD2/z6g18yw1LzN0myrAI1MlYvEmeJ84
	X1uU162A3E1PlViKMxINtZiLihMBGnJJwd4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd2gLTHBBsfOWFrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgzZu9+w1bwULpi3rc/7A2MW8S6GDk5JARMJPq3rWGEsMUkLtxb
	z9bFyMUhJLCIUeJK3xVmCGcCk8TvX+dYQarYBAwltt+7wgqSEBFYzSjRd/EMO4jDLHCXSWLO
	qndgs4QFvCU+TD/JDmKzCKhK3Hp0BCzOK+Ah8bfrLlA3B9A+BYk5k2xAwpxA4Sd39rCA2EIC
	7hJvT31hncDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcLw/k97BuKrB4hCjAAej
	Eg/vD+mYYCHWxLLiytxDjBIczEoivJzTgUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD0xF
	eSXxhsYm5qbGppYmFiZmlqQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAaLj63fYpkXIP
	5WpVdGacV67fsOERd8wrpUbj/o3rVnbNfxr608L+3wcuxf7guQGvzB7das4xPXau8VBh7PIj
	s789CJ4ifCUjbtnu5znyxxh6DA9rXlKVfGKfr3Ure4lk/WuDSmGel6bPjJYrvvJUn1r9//5b
	S5UP95gD5I7+WbhO1+XPjz7lF0osxRmJhlrMRcWJAFITCHI7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch adds System MMU nodes that are common to exynos4 series.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi |  107 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 2f8bcd0..229efee 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -536,4 +536,111 @@
 		samsung,power-domain = <&pd_lcd0>;
 		status = "disabled";
 	};
+
+	sysmmu_mfc_l: sysmmu@13620000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x13620000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_MFCL>;
+		samsung,power-domain = <&pd_mfc>;
+		mmu-masters = <&mfc>;
+	};
+
+	sysmmu_mfc_r: sysmmu@13630000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x13630000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_MFCR>;
+		samsung,power-domain = <&pd_mfc>;
+		mmu-masters = <&mfc>;
+	};
+
+	sysmmu_tv: sysmmu@12E20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_TV>;
+		samsung,power-domain = <&pd_tv>;
+	};
+
+	sysmmu_fimc0: sysmmu@11A20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC0>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_0>;
+	};
+
+	sysmmu_fimc1: sysmmu@11A30000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC1>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_1>;
+	};
+
+	sysmmu_fimc2: sysmmu@11A40000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC2>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_2>;
+	};
+
+	sysmmu_fimc3: sysmmu@11A50000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC3>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_3>;
+	};
+
+	sysmmu_jpeg: sysmmu@11A60000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_JPEG>;
+		samsung,power-domain = <&pd_cam>;
+	};
+
+	sysmmu_rotator: sysmmu@12A30000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_ROTATOR>;
+		samsung,power-domain = <&pd_lcd0>;
+	};
+
+	sysmmu_fimd0: sysmmu@11E20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMD0>;
+		samsung,power-domain = <&pd_lcd0>;
+		mmu-masters = <&fimd>;
+	};
 };
-- 
1.7.9.5

