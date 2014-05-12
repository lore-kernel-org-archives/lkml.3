Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaELGRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:17:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25835 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaELGRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:17:08 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-ef-53706763a428
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 16/19] documentation: iommu: add binding document of Exynos
 System MMU
Date: Mon, 12 May 2014 11:45:01 +0530
Message-id: <1399875304-19948-17-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWyRsSkRjc5vSDY4FATj8Wdu+dYLf5OOsZu
	Mf8IkPXqyA8miwX7rS06Z29gt/i+6wu7Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLC6s2Mhu8a/3
	IKPFlEWHWS0Ov2lntTj5p5fR4sjD3ewWLdd7mSzWz3jNYrFq1x9Gi5m31rA4iHo8OTiPyeP3
	r0mMHrMbLrJ4/Dvcz+Sxc9Zddo871/aweWxeUu8x+cZyRo++LasYPT5vkvO4cvQMUwB3FJdN
	SmpOZllqkb5dAlfGvYOHWAt+yVb8nLyMvYHxkEQXIyeHhICJxPOvHxghbDGJC/fWs3UxcnEI
	CSxllJjf1M/axcgBVjRraxZIjZDAIkaJTdv1IGomMEm8/jiFFSTBJmAosf3eFVaQhIjAakaJ
	votn2EEcZoHZzBJHHi0GWyEsECOx9M5WFhCbRUBV4sPr6WBxXgEPiWlnGhkhtilIzJlkAxLm
	BAp/Xj2FDWKzu8SxV1fBFkgIrOWQWNL6iBFijoDEt8mHWCB6ZSU2HWCG+EZS4uCKGywTGIUX
	MDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiM1dP/nvXuYLx9wPoQYzLQuInMUqLJ+cBY
	zyuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxgRx
	fhH9nteRPz4zR7ocqUoI22po93ab2nLrfJu9qlqPFCs+/bUzjc+cOOXKu5erV+hNu5++xe9+
	8JHKGHMGY8fl+/dy+uqcuKpkW/Jhmq3UH8+4X3dXu+uEFB9czHypammQ3Upv6U+CL3pkLsyz
	9NN60Kujw+QxM0Hl5ZWHce/8H7+K8JhcocRSnJFoqMVcVJwIAFq8t/jrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd3k9IJgg/3/GS3u3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2i3+9
	Bxktpiw6zGpx+E07q8XJP72MFkce7ma3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZtw7eIi14Jdsxc/Jy9gbGA9JdDFy
	cEgImEjM2prVxcgJZIpJXLi3ng3EFhJYxCixabteFyMXkD2BSeL1xymsIAk2AUOJ7feusIIk
	RARWM0r0XTzDDuIwC8xmljjyaDEjSJWwQIzE0jtbWUBsFgFViQ+vp4PFeQU8JKadaWSE2Kwg
	MWeSDUiYEyj8efUUqM3uEsdeXWWdwMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw
	IngmvYNxVYPFIUYBDkYlHt4PDAXBQqyJZcWVuYcYJTiYlUR4P/oDhXhTEiurUovy44tKc1KL
	DzEmAx01kVlKNDkfmKTySuINjU3MTY1NLU0sTMwsSRNWEuc92GodKCSQnliSmp2aWpBaBLOF
	iYNTqoHRaene6J4a3yxpibLbSxXCN4SGvLm+tyNwzeQfVoGl923cFG9u/LArXG/vSaZ9Uz3r
	eO7XZf+59JJV6NOnxzGVVoE7vj5yZU2aVDa/7clGgdeS8z6Ub6pnzfv8Yq3k3KO/dGsluZdl
	tx7oFHKW6emMNnj0elHdASGe8jdS9dVtOn/VnC1aX4grsRRnJBpqMRcVJwIAtvL8bkgDAAA=
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
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 .../devicetree/bindings/iommu/samsung,sysmmu.txt   |   65 ++++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt

diff --git a/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
new file mode 100644
index 0000000..15b2a2b
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
@@ -0,0 +1,65 @@
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
+- compatible: Should be "samsung,exynos-sysmmu"
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
+		compatible = "samsung,exynos-sysmmu";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL0>, <&clock CLK_GSCL0>;
+		samsung,power-domain = <&pd_gsc>;
+	};
-- 
1.7.9.5

