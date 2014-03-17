Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaCQAc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 20:32:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39946 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790AbaCQAcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 20:32:25 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-8a-5326429734a2
Date: Mon, 17 Mar 2014 09:32:22 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 12/27] ARM: dts: Add description of System MMU of
 Exynos SoCs
Message-id: <20140317093222.1e56049853b06bd183c24241@samsung.com>
In-reply-to: <5322F407.208@samsung.com>
References: <20140314140649.dc5958f420770af48e2376d9@samsung.com>
 <5322F407.208@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zA93pTmrBBr0fZC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MqYv/0ae8Fco4on+6+xNjD+Vuti5OSQEDCReLhqJiuE
	LSZx4d56ti5GLg4hgWWMEo+3r2KFKTo28xMbiC0kMJ1R4m5jBkTRZCaJb3Pb2UESLAKqEu0n
	VrGA2GwCWhKr5x5nBLFFBFQkLp+azgjSwCzQyCrx6P4ysAZhgXCJ27MegDXwCjhKfDj1mwnE
	5hRQl9jW08EOsS1O4vajNWwQV1hIXGiCiPMKCEr8mHwPrJcZaNnmbU2sELa8xOY1b5lBlkkI
	zOWQeLf2JRvEdQIS3yYfAmrgAErISmw6wAwxU1Li4IobLBMYxWYhGTsLydhZSMYuYGRexSia
	WpBcUJyUXmSqV5yYW1yal66XnJ+7iRES7RN3MN4/YH2IMRlo5URmKdHkfGCyyCuJNzQ2M7Iw
	NTE1NjK3NCNNWEmcN/1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxon3OFY/ShWKmcDq
	1/Wy3+xkFc8PUf2ICTtm81iZ7uxMT5l44HCdzaQE7wyNXn9e1m/ZIRwLfjCk3y64c8vb8J5X
	ukeYnMi6lEVcJ2PELfmysv7kiFnqtmt4rpJtFpukzZf6d+38t4+7/l+dOPX94vS7RYbVTSmf
	Npktn7NTQi7n+qGdp+0UlViKMxINtZiLihMBYRv7jgwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd3pTmrBButfi1vcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/72a+wFc40q
	nuy/xtrA+Futi5GTQ0LAROLYzE9sELaYxIV768FsIYHpjBJ3GzO6GLmA7MlMEt/mtrODJFgE
	VCXaT6xiAbHZBLQkVs89zghiiwioSFw+NZ0RpIFZoJFV4tH9ZWANwgLhErdnPQBr4BVwlPhw
	6jcTiM0poC6xraeDHWJbnMTtR2ugrrCQuNAEEecVEJT4MfkeWC8z0LLN25pYIWx5ic1r3jJP
	YBSYhaRsFpKyWUjKFjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQITiXPpHYwrmywOMQo
	wMGoxMM7QVktWIg1say4MvcQowQHs5IIb4I5UIg3JbGyKrUoP76oNCe1+BBjMjA4JjJLiSbn
	A9NcXkm8obGJmZGlkZmFkYm5OWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwtuTLLva6
	u1w5Z/rSR1WPAqrrN08I+DezoCXr1nMfj2l986+d1lrN2XKvvY9PaJdivGdV7rmFdwRylfNn
	n/d/++FCXOL+wAll9kkn5uetMWFwD8gIuL/Eh8dBZu7LRVe39qbZGGzUav4msraWNSTilHua
	lH7cpb+LjDpcM3d6LLO3D2o/VrpAiaU4I9FQi7moOBEAVB7ZfmkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 13:20:23 +0100, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On 14.03.2014 06:06, Cho KyongHo wrote:
> > This patch adds dts entries for the System MMU devices found on
> > Exynos4 and Exynos5 SoC series and the System MMU binding
> > documentation.
> >
> > CC: Rob Herring <robherring2@gmail.com>
> > CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >   .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   86 +++++++
> >   arch/arm/boot/dts/exynos4.dtsi                     |  107 ++++++++
> >   arch/arm/boot/dts/exynos4210.dtsi                  |   23 +-
> >   arch/arm/boot/dts/exynos4x12.dtsi                  |   77 +++++-
> >   arch/arm/boot/dts/exynos5250.dtsi                  |  266 +++++++++++++++++++-
> >   arch/arm/boot/dts/exynos5420.dtsi                  |  205 ++++++++++++++-
> >   6 files changed, 758 insertions(+), 6 deletions(-)
> >   create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> >
> > diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > new file mode 100644
> > index 0000000..e4417bb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > @@ -0,0 +1,86 @@
> > +Samsung Exynos IOMMU H/W, System MMU (System Memory Management Unit)
> > +
> > +Samsung's Exynos architecture contains System MMUs that enables scattered
> > +physical memory chunks visible as a contiguous region to DMA-capable peripheral
> > +devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
> > +
> > +System MMU is an IOMMU and supports identical translation table format to
> > +ARMv7 translation tables with minimum set of page properties including access
> > +permissions, shareability and security protection. In addition, System MMU has
> > +another capabilities like L2 TLB or block-fetch buffers to minimize translation
> > +latency.
> > +
> > +System MMUs are in many to one relation with peripheral devices, i.e. single
> > +peripheral device might have multiple System MMUs (usually one for each bus
> > +master), but one System MMU can handle transactions from only one peripheral
> > +device. The relation between a System MMU and the peripheral device needs to be
> > +defined in device node of the peripheral device.
> > +
> > +MFC in all Exynos SoCs and FIMD, M2M Scalers and G2D in Exynos5420 has 2 System
> > +MMUs.
> > +* MFC has one System MMU on its left and right bus.
> > +* FIMD in Exynos5420 has one System MMU for window 0 and 4, the other system MMU
> > +  for window 1, 2 and 3.
> > +* M2M Scalers and G2D in Exynos5420 has one System MMU on the read channel and
> > +  the other System MMU on the write channel.
> > +The drivers must consider how to handle those System MMUs. One of the idea is
> > +to implement child devices or sub-devices which are the client devices of the
> > +System MMU.
> > +
> > +Required properties:
> > +- compatible: Should be one of:
> > +		"samsung,sysmmu-v1"
> > +		"samsung,sysmmu-v2"
> > +		"samsung,sysmmu-v3.1"
> > +		"samsung,sysmmu-v3.2"
> > +		"samsung,sysmmu-v3.3"
> > +
> > +- reg: A tuple of base address and size of System MMU registers.
> > +- interrupt-parent: The phandle of the interrupt controller of System MMU
> > +- interrupts: An interrupt specifier for interrupt signal of System MMU,
> > +	      according to the format defined by a particular interrupt
> > +	      controller.
> > +- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
> > +               Please refer to the following documents:
> > +	       Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
> > +	       Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> > +	       Documentation/devicetree/bindings/clock/exynos5420-clock.txt
> > +	       Optional "master" if the clock to the System MMU is gated by
> > +	       another gate clock other than "sysmmu". The System MMU driver
> > +	       sets "master" the parent of "sysmmu".
> > +	       Exynos4 SoCs, there needs no "master" clockj.
> > +	       Exynos5 SoCs, some System MMUs must have "master" clocks.
> > +- clocks: Required if the System MMU is needed to gate its clock.
> > +	  Please refer to the documents listed above.
> > +- samsung,power-domain: Required if the System MMU is needed to gate its power.
> > +	  Please refer to the following document:
> > +	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> > +- mmu-masters: A phandle to device nodes representing the master for which
> > +               the System MMU can provide a translation. Any additional values
> > +	       after the phandle will be ignored because a System MMU never
> > +	       have two or more masters. "#stream-id-cells" specified in the
> > +	       master's node will be also ignored.
> > +	       If more than one phandle is specified, only the first phandle
> > +	       will be treated.
> > +
> > +Examples:
> > +	gsc_0: gsc@13e00000 {
> > +		compatible = "samsung,exynos5-gsc";
> > +		reg = <0x13e00000 0x1000>;
> > +		interrupts = <0 85 0>;
> > +		samsung,power-domain = <&pd_gsc>;
> > +		clocks = <&clock 256>;
> > +		clock-names = "gscl";
> > +	};
> > +
> > +	sysmmu_gsc0: sysmmu@13E80000 {
> > +		compatible = "samsung,exynos4210-sysmmu";
> > +		reg = <0x13E80000 0x1000>;
> > +		interrupt-parent = <&combiner>;
> > +		interrupts = <2 0>;
> > +		clock-names = "sysmmu", "master";
> > +		clocks = <&clock 262>, <&clock 256>;
> > +		samsung,power-domain = <&pd_gsc>;
> > +		mmu-masters = <&gsc_0>;
> > +	};
> 
> Binding documentation should be added in separate patch in front of the 
> series relying on such binding or with the patch adding binding 
> implementation to the driver, so DT maintainers can review the binding 
> and related code easily.
> 
> Changes to dts(i) files should be posted in a separate patch, preferably 
> at the end of the series, when any prerequisites are already available.
> 

Thank you for the advice.

Should the patches related to the change in DT be shown in the following order?
"documentation -> source code change -> DT description"

KyongHo
