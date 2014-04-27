Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbaD0Hku (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:40:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57787 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaD0HjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:39:19 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-77-535cb426b5b0
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
Subject: [PATCH v12 11/31] documentation: iommu: add binding document of Exynos
 System MMU
Date: Sun, 27 Apr 2014 13:07:43 +0530
Message-id: <1398584283-22846-12-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkSldtS0ywwefVohZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV8a8C6fY
	C9qVKvqnHmRvYNwj3cXIySEhYCLx5GAnO4QtJnHh3nq2LkYuDiGBpYwS57tPMMEUXbv5HSqx
	iFFi8d+7TBDOBCaJswuXgFWxCRhKbL93hRUkISKwmlGi7+IZdhCHWeAuk8ScVe8YQaqEBWIk
	vn44ywJiswioSrxctQHI5uDgFfCQ6FzhC2JKCChIzJlkA1LBCRR9cmcPWLWQgLvE21NfwOZL
	CMzkkJiwo4EZYoyAxLfJh1ggemUlNh1ghrhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y1CtO
	zC0uzUvXS87P3cQIjMfT/5717mC8fcD6EGMy0LiJzFKiyfnAeM4riTc0NjOyMDUxNTYytzQj
	TVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsYb7hsciq4G71eebvru7yOloHDb
	73NnV+lzrN003el0z/fkMxdMjnq+YuXba9Fqu+rYszcnrt+fcljfsylQUFCQb/vzJV1NToet
	H6fmurKaPAtjE1n1TIt9mcw+lfm8Vkr8amZPTgmt/tYomlOyUeXX5Fa2TF6zBR7i6t/S7UJS
	D8p8k1GJUFFiKc5INNRiLipOBAA/unsX3QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAV21LTHBBlvPcFncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbvGv9yCjxZRF
	h1ktDr9pZ7U4+aeX0aLlei+TxfoZr1ksVu36w2gx89YaFgdhjycH5zF5zG64yOLx73A/k8fO
	WXfZPe5c28PmsXlJvcfkG8sZPfq2rGL0+LxJzuPK0TNMAVxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUCvKSmUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJaxgz5l04xV7QrlTRP/UgewPjHukuRk4OCQETiWs3v7NB2GISF+6t
	B7K5OIQEFjFKLP57lwnCmcAkcXbhEiaQKjYBQ4nt966wgiREBFYzSvRdPMMO4jAL3GWSmLPq
	HSNIlbBAjMTXD2dZQGwWAVWJl6s2ANkcHLwCHhKdK3xBTAkBBYk5k2xAKjiBok/u7AGrFhJw
	l3h76gvrBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/2Z1A7GlQ0WhxgFOBiV
	eHgXSMYEC7EmlhVX5h5ilOBgVhLh5ZwOFOJNSaysSi3Kjy8qzUktPsSYDHTTRGYp0eR8YCLK
	K4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGXBvrHbusqlm+
	HlKazCKbF/ph5+QbrEcn62vsXvpg8/TgnvMPryffDS87+EN6js6r3lkRJwxdr3154zN10n7Z
	T/JPWZmbrsxb8sHNwpfd4fT/jrUTV6UZ2d3d5b2jOmO185WvPop73LOLDzqU+Wsf3H2o7pvf
	5V3xviyLYg4JnJ3Yt/Jl1cnKQCWW4oxEQy3mouJEAJVzyD06AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch adds a description of the device tree binding for the
Samsung Exynos System MMU.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 .../devicetree/bindings/iommu/samsung,sysmmu.txt   |   79 ++++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt

diff --git a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
new file mode 100644
index 0000000..16e13a2
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
@@ -0,0 +1,79 @@
+Samsung Exynos IOMMU H/W, System MMU (System Memory Management Unit)
+
+Samsung's Exynos architecture contains System MMUs that enables scattered
+physical memory chunks visible as a contiguous region to DMA-capable peripheral
+devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
+
+System MMU is an IOMMU and supports identical translation table format to
+ARMv7 translation tables with minimum set of page properties including access
+permissions, shareability and security protection. In addition, System MMU has
+another capabilities like L2 TLB or block-fetch buffers to minimize translation
+latency.
+
+System MMUs are in many to one relation with peripheral devices, i.e. single
+peripheral device might have multiple System MMUs (usually one for each bus
+master), but one System MMU can handle transactions from only one peripheral
+device. The relation between a System MMU and the peripheral device needs to be
+defined in device node of the peripheral device.
+
+MFC in all Exynos SoCs and FIMD, M2M Scalers and G2D in Exynos5420 has 2 System
+MMUs.
+* MFC has one System MMU on its left and right bus.
+* FIMD in Exynos5420 has one System MMU for window 0 and 4, the other system MMU
+  for window 1, 2 and 3.
+* M2M Scalers and G2D in Exynos5420 has one System MMU on the read channel and
+  the other System MMU on the write channel.
+The drivers must consider how to handle those System MMUs. One of the idea is
+to implement child devices or sub-devices which are the client devices of the
+System MMU.
+
+Required properties:
+- compatible: Should be one of:
+		"samsung,sysmmu-v1"
+		"samsung,sysmmu-v2"
+		"samsung,sysmmu-v3.1"
+		"samsung,sysmmu-v3.2"
+		"samsung,sysmmu-v3.3"
+
+- reg: A tuple of base address and size of System MMU registers.
+- interrupt-parent: The phandle of the interrupt controller of System MMU
+- interrupts: An interrupt specifier for interrupt signal of System MMU,
+	      according to the format defined by a particular interrupt
+	      controller.
+- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
+	       Optional "master" if the clock to the System MMU is gated by
+	       another gate clock other than "sysmmu".
+	       Exynos4 SoCs, there needs no "master" clock.
+	       Exynos5 SoCs, some System MMUs must have "master" clocks.
+- clocks: Required if the System MMU is needed to gate its clock.
+- samsung,power-domain: Required if the System MMU is needed to gate its power.
+	  Please refer to the following document:
+	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+- mmu-masters: A phandle to device nodes representing the master for which
+               the System MMU can provide a translation. Any additional values
+	       after the phandle will be ignored because a System MMU never
+	       have two or more masters. "#stream-id-cells" specified in the
+	       master's node will be also ignored.
+	       If more than one phandle is specified, only the first phandle
+	       will be treated.
+
+Examples:
+	gsc_0: gsc@13e00000 {
+		compatible = "samsung,exynos5-gsc";
+		reg = <0x13e00000 0x1000>;
+		interrupts = <0 85 0>;
+		samsung,power-domain = <&pd_gsc>;
+		clocks = <&clock CLK_GSCL0>;
+		clock-names = "gscl";
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL0>, <&clock CLK_GSCL0>;
+		samsung,power-domain = <&pd_gsc>;
+		mmu-masters = <&gsc_0>;
+	};
-- 
1.7.9.5

