Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3HFJyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:54:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27909 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3HFJyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:54:38 -0400
X-AuditID: cbfee68e-b7f276d000002279-7e-5200c7dcce5e
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
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
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <27536111.odlCO093Zi@amdc1032> <003c01ce91cd$427fad70$c77f0850$@samsung.com>
 <1429191.3FDem6vW0S@amdc1032>
In-reply-to: <1429191.3FDem6vW0S@amdc1032>
Subject: RE: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Date: Tue, 06 Aug 2013 18:54:36 +0900
Message-id: <002001ce928a$f5a7f390$e0f7dab0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQJ8iaVttThmxHyrdfHNT5d6MXLI1gK7Hr4aAXxZKSACSySRw5f36+1A
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t8zI907xxmCDLbct7C4c/ccq8XGGetZ
	LV4d+cFksWC/tUXn7A3sFpsPrmOx6F1wlc2i8d4ENouPp46zW2x6fI3V4vKuOWwWM87vY7JY
	e+Quu8WFFRvZLaYsOsxqcfJPL6NFy/VeJgdBjycH5zF5zG64yOJx59oeNo/zm9Ywe2xeUu8x
	+cZyRo++LasYPT5vkvO4cvQMUwBnFJdNSmpOZllqkb5dAlfG/e7l7AVTrCs2f2xka2C8rtvF
	yMkhIWAisWvVflYIW0ziwr31bF2MXBxCAssYJa71TQNyOMCKNmwygYgvYpRo+/MHqugvo8TT
	C/1g3WwCWhKr5x5nBLFFBKwkHs84yw5SxCxwiVVi0qNtYAkhgRWMEudXJ4DYnEANO3/fBGsW
	FgiT2HsDZDUnB4uAqsTdyx+ZQWxeAUuJiy9XskPYghI/Jt9jAbGZgXrX7zzOBGHLS2xe85YZ
	4gUFiR1nXzNCxEUk9r14xwjygYiAm8S6P+4g90gIXOGQuNx9FmqXgMS3yYdYIL6Uldh0AGqM
	pMTBFTdYJjBKzEKyeRaSzbOQbJ6FZNsCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCFp
	pG8H480D1ocYk4HWT2SWEk3OB6ahvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUw2tf+PiyZ73xjY9mao1MyN1w4f+ii6c33Oc1yLsEnTfhec5dp
	aTHa3Xq55uQNK+nQN943tq9pDfTNiq6tm3fyK8PxxFl6ledZGefUFv62X9QU9eVUERtX0GOz
	fW8FqjKFLH9ff9cVdnP2iTn7OOdfuBb273PnQZMmv0MKvoodYRIrei7/03aYqcRSnJFoqMVc
	VJwIAN0jQZ45AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e+xgO6d4wxBBp3PDC3u3D3HarFxxnpW
	i1dHfjBZLNhvbdE5ewO7xeaD61gsehdcZbNovDeBzeLjqePsFpseX2O1uLxrDpvFjPP7mCzW
	HrnLbnFhxUZ2iymLDrNanPzTy2jRcr2XyUHQ48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtM
	vrGc0aNvyypGj8+b5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQ
	sI4x4373cvaCKdYVmz82sjUwXtftYuTgkBAwkdiwyaSLkRPIFJO4cG89WxcjF4eQwCJGibY/
	f6Ccv4wSTy/0s4JUsQloSayee5wRxBYRsJJ4POMsO0gRs8AlVolJj7aBJYQEVjBKnF+dAGJz
	AjXs/H0TrFlYIExi7w2QFZwcLAKqEncvf2QGsXkFLCUuvlzJDmELSvyYfI8FxGYG6l2/8zgT
	hC0vsXnNW2aIUxUkdpx9zQgRF5HY9+IdI8g3IgJuEuv+uE9gFJqFZNIsJJNmIZk0C0n3AkaW
	VYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBSeqZ1A7GlQ0WhxgFOBiVeHgTr/4PFGJNLCuu
	zD3EKMHBrCTCq7KTIUiINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84EJNK8k3tDYxMzI0sjM
	wsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGAUd13MLGDhFLVw9f+WMVRl9PAd1
	b7kbGC/33SO4/1PQo6Kd72dfqxMVdxDbmxi+X13e6GnB5O3+HuXhVY869n+6EdmcaSEV+3ru
	6/lJs/eyyk+MfNNgHXNEM6v87gUXJXH/hAy2T3ttmk8ziTo6Beg6hzRyqDPMWcvo0TS35Wq5
	W/6M5InOSizFGYmGWsxFxYkAjeYX0ZYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Monday, August 05, 2013 10:10 PM
> 
> On Monday, August 05, 2013 08:16:40 PM Cho KyongHo wrote:
> > > -----Original Message-----
> > > From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> > > Sent: Saturday, August 03, 2013 2:14 AM
> > >
> > > Hi,
> > >
> > > On Friday, July 26, 2013 08:28:19 PM Cho KyongHo wrote:
> > > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > > ---
> > > >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> > > >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> > > >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> > > >  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
> > > >  arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
> > > >  5 files changed, 617 insertions(+), 0 deletions(-)
> > > >  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > > > b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > > > new file mode 100644
> > > > index 0000000..92f0a33
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> > > > @@ -0,0 +1,103 @@
> > > > +Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management Unit)
> > > > +
> > > > +Samsung's Exynos architecture contains System MMU that enables scattered
> > > > +physical memory chunks visible as a contiguous region to DMA-capable peripheral
> > > > +devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
> > > > +
> > > > +System MMU is a sort of IOMMU and support identical translation table format to
> > > > +ARMv7 translation tables with minimum set of page properties including access
> > > > +permissions, shareability and security protection. In addition, System MMU has
> > > > +another capabilities like L2 TLB or block-fetch buffers to minimize translation
> > > > +latency.
> > > > +
> > > > +A System MMU is dedicated to a single master peripheral device.  Thus, it is
> > > > +important to specify the correct System MMU in the device node of its master
> > > > +device. Whereas a System MMU is dedicated to a master device, the master device
> > > > +may have more than one System MMU.
> > > > +
> > > > +Required properties:
> > > > +- compatible: Should be "samsung,exynos4210-sysmmu"
> > > > +- reg: A tuple of base address and size of System MMU registers.
> > > > +- interrupt-parent: The phandle of the interrupt controller of System MMU
> > > > +- interrupts: A tuple of numbers that indicates the interrupt source.
> > > > +- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
> > > > +               Please refer to the following documents:
> > > > +	       Documentation/devicetree/bindings/clock/clock-bindings.txt
> > > > +	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
> > > > +	       Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> > > > +	       Optional "master" if the clock to the System MMU is gated by
> > > > +	       another gate clock other than "sysmmu". The System MMU driver
> > > > +	       sets "master" the parent of "sysmmu".
> > > > +	       Exynos4 SoCs, there needs no "master" clocks.
> > > > +	       Exynos5 SoCs, some System MMUs must have "master" clocks.
> > > > +- clocks: Required if the System MMU is needed to gate its clock.
> > > > +	  Please refer to the documents listed above.
> > > > +- samsung,power-domain: Required if the System MMU is needed to gate its power.
> > > > +	  Please refer to the following document:
> > > > +	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> > > > +
> > > > +Required properties for the master peripheral devices:
> > > > +- iommu: phandles to the System MMUs of the device
> > > > +
> > > > +Examples:
> > > > +A System MMU is dedicated to a single master device.
> > > > +	gsc_0:  gsc@0x13e00000 {
> > > > +		compatible = "samsung,exynos5-gsc";
> > > > +		reg = <0x13e00000 0x1000>;
> > > > +		interrupts = <0 85 0>;
> > > > +		samsung,power-domain = <&pd_gsc>;
> > > > +		clocks = <&clock 256>;
> > > > +		clock-names = "gscl";
> > > > +		iommu = <&sysmmu_gsc1>;
> > > > +	};
> > > > +
> > > > +	sysmmu_gsc0: sysmmu@13E80000 {
> > > > +		compatible = "samsung,exynos4210-sysmmu";
> > > > +		reg = <0x13E80000 0x1000>;
> > > > +		interrupt-parent = <&combiner>;
> > > > +		interrupt-names = "sysmmu-gsc0";
> > > > +		interrupts = <2 0>;
> > > > +		clock-names = "sysmmu", "master";
> > > > +		clocks = <&clock 262>, <&clock 256>;
> > > > +		samsung,power-domain = <&pd_gsc>;
> > > > +		status = "ok";
> > > > +	};
> > > > +
> > > > +MFC has 2 System MMUs for each port that MFC is attached. Thus it seems natural
> > > > +to define 2 System MMUs for each port of the MFC:
> > >
> > > Marek Szyprowski (added to cc:) has a patch fixing MFC to create separate
> > > mfc_l and mfc_r devices (like it was in the past). Using this patch it
> > > would be possible to bind sysmmu_mfc_l to mfc_l device and sysmmu_mfc_r to
> > > mfc_r device. This probably also requires adding some MFC specific handling
> > > in a device tree node and to the new master's device PM ops (in patch #10)
> > > as previously (in our trees) sysmmu_mfc r device was set as parent of
> > > sysmmu_mfc_l device which in turn was a parent for main MFC device (to make
> > > runtime Power Management work). However because MFC is the only device
> > > requiring use of multiple System MMUs above changes would allow us (unless
> > > I'm missing something?) to use just one System MMU device per struct
> > > exynos_iommu_client instance (making driver a lot simpler).
> > >
> >
> > Does it mean that we can make the exynos-iommu driver simpler
> > with Marek Szyprowski's patch?
> 
> I think so and you probably need to change MFC handling anyway because
> MFC driver does DMA allocations per mfc_l/mfc_r devices and not per main
> device (at least in the upstream kernels).
> 
> [ Marek, could you please resfresh and post your patch on the list? ]
> 
> BTW There is an additional problem with combining System MMU devices per
> one main device - it limits available address space (which in case of MFC
> is very limited by hardware design).
> 
> > It is welcome but I don't think it covers all topologies of System MMU and
> > master H/W. Those are getting more complex.
> 
> Could you please be more specific? I know about FIMC ISP subsystem but
> it doesn't require combining System MMUs. Are there any other examples of
> complex System MMU + master H/W topologies?

I meant a lot of System MMUs in FIMC-IS subsystem.
A big challenge to System MMU configuration is FIMC-IS as you mentioned.
Since I don't know how the driver of FIMC-IS controls its H/W,
I made the System MMU driver to configure System MMUs flexibly.

> 
> Anyway I think that System MMUs should not be combined (as it is done in
> patch #10) and should be binded per "memport" devices and not per main
> device (as done in this patch).
> 

Ok.
I will make it them as you advised.
And we can make the driver better gradually.

Thank you.

KyongHo.
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics

