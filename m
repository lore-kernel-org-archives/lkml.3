Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3HENKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:10:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29030 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3HENKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:10:19 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-16-51ffa4398ad2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>, m.szyprowski@samsung.com
Subject: Re: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Date: Mon, 05 Aug 2013 15:09:53 +0200
Message-id: <1429191.3FDem6vW0S@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <003c01ce91cd$427fad70$c77f0850$@samsung.com>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <27536111.odlCO093Zi@amdc1032> <003c01ce91cd$427fad70$c77f0850$@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAV3LJf8DDb4ctra4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWa4/cZbe4
	sGIju8W/3oOMFlMWHWa1OPmnl9Gi5Xovk4Ogx5OD85g8ZjdcZPG4c20Pm8f5TWuYPTYvqfeY
	fGM5o0ffllWMHp83yXlcOXqGKYAzissmJTUnsyy1SN8ugSvjyL33LAXNphUTep+wNjBu0uxi
	5OSQEDCReLr/DCOELSZx4d56NhBbSGARo8TaFTJdjFxAdguTxITebWBFbAJWEhPbV4HZIgIa
	Ep+vrGcFKWIWuMQqMekRRJGwQJjEioe/gCZxcLAIqEqcWR4MEuYV0JR4u+U3M4gtKuAqcW7R
	DxYQmxNo5uE5m1kglnUwSmx6OYEdokFQ4sfke2BFzALyEvv2T2WFsLUk1u88zjSBUWAWkrJZ
	SMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM43p5J72Bc1WBxiFGAg1GJh1eB
	/X+gEGtiWXFl7iFGCQ5mJRHeayVAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTSE0tS
	s1NTC1KLYLJMHJxSDYzT3Tm5fbVOJUky8ywp0G26mPV6lfsdpg9TI+70zRM9dvZE1bzTCfry
	mde+6jM8SakJO6eY3rCkuGtC6dJjGmzHsqMtDv9fq2GpxtWrJswdJqt5+bRX0rrHM2c/+lxX
	9EB5+e2ZM28YmrKki9V8iT3zOifG5fSP6ka3Ipbdynf2mK8Tt36aWarEUpyRaKjFXFScCABL
	alw6swIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 05, 2013 08:16:40 PM Cho KyongHo wrote:
> > -----Original Message-----
> > From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> > Sent: Saturday, August 03, 2013 2:14 AM
> > 
> > Hi,
> > 
> > On Friday, July 26, 2013 08:28:19 PM Cho KyongHo wrote:
> > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > ---
> > >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> > >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> > >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> > >  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
> > >  arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
> > >  5 files changed, 617 insertions(+), 0 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > >
> > > diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > > b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > > new file mode 100644
> > > index 0000000..92f0a33
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > > @@ -0,0 +1,103 @@
> > > +Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management Unit)
> > > +
> > > +Samsung's Exynos architecture contains System MMU that enables scattered
> > > +physical memory chunks visible as a contiguous region to DMA-capable peripheral
> > > +devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
> > > +
> > > +System MMU is a sort of IOMMU and support identical translation table format to
> > > +ARMv7 translation tables with minimum set of page properties including access
> > > +permissions, shareability and security protection. In addition, System MMU has
> > > +another capabilities like L2 TLB or block-fetch buffers to minimize translation
> > > +latency.
> > > +
> > > +A System MMU is dedicated to a single master peripheral device.  Thus, it is
> > > +important to specify the correct System MMU in the device node of its master
> > > +device. Whereas a System MMU is dedicated to a master device, the master device
> > > +may have more than one System MMU.
> > > +
> > > +Required properties:
> > > +- compatible: Should be "samsung,exynos4210-sysmmu"
> > > +- reg: A tuple of base address and size of System MMU registers.
> > > +- interrupt-parent: The phandle of the interrupt controller of System MMU
> > > +- interrupts: A tuple of numbers that indicates the interrupt source.
> > > +- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
> > > +               Please refer to the following documents:
> > > +	       Documentation/devicetree/bindings/clock/clock-bindings.txt
> > > +	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
> > > +	       Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> > > +	       Optional "master" if the clock to the System MMU is gated by
> > > +	       another gate clock other than "sysmmu". The System MMU driver
> > > +	       sets "master" the parent of "sysmmu".
> > > +	       Exynos4 SoCs, there needs no "master" clocks.
> > > +	       Exynos5 SoCs, some System MMUs must have "master" clocks.
> > > +- clocks: Required if the System MMU is needed to gate its clock.
> > > +	  Please refer to the documents listed above.
> > > +- samsung,power-domain: Required if the System MMU is needed to gate its power.
> > > +	  Please refer to the following document:
> > > +	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> > > +
> > > +Required properties for the master peripheral devices:
> > > +- iommu: phandles to the System MMUs of the device
> > > +
> > > +Examples:
> > > +A System MMU is dedicated to a single master device.
> > > +	gsc_0:  gsc@0x13e00000 {
> > > +		compatible = "samsung,exynos5-gsc";
> > > +		reg = <0x13e00000 0x1000>;
> > > +		interrupts = <0 85 0>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		clocks = <&clock 256>;
> > > +		clock-names = "gscl";
> > > +		iommu = <&sysmmu_gsc1>;
> > > +	};
> > > +
> > > +	sysmmu_gsc0: sysmmu@13E80000 {
> > > +		compatible = "samsung,exynos4210-sysmmu";
> > > +		reg = <0x13E80000 0x1000>;
> > > +		interrupt-parent = <&combiner>;
> > > +		interrupt-names = "sysmmu-gsc0";
> > > +		interrupts = <2 0>;
> > > +		clock-names = "sysmmu", "master";
> > > +		clocks = <&clock 262>, <&clock 256>;
> > > +		samsung,power-domain = <&pd_gsc>;
> > > +		status = "ok";
> > > +	};
> > > +
> > > +MFC has 2 System MMUs for each port that MFC is attached. Thus it seems natural
> > > +to define 2 System MMUs for each port of the MFC:
> > 
> > Marek Szyprowski (added to cc:) has a patch fixing MFC to create separate
> > mfc_l and mfc_r devices (like it was in the past). Using this patch it
> > would be possible to bind sysmmu_mfc_l to mfc_l device and sysmmu_mfc_r to
> > mfc_r device. This probably also requires adding some MFC specific handling
> > in a device tree node and to the new master's device PM ops (in patch #10)
> > as previously (in our trees) sysmmu_mfc r device was set as parent of
> > sysmmu_mfc_l device which in turn was a parent for main MFC device (to make
> > runtime Power Management work). However because MFC is the only device
> > requiring use of multiple System MMUs above changes would allow us (unless
> > I'm missing something?) to use just one System MMU device per struct
> > exynos_iommu_client instance (making driver a lot simpler).
> > 
> 
> Does it mean that we can make the exynos-iommu driver simpler
> with Marek Szyprowski's patch?

I think so and you probably need to change MFC handling anyway because
MFC driver does DMA allocations per mfc_l/mfc_r devices and not per main
device (at least in the upstream kernels).

[ Marek, could you please resfresh and post your patch on the list? ]

BTW There is an additional problem with combining System MMU devices per
one main device - it limits available address space (which in case of MFC
is very limited by hardware design).

> It is welcome but I don't think it covers all topologies of System MMU and
> master H/W. Those are getting more complex.

Could you please be more specific? I know about FIMC ISP subsystem but
it doesn't require combining System MMUs. Are there any other examples of
complex System MMU + master H/W topologies?

Anyway I think that System MMUs should not be combined (as it is done in
patch #10) and should be binded per "memport" devices and not per main
device (as done in this patch).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

