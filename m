Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148Ab3HHKpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:45:44 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9474 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965110Ab3HHKpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:45:39 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-71-520376d0058a
Message-id: <520376CE.3000109@samsung.com>
Date: Thu, 08 Aug 2013 12:45:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>
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
References: <002a01ce941b$0d9a31c0$28ce9540$@samsung.com>
In-reply-to: <002a01ce941b$0d9a31c0$28ce9540$@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xy7oXypiDDE5MEbG4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVlcWLGR3eJf70FGiymL
	DrNanPzTy2jRcr2XyYHf48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXx7VwzS8Fz64ote9vYGxjn6XcxcnJICJhIXFz8ghHC
	FpO4cG89G4gtJLCUUWLbsrouRi4g+xOjxNV795hBErwCWhKHVx5iB7FZBFQl7nS/ZQWx2QQM
	JXqP9oENEhUIkFi85Bw7RL2gxI/J91hAbBEBDYnPV9aD1TML/GCR+LSND8QWFgiTOPHpLwvE
	YkuJd7tbweZwClhJnJ67gQmiXkdif+s0NghbXmLzmrfMExgFZiFZMQtJ2SwkZQsYmVcxiqaW
	JhcUJ6XnGukVJ+YWl+al6yXn525ihETW1x2MS49ZHWIU4GBU4uHtCGAKEmJNLCuuzD3EKMHB
	rCTC+yKLOUiINyWxsiq1KD++qDQntfgQIxMHp1QD454J+j4r1DwLj1afmSujm26aLDfFJNJJ
	fccuxY5L29h9lJ6vTrtkamwjXCzldUAluXWa+r1LucziSu0/4mPPFh73V2/bU2fqLXwl8fyS
	UMHpR1i3Hjv+qXXdyVTvZauWrovZZKm4VubHzk1+gilvPZ47G6gddGJb8PtTdrTQM43X1VZe
	mXEWSizFGYmGWsxFxYkAhzQx1IoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/08/2013 11:38 AM, Cho KyongHo wrote:

How about something along the lines of:

"This patch adds dts entries for the SYSMMU devices found on Exynos4
and Exynos5 SoC series and the SYSMMU binding documentation."

instead of this empty changelog ?

> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
>  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++++++
>  arch/arm/boot/dts/exynos5250.dtsi                  |  290 ++++++++++++++++++++
>  5 files changed, 622 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> 
> diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> new file mode 100644
> index 0000000..92f0a33
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> @@ -0,0 +1,103 @@
> +Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management Unit)
> +
> +Samsung's Exynos architecture contains System MMU that enables scattered
> +physical memory chunks visible as a contiguous region to DMA-capable peripheral
> +devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.

s/so forth/and more ?

> +
> +System MMU is a sort of IOMMU and support identical translation table format to

s/support/supports ?

> +ARMv7 translation tables with minimum set of page properties including access
> +permissions, shareability and security protection. In addition, System MMU has
> +another capabilities like L2 TLB or block-fetch buffers to minimize translation
> +latency.
> +
> +A System MMU is dedicated to a single master peripheral device.  Thus, it is
> +important to specify the correct System MMU in the device node of its master
> +device. Whereas a System MMU is dedicated to a master device, the master device
> +may have more than one System MMU.
> +
> +Required properties:
> +- compatible: Should be "samsung,exynos4210-sysmmu"
> +- reg: A tuple of base address and size of System MMU registers.
> +- interrupt-parent: The phandle of the interrupt controller of System MMU
> +- interrupts: A tuple of numbers that indicates the interrupt source.

The interrupt specifier depends on the interrupt controller (interrupt-parent). 
So it might not always be a "tuple of numbers". It's probably better to say,
e.g.:

- interrupts: Should contain the SYSMMU controller interrupt.

> +- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
> +               Please refer to the following documents:
> +	       Documentation/devicetree/bindings/clock/clock-bindings.txt
> +	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
> +	       Documentation/devicetree/bindings/clock/exynos5250-clock.txt

You could replace "Documentation/devicetree/bindings/clock" with "../clock"

> +	       Optional "master" if the clock to the System MMU is gated by
> +	       another gate clock other than "sysmmu". The System MMU driver
> +	       sets "master" the parent of "sysmmu".
> +	       Exynos4 SoCs, there needs no "master" clocks.
> +	       Exynos5 SoCs, some System MMUs must have "master" clocks.
> +- clocks: Required if the System MMU is needed to gate its clock.
> +	  Please refer to the documents listed above.
> +- samsung,power-domain: Required if the System MMU is needed to gate its power.

Isn't it required always when an SoC support Power Domains and the SYSMMU
belongs to a power domain ? Perhaps something like:

- samsung,power-domain: Required if the System MMU belongs to a Power Domain.

would be more appropriate ?

> +	  Please refer to the following document:
> +	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> +
> +Required properties for the master peripheral devices:
> +- iommu: phandles to the System MMUs of the device
> +
> +Examples:
> +A System MMU is dedicated to a single master device.
> +	gsc_0:  gsc@0x13e00000 {
> +		compatible = "samsung,exynos5-gsc";
> +		reg = <0x13e00000 0x1000>;
> +		interrupts = <0 85 0>;
> +		samsung,power-domain = <&pd_gsc>;
> +		clocks = <&clock 256>;
> +		clock-names = "gscl";

You could omit all the above properties, perhaps just leaving
'compatible' property, simply replacing them with:
		...

since the only relevant property hers is 'iommu' ? Just a suggestion
though.

> +		iommu = <&sysmmu_gsc1>;

Shouldn't this be:

		iommu = <&sysmmu_gsc0>;
? 
It also probably makes sense to put the SYMMU device node above 
the master device node.

> +	};
> +
> +	sysmmu_gsc0: sysmmu@13E80000 {
> +		compatible = "samsung,exynos4210-sysmmu";
> +		reg = <0x13E80000 0x1000>;
> +		interrupt-parent = <&combiner>;
> +		interrupt-names = "sysmmu-gsc0";
> +		interrupts = <2 0>;
> +		clock-names = "sysmmu", "master";
> +		clocks = <&clock 262>, <&clock 256>;
> +		samsung,power-domain = <&pd_gsc>;
> +		status = "ok";
> +	};
> +
> +MFC has 2 System MMUs for each port that MFC is attached. Thus it seems natural
> +to define 2 System MMUs for each port of the MFC:
> +
> +	mfc: codec@13400000 {
> +		compatible = "samsung,mfc-v5";
> +		reg = <0x13400000 0x10000>;
> +		interrupts = <0 94 0>;
> +		samsung,power-domain = <&pd_mfc>;
> +		clocks = <&clock 170>, <&clock 273>;
> +		clock-names = "sclk_mfc", "mfc";
> +		status = "ok";
> +		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
> +	};

How about putting this node as last one in this example ?

> +	sysmmu_mfc_l: sysmmu@13620000 {
> +		compatible = "samsung,exynos4210-sysmmu";
> +		reg = <0x13620000 0x1000>;
> +		interrupt-parent = <&combiner>;
> +		interrupt-names = "sysmmu-mfc-l";
> +		interrupts = <5 5>;
> +		clock-names = "sysmmu";
> +		clocks = <&clock 274>;
> +		samsung,power-domain = <&pd_mfc>;
> +		status = "ok";
> +	};
> +
> +	sysmmu_mfc_r: sysmmu@13630000 {
> +		compatible = "samsung,exynos4210-sysmmu";
> +		reg = <0x13630000 0x1000>;
> +		interrupt-parent = <&combiner>;
> +		interrupt-names = "sysmmu-mfc-r";
> +		interrupts = <5 6>;
> +		clock-names = "sysmmu";
> +		clocks = <&clock 275>;
> +		samsung,power-domain = <&pd_mfc>;
> +		status = "ok";
> +	};
> +
> diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> index 597cfcf..6265984 100644
> --- a/arch/arm/boot/dts/exynos4.dtsi
> +++ b/arch/arm/boot/dts/exynos4.dtsi
> @@ -251,6 +251,7 @@
>  		clocks = <&clock 170>, <&clock 273>;
>  		clock-names = "sclk_mfc", "mfc";
>  		status = "disabled";
> +		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
>  	};
>  
>  	serial@13800000 {
> @@ -485,5 +486,126 @@
>  		clock-names = "sclk_fimd", "fimd";
>  		samsung,power-domain = <&pd_lcd0>;
>  		status = "disabled";
> +		iommu = <&sysmmu_fimd0>;
> +	};
> +
> +	sysmmu_mfc_l: sysmmu@13620000 {
> +		compatible = "samsung,exynos4210-sysmmu";
> +		reg = <0x13620000 0x1000>;
> +		interrupt-parent = <&combiner>;
> +		interrupt-names = "sysmmu-mfc-l";

Do you really need 'interrupt-names' property, when there is only
one interrupt in each node. Isn't it just a leftover from previous
iterations ? I can't see it mentioned in the binding documentation.

> +		interrupts = <5 5>;
> +		clock-names = "sysmmu";
> +		clocks = <&clock 274>;
> +		samsung,power-domain = <&pd_mfc>;
> +		status = "ok";
> +	};


Thanks,
Sylwester
