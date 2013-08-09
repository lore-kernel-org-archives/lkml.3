Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967032Ab3HIApp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:45:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51715 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966931Ab3HIApd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:45:33 -0400
X-AuditID: cbfee68e-b7f276d000002279-45-52043bab537c
Date: Fri, 09 Aug 2013 09:45:30 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 06/16] ARM: dts: Add description of System MMU of Exynos
 SoCs
Message-id: <20130809094530.b1d3f3fe3ea96092c23d9fba@samsung.com>
In-reply-to: <520376CE.3000109@samsung.com>
References: <002a01ce941b$0d9a31c0$28ce9540$@samsung.com>
 <520376CE.3000109@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zI93V1ixBBq8OsVncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi8Nv
	2lktTv7pZbRoud7L5MDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MpY3XOVtWCBR8XFY52sDYy/zbsYOTkkBEwkvl/uZ4Ow
	xSQu3FsPZHNxCAksY5RY97aNCaZo4qd+JojEIkaJtfvWsEM4k5gk3i+dD9bOIqAqcXj2DGYQ
	m01AS2L13OOMILaIgL7EklUXwWqYBX6wSHzaxgdiCwuESZz49JcFxOYVcJTovTERrIZTQFvi
	xryDYLaQQJTEijmPoM6zkLjQ1MEOUS8o8WPyPRaImVoSm7c1sULY8hKb17xlBjlOQmAhh8Tv
	eVehjhOQ+Db5EFADB1BCVmLTAWaImZISB1fcYJnAKDYLydhZSMbOQjJ2ASPzKkbR1ILkguKk
	9CIjveLE3OLSvHS95PzcTYyQaO/bwXjzgPUhxmSglROZpUST84HJIq8k3tDYzMjC1MTU2Mjc
	0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDzvT6z+e3OOiaBRk2SasvSq
	6TWnVoSeZbEXDPrbYX5VKvfgHL+2nZp6C75qT/1v2rNpX0uy4onJ+qlqOS5d2uHbQg64PudQ
	qjj4fO28/cdeq5W8nrlK0HBe4E7NZywiG94dVrqUwpu5WvzPRG8Wh1mGLjoWC678r5nakbP4
	r/zyj101WhdTniqxFGckGmoxFxUnAgBIPoqgDAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jAd1V1ixBBnMm2FjcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi8Nv
	2lktTv7pZbRoud7L5MDv8eTgPCaP2Q0XWTzuXNvD5nF+0xpmj81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsbrnKmvBAo+K
	i8c6WRsYf5t3MXJySAiYSEz81M8EYYtJXLi3nq2LkYtDSGARo8TafWvYIZxJTBLvl85nA6li
	EVCVODx7BjOIzSagJbF67nFGEFtEQF9iyaqLYDXMAj9YJD5t4wOxhQXCJE58+ssCYvMKOEr0
	3pgIVsMpoC1xY95BMFtIIEpixZxHbBBXWEhcaOpgh6gXlPgx+R4LxEwtic3bmlghbHmJzWve
	Mk9gFJiFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOJc+kdjCubLA4
	xCjAwajEw6u4nTlIiDWxrLgy9xCjBAezkgjviyygEG9KYmVValF+fFFpTmrxIcZkYGhMZJYS
	Tc4Hprm8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamCM/iVg
	8XfCqRuPObpyM6WCmt7u1T3lfUXEVfjYxOcOfHHszg8/7FE7rW0fa7uT86FquTTfe26e94Zr
	PZ6xlN7Lt+Dzvin3Ipthpuf3Xq1tG//dqBb7MM3KfIvMu4X7d+56f0vLfI2u/0eXQpkPaibi
	/0QDOli6P52bk3tnpaOyrEBu7L+JZc+VWIozEg21mIuKEwHZrNVBaQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 12:45:34 +0200, Sylwester Nawrocki wrote:

> Hi,
> 
> On 08/08/2013 11:38 AM, Cho KyongHo wrote:
> 
> How about something along the lines of:
> 
> "This patch adds dts entries for the SYSMMU devices found on Exynos4
> and Exynos5 SoC series and the SYSMMU binding documentation."
> 
> instead of this empty changelog ?

Ok. I thought that the title of this patch is self-explanatory.
But I agree with you this needs more specific description.

> 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++++++
> >  arch/arm/boot/dts/exynos5250.dtsi                  |  290 ++++++++++++++++++++
> >  5 files changed, 622 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > new file mode 100644
> > index 0000000..92f0a33
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > @@ -0,0 +1,103 @@
> > +Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management Unit)
> > +
> > +Samsung's Exynos architecture contains System MMU that enables scattered
> > +physical memory chunks visible as a contiguous region to DMA-capable peripheral
> > +devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
> 
> s/so forth/and more ?

Sorry but I think that it is not a matter.

> 
> > +
> > +System MMU is a sort of IOMMU and support identical translation table format to
> 
> s/support/supports ?

Ok.

> 
> > +ARMv7 translation tables with minimum set of page properties including access
> > +permissions, shareability and security protection. In addition, System MMU has
> > +another capabilities like L2 TLB or block-fetch buffers to minimize translation
> > +latency.
> > +
> > +A System MMU is dedicated to a single master peripheral device.  Thus, it is
> > +important to specify the correct System MMU in the device node of its master
> > +device. Whereas a System MMU is dedicated to a master device, the master device
> > +may have more than one System MMU.
> > +
> > +Required properties:
> > +- compatible: Should be "samsung,exynos4210-sysmmu"
> > +- reg: A tuple of base address and size of System MMU registers.
> > +- interrupt-parent: The phandle of the interrupt controller of System MMU
> > +- interrupts: A tuple of numbers that indicates the interrupt source.
> 
> The interrupt specifier depends on the interrupt controller (interrupt-parent). 
> So it might not always be a "tuple of numbers". It's probably better to say,
> e.g.:
> 
> - interrupts: Should contain the SYSMMU controller interrupt.
> 

Yes.
You are correct.
The description assumes the interrupt controler is Interrupt Combiner in Exynos SoCs.
But actually, the interrupt controller can be GIC or something else.
The description needs to be changed.

> > +- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
> > +               Please refer to the following documents:
> > +	       Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
> > +	       Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> 
> You could replace "Documentation/devicetree/bindings/clock" with "../clock"
> 

Ok.

> > +	       Optional "master" if the clock to the System MMU is gated by
> > +	       another gate clock other than "sysmmu". The System MMU driver
> > +	       sets "master" the parent of "sysmmu".
> > +	       Exynos4 SoCs, there needs no "master" clocks.
> > +	       Exynos5 SoCs, some System MMUs must have "master" clocks.
> > +- clocks: Required if the System MMU is needed to gate its clock.
> > +	  Please refer to the documents listed above.
> > +- samsung,power-domain: Required if the System MMU is needed to gate its power.
> 
> Isn't it required always when an SoC support Power Domains and the SYSMMU
> belongs to a power domain ? Perhaps something like:
> 
> - samsung,power-domain: Required if the System MMU belongs to a Power Domain.
> 
> would be more appropriate ?
> 

Acutally, if System MMU and its master H/W is not registered to a generic IO powerdomain,
RPM and APM is not applicable to System MMU because of the implementation of System MMU
driver relies on dev_pm_ops callbacks of generic IO powerdomain.
I am still searching a better way like introducing bus_type for System MMU.
Any advice about it is welcome.

> > +	  Please refer to the following document:
> > +	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> > +
> > +Required properties for the master peripheral devices:
> > +- iommu: phandles to the System MMUs of the device
> > +
> > +Examples:
> > +A System MMU is dedicated to a single master device.
> > +	gsc_0:  gsc@0x13e00000 {
> > +		compatible = "samsung,exynos5-gsc";
> > +		reg = <0x13e00000 0x1000>;
> > +		interrupts = <0 85 0>;
> > +		samsung,power-domain = <&pd_gsc>;
> > +		clocks = <&clock 256>;
> > +		clock-names = "gscl";
> 
> You could omit all the above properties, perhaps just leaving
> 'compatible' property, simply replacing them with:
> 		...
> 
> since the only relevant property hers is 'iommu' ? Just a suggestion
> though.
> 
> > +		iommu = <&sysmmu_gsc1>;
> 

Ok.

> Shouldn't this be:
> 
> 		iommu = <&sysmmu_gsc0>;
> ? 

No, you are right. It is my fault :)

> It also probably makes sense to put the SYMMU device node above 
> the master device node.
> 

Ok. 

> > +	};
> > +
> > +	sysmmu_gsc0: sysmmu@13E80000 {
> > +		compatible = "samsung,exynos4210-sysmmu";
> > +		reg = <0x13E80000 0x1000>;
> > +		interrupt-parent = <&combiner>;
> > +		interrupt-names = "sysmmu-gsc0";
> > +		interrupts = <2 0>;
> > +		clock-names = "sysmmu", "master";
> > +		clocks = <&clock 262>, <&clock 256>;
> > +		samsung,power-domain = <&pd_gsc>;
> > +		status = "ok";
> > +	};
> > +
> > +MFC has 2 System MMUs for each port that MFC is attached. Thus it seems natural
> > +to define 2 System MMUs for each port of the MFC:
> > +
> > +	mfc: codec@13400000 {
> > +		compatible = "samsung,mfc-v5";
> > +		reg = <0x13400000 0x10000>;
> > +		interrupts = <0 94 0>;
> > +		samsung,power-domain = <&pd_mfc>;
> > +		clocks = <&clock 170>, <&clock 273>;
> > +		clock-names = "sclk_mfc", "mfc";
> > +		status = "ok";
> > +		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
> > +	};
> 
> How about putting this node as last one in this example ?

Ok.

> 
> > +	sysmmu_mfc_l: sysmmu@13620000 {
> > +		compatible = "samsung,exynos4210-sysmmu";
> > +		reg = <0x13620000 0x1000>;
> > +		interrupt-parent = <&combiner>;
> > +		interrupt-names = "sysmmu-mfc-l";
> > +		interrupts = <5 5>;
> > +		clock-names = "sysmmu";
> > +		clocks = <&clock 274>;
> > +		samsung,power-domain = <&pd_mfc>;
> > +		status = "ok";
> > +	};
> > +
> > +	sysmmu_mfc_r: sysmmu@13630000 {
> > +		compatible = "samsung,exynos4210-sysmmu";
> > +		reg = <0x13630000 0x1000>;
> > +		interrupt-parent = <&combiner>;
> > +		interrupt-names = "sysmmu-mfc-r";
> > +		interrupts = <5 6>;
> > +		clock-names = "sysmmu";
> > +		clocks = <&clock 275>;
> > +		samsung,power-domain = <&pd_mfc>;
> > +		status = "ok";
> > +	};
> > +
> > diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> > index 597cfcf..6265984 100644
> > --- a/arch/arm/boot/dts/exynos4.dtsi
> > +++ b/arch/arm/boot/dts/exynos4.dtsi
> > @@ -251,6 +251,7 @@
> >  		clocks = <&clock 170>, <&clock 273>;
> >  		clock-names = "sclk_mfc", "mfc";
> >  		status = "disabled";
> > +		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
> >  	};
> >  
> >  	serial@13800000 {
> > @@ -485,5 +486,126 @@
> >  		clock-names = "sclk_fimd", "fimd";
> >  		samsung,power-domain = <&pd_lcd0>;
> >  		status = "disabled";
> > +		iommu = <&sysmmu_fimd0>;
> > +	};
> > +
> > +	sysmmu_mfc_l: sysmmu@13620000 {
> > +		compatible = "samsung,exynos4210-sysmmu";
> > +		reg = <0x13620000 0x1000>;
> > +		interrupt-parent = <&combiner>;
> > +		interrupt-names = "sysmmu-mfc-l";
> 
> Do you really need 'interrupt-names' property, when there is only
> one interrupt in each node. Isn't it just a leftover from previous
> iterations ? I can't see it mentioned in the binding documentation.

interrupt-names are optional for System MMU driver as you know.
The driver does not use it currently but interrupt-name can be used
for printing shorter name of a Sytsem MMU than dev_name(dev).

> 
> > +		interrupts = <5 5>;
> > +		clock-names = "sysmmu";
> > +		clocks = <&clock 274>;
> > +		samsung,power-domain = <&pd_mfc>;
> > +		status = "ok";
> > +	};
> 
> 
> Thanks,
> Sylwester

Thank you for kind and detailed review!

KyongHo.
