Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab3HANFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:05:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19090 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3HANFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:05:52 -0400
X-AuditID: cbfee68e-b7f276d000002279-cc-51fa5d2ca81b
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Rob Herring'" <robherring2@gmail.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Will Deacon'" <will.deacon@arm.com>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <CAL_JsqJdh5F0rK3koAW7DvRVU3RwS5pLgR5sV_Bak+K-6CrRFA@mail.gmail.com>
In-reply-to: <CAL_JsqJdh5F0rK3koAW7DvRVU3RwS5pLgR5sV_Bak+K-6CrRFA@mail.gmail.com>
Subject: RE: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Date: Thu, 01 Aug 2013 22:05:48 +0900
Message-id: <003801ce8eb7$d7647f10$862d7d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ8iaVttThmxHyrdfHNT5d6MXLI1gJ7xXnRmBB8NzA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t8zY13d2F+BBk//mlncuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eL7t29sFif/9DJatFzvZbJ4+fEEi4Ogx5OD85g81sxbw+gxu+Eii8fOWXfZPe5c28Pm
	cX7TGmaPzUvqPSbfWM7o0bdlFaPH501yHleOnmEK4I7isklJzcksSy3St0vgytj8dxFzwZ7/
	jBW/v99ib2DcMJuxi5GTQ0LAROJzVxMLhC0mceHeerYuRi4OIYFljBKze98xwRRt3nwSKrGI
	UWL6m4+MEM5fRomGL0/B2tkEtCRWzz0ONlZEQFPi0oTvYDazwH1WiX/LYyAaGoDGXp7C3MXI
	wcEpECxxah9Yr7BAmMTeGyCrOTlYBFQlnu19DmbzClhK7JvwngnCFpT4MfkeC8RMLYn1O48z
	QdjyEpvXvGWGuFRBYsfZ14wg40UErCQ+LaiBKBGR2PfiHdjNEgIPOCQubDjCCLFLQOLb5EMs
	IPUSArISmw5AjZGUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3ISK84Mbe4
	NC9dLzk/dxMjJL307WC8ecD6EGMy0PqJzFKiyfnA9JRXEm9obGZkYWpiamxkbmlGmrCSOK9a
	i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsbWy+x9uTGK3yfNe7mAc8LDpAUsYg6ZH11j
	t7VxvFQ+EhR2RmD1xd4Wo/W9S/y7nk7wnf8lX8lqgXn4jFIX9vNL7sluyg+1ydigVGMje9Rg
	dbSQZULX3yNhOT2MvxamsqZr6qxSb9whflHNeOYJdnPRPVkMc+/JB3cruCxu356pvzHldpye
	lRJLcUaioRZzUXEiAOe4F49FAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xgK5O7K9Ag77POhZ37p5jtXh15AeT
	xYL91hadszewW2w+uI7FonfBVTaLxnsT2Cw+njrObrHp8TVWi8u75rBZzDi/j8niwoqN7BZT
	Fh1mtfj+7Rubxck/vYwWLdd7mSxefjzB4iDo8eTgPCaPNfPWMHrMbrjI4rFz1l12jzvX9rB5
	nN+0htlj85J6j8k3ljN69G1ZxejxeZOcx5WjZ5gCuKMaGG0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgL5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMY
	oesbEgTXY2SABhLWMWZs/ruIuWDPf8aK399vsTcwbpjN2MXIySEhYCKxefNJNghbTOLCvfVA
	NheHkMAiRonpbz4yQjh/GSUavjxlAaliE9CSWD33OFi3iICmxKUJ38FsZoH7rBL/lsdANDQw
	Ssy+PIW5i5GDg1MgWOLUPrBeYYEwib031oNtYxFQlXi29zmYzStgKbFvwnsmCFtQ4sfkeywQ
	M7Uk1u88zgRhy0tsXvOWGeJSBYkdZ18zgowXEbCS+LSgBqJERGLfi3eMExiFZiGZNAvJpFlI
	Js1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDyeia1g3Flg8UhRgEORiUe3oyt
	PwOFWBPLiitzDzFKcDArifA+1vgVKMSbklhZlVqUH19UmpNafIgxGejRicxSosn5wMSaVxJv
	aGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M4Ty/4rqqvWSWbP9x
	ZvLbC6cdPWbu/rudpdM49c+TU24PrJa90V1/SDDoQcjbn+/dimXfuBzVNej15jp9kI9pWiN3
	3Y3fTMIG+tcdT03m2a2peW3KvDlutzV9vlzKjzX4vCbL5POELUwn9pSuN4930bsyLTVvouD/
	C6dnHng9cc2ErD/6c3NV2JRYijMSDbWYi4oTAVE5FSqiAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Rob Herring [mailto:robherring2@gmail.com]
> Sent: Saturday, July 27, 2013 10:55 PM
> On Fri, Jul 26, 2013 at 6:28 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
> >  arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
> >  5 files changed, 617 insertions(+), 0 deletions(-)
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
> > +
> > +System MMU is a sort of IOMMU and support identical translation table format to
> > +ARMv7 translation tables with minimum set of page properties including access
> > +permissions, shareability and security protection. In addition, System MMU has
> > +another capabilities like L2 TLB or block-fetch buffers to minimize translation
> > +latency.
> > +
> > +A System MMU is dedicated to a single master peripheral device.  Thus, it is
> > +important to specify the correct System MMU in the device node of its master
> > +device. Whereas a System MMU is dedicated to a master device, the master device
> > +may have more than one System MMU.
> 
> I don't follow the last sentence. Can you elaborate on the type of
> connection you are talking about.
> 
Grant also addressed that.
He corrected the sentence like the following:

  " Can I suggest rewriting the last two sentences to:
     The master device node must correctly specify at least one
     SystemMMU. A master  device may have more than one System MMU. "

I will change the sentence

> Also, please align with the ARM system MMU binding that Will Deacon
> has submitted particularly in terms of how master connections are
> described.
> 
I didn't check it.

Should this align with ARM System MMU bindings?
System MMU in Exynos SoC is different from ARM System MMU.
It does not follows the specifications of ARM System MMU.

> Rob
> 
> > +
> > +Required properties:
> > +- compatible: Should be "samsung,exynos4210-sysmmu"
> > +- reg: A tuple of base address and size of System MMU registers.
> > +- interrupt-parent: The phandle of the interrupt controller of System MMU
> > +- interrupts: A tuple of numbers that indicates the interrupt source.
> > +- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
> > +               Please refer to the following documents:
> > +              Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +              Documentation/devicetree/bindings/clock/exynos4-clock.txt
> > +              Documentation/devicetree/bindings/clock/exynos5250-clock.txt
> > +              Optional "master" if the clock to the System MMU is gated by
> > +              another gate clock other than "sysmmu". The System MMU driver
> > +              sets "master" the parent of "sysmmu".
> > +              Exynos4 SoCs, there needs no "master" clocks.
> > +              Exynos5 SoCs, some System MMUs must have "master" clocks.
> > +- clocks: Required if the System MMU is needed to gate its clock.
> > +         Please refer to the documents listed above.
> > +- samsung,power-domain: Required if the System MMU is needed to gate its power.
> > +         Please refer to the following document:
> > +         Documentation/devicetree/bindings/arm/exynos/power_domain.txt
> > +
> > +Required properties for the master peripheral devices:
> > +- iommu: phandles to the System MMUs of the device
> > +
> > +Examples:
> > +A System MMU is dedicated to a single master device.
> > +       gsc_0:  gsc@0x13e00000 {
> > +               compatible = "samsung,exynos5-gsc";
> > +               reg = <0x13e00000 0x1000>;
> > +               interrupts = <0 85 0>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               clocks = <&clock 256>;
> > +               clock-names = "gscl";
> > +               iommu = <&sysmmu_gsc1>;
> > +       };
> > +
> > +       sysmmu_gsc0: sysmmu@13E80000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13E80000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-gsc0";
> > +               interrupts = <2 0>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 262>, <&clock 256>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +MFC has 2 System MMUs for each port that MFC is attached. Thus it seems natural
> > +to define 2 System MMUs for each port of the MFC:
> > +
> > +       mfc: codec@13400000 {
> > +               compatible = "samsung,mfc-v5";
> > +               reg = <0x13400000 0x10000>;
> > +               interrupts = <0 94 0>;
> > +               samsung,power-domain = <&pd_mfc>;
> > +               clocks = <&clock 170>, <&clock 273>;
> > +               clock-names = "sclk_mfc", "mfc";
> > +               status = "ok";
> > +               iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
> > +       };
> > +
> > +       sysmmu_mfc_l: sysmmu@13620000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13620000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-mfc-l";
> > +               interrupts = <5 5>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 274>;
> > +               samsung,power-domain = <&pd_mfc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_mfc_r: sysmmu@13630000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13630000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-mfc-r";
> > +               interrupts = <5 6>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 275>;
> > +               samsung,power-domain = <&pd_mfc>;
> > +               status = "ok";
> > +       };
> > +
> > diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
> > index 359694c..ba74ee8 100644
> > --- a/arch/arm/boot/dts/exynos4.dtsi
> > +++ b/arch/arm/boot/dts/exynos4.dtsi
> > @@ -161,6 +161,7 @@
> >                 interrupts = <0 94 0>;
> >                 samsung,power-domain = <&pd_mfc>;
> >                 status = "disabled";
> > +               iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
> >         };
> >
> >         serial@13800000 {
> > @@ -395,5 +396,126 @@
> >                 clock-names = "sclk_fimd", "fimd";
> >                 samsung,power-domain = <&pd_lcd0>;
> >                 status = "disabled";
> > +               iommu = <&sysmmu_fimd0>;
> > +       };
> > +
> > +       sysmmu_mfc_l: sysmmu@13620000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13620000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-mfc-l";
> > +               interrupts = <5 5>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 274>;
> > +               samsung,power-domain = <&pd_mfc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_mfc_r: sysmmu@13630000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13630000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-mfc-r";
> > +               interrupts = <5 6>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 275>;
> > +               samsung,power-domain = <&pd_mfc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_tv: sysmmu@13E20000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13E20000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-tv";
> > +               interrupts = <5 4>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 272>;
> > +               samsung,power-domain = <&pd_tv>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc0: sysmmu@11A20000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11A20000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc0";
> > +               interrupts = <4 2>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 263>;
> > +               samsung,power-domain = <&pd_cam>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc1: sysmmu@11A30000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11A30000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc1";
> > +               interrupts = <4 3>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 264>;
> > +               samsung,power-domain = <&pd_cam>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc2: sysmmu@11A40000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11A40000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc2";
> > +               interrupts = <4 4>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 265>;
> > +               samsung,power-domain = <&pd_cam>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc3: sysmmu@11A50000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11A50000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc3";
> > +               interrupts = <4 5>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 266>;
> > +               samsung,power-domain = <&pd_cam>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_jpeg: sysmmu@11A60000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11A60000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-jpeg";
> > +               interrupts = <4 6>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 267>;
> > +               samsung,power-domain = <&pd_cam>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_rotator: sysmmu@12A30000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x12A30000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-rotator";
> > +               interrupts = <5 0>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 281>;
> > +               samsung,power-domain = <&pd_lcd0>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimd0: sysmmu@11E20000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11E20000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimd0";
> > +               interrupts = <5 2>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 287>;
> > +               samsung,power-domain = <&pd_lcd0>;
> > +               status = "ok";
> >         };
> >  };
> > diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
> > index 54710de..09b13da 100644
> > --- a/arch/arm/boot/dts/exynos4210.dtsi
> > +++ b/arch/arm/boot/dts/exynos4210.dtsi
> > @@ -119,5 +119,30 @@
> >                 reg = <0x12800000 0x1000>;
> >                 interrupts = <0 89 0>;
> >                 status = "disabled";
> > +               iommu = <&sysmmu_g2d>;
> > +       };
> > +
> > +       sysmmu_g2d: sysmmu@12A20000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x12A20000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-g2d";
> > +               interrupts = <4 7>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 280>;
> > +               samsung,power-domain = <&pd_lcd0>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimd1: sysmmu@12220000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimd1";
> > +               reg = <0x12220000 0x1000>;
> > +               interrupts = <5 3>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 291>;
> > +               samsung,power-domain = <&pd_lcd1>;
> > +               status = "ok";
> >         };
> >  };
> > diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
> > index e3380a7..681db32 100644
> > --- a/arch/arm/boot/dts/exynos4x12.dtsi
> > +++ b/arch/arm/boot/dts/exynos4x12.dtsi
> > @@ -79,4 +79,80 @@
> >                 interrupts = <0 89 0>;
> >                 status = "disabled";
> >         };
> > +
> > +       sysmmu_g2d: sysmmu@10A40000{
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x10A40000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-g2d";
> > +               interrupts = <4 7>;
> > +               clock-names = "sysmmu";
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_isp: sysmmu@12260000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x12260000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_isp";
> > +               interrupts = <16 2>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 362>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_drc: sysmmu@12270000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x12270000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_drc";
> > +               interrupts = <16 3>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 363>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_fd: sysmmu@122A0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x122A0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_fd";
> > +               interrupts = <16 4>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 364>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_mcuctl: sysmmu@122B0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x122B0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_mcuctl";
> > +               interrupts = <16 5>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 376>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_lite0: sysmmu@123B0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x123B0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_lite0";
> > +               interrupts = <16 0>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 366>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_lite1: sysmmu@123C0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x123C0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_lite1";
> > +               interrupts = <16 1>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 365>;
> > +               status = "ok";
> > +       };
> >  };
> > diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> > index fc9fb3d..130d23d 100644
> > --- a/arch/arm/boot/dts/exynos5250.dtsi
> > +++ b/arch/arm/boot/dts/exynos5250.dtsi
> > @@ -66,6 +66,16 @@
> >                 reg = <0x10044040 0x20>;
> >         };
> >
> > +       pd_isp: mfc-power-domain@0x10044020 {
> > +               compatible = "samsung,exynos4210-pd";
> > +               reg = <0x10044020 0x20>;
> > +       };
> > +
> > +       pd_disp1: mfc-power-domain@0x100440A0 {
> > +               compatible = "samsung,exynos4210-pd";
> > +               reg = <0x100440A0 0x20>;
> > +       };
> > +
> >         clock: clock-controller@0x10010000 {
> >                 compatible = "samsung,exynos5250-clock";
> >                 reg = <0x10010000 0x30000>;
> > @@ -180,6 +190,7 @@
> >                 reg = <0x11000000 0x10000>;
> >                 interrupts = <0 96 0>;
> >                 samsung,power-domain = <&pd_mfc>;
> > +               iommu = <&sysmmu_mfc_l &sysmmu_mfc_l>;
> >         };
> >
> >         rtc {
> > @@ -571,6 +582,7 @@
> >                 samsung,power-domain = <&pd_gsc>;
> >                 clocks = <&clock 256>;
> >                 clock-names = "gscl";
> > +               iommu = <&sysmmu_gsc1>;
> >         };
> >
> >         gsc_1:  gsc@0x13e10000 {
> > @@ -580,6 +592,7 @@
> >                 samsung,power-domain = <&pd_gsc>;
> >                 clocks = <&clock 257>;
> >                 clock-names = "gscl";
> > +               iommu = <&sysmmu_gsc1>;
> >         };
> >
> >         gsc_2:  gsc@0x13e20000 {
> > @@ -589,6 +602,7 @@
> >                 samsung,power-domain = <&pd_gsc>;
> >                 clocks = <&clock 258>;
> >                 clock-names = "gscl";
> > +               iommu = <&sysmmu_gsc2>;
> >         };
> >
> >         gsc_3:  gsc@0x13e30000 {
> > @@ -598,6 +612,7 @@
> >                 samsung,power-domain = <&pd_gsc>;
> >                 clocks = <&clock 259>;
> >                 clock-names = "gscl";
> > +               iommu = <&sysmmu_gsc3>;
> >         };
> >
> >         hdmi {
> > @@ -614,6 +629,7 @@
> >                 compatible = "samsung,exynos5-mixer";
> >                 reg = <0x14450000 0x10000>;
> >                 interrupts = <0 94 0>;
> > +               iommu = <&sysmmu_tv>;
> >         };
> >
> >         dp-controller {
> > @@ -638,5 +654,280 @@
> >                 interrupts = <18 4>, <18 5>, <18 6>;
> >                 clocks = <&clock 133>, <&clock 339>;
> >                 clock-names = "sclk_fimd", "fimd";
> > +               iommu = <&sysmmu_fimd1>;
> > +       };
> > +
> > +       sysmmu_mfc_l: sysmmu@11210000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11210000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-mfc_l";
> > +               interrupts = <8 5>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 267>, <&clock 266>;
> > +               samsung,power-domain = <&pd_mfc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_mfc_r: sysmmu@11200000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11200000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-mfc_r";
> > +               interrupts = <6 2>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 268>, <&clock 266>;
> > +               samsung,power-domain = <&pd_mfc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_tv: sysmmu@14650000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x14650000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-tv";
> > +               interrupts = <7 4>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 349>;
> > +               samsung,power-domain = <&pd_disp1>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_gsc0: sysmmu@13E80000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13E80000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-gsc0";
> > +               interrupts = <2 0>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 262>, <&clock 256>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_gsc1: sysmmu@13E90000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13E90000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-gsc1";
> > +               interrupts = <2 2>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 263>, <&clock 257>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_gsc2: sysmmu@13EA0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13EA0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-gsc2";
> > +               interrupts = <2 4>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 264>, <&clock 258>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_gsc3: sysmmu@13EB0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13EB0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-gsc3";
> > +               interrupts = <2 6>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 265>, <&clock 259>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimd1: sysmmu@14640000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x14640000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimd1";
> > +               interrupts = <3 2>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 350>;
> > +               samsung,power-domain = <&pd_disp1>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_rotator: sysmmu@11D40000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11D40000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-rotator";
> > +               interrupts = <4 0>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 272>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_isp: sysmmu@13260000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13260000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_isp";
> > +               interrupts = <10 6>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 361>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_drc: sysmmu@13270000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13270000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_drc";
> > +               interrupts = <11 6>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 362>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_fd: sysmmu@132A0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x132A0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_fd";
> > +               interrupts = <5 0>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 363>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_scc: sysmmu@13280000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13280000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_scalerc";
> > +               interrupts = <5 2>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 364>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_scp: sysmmu@13290000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13290000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_scalerp";
> > +               interrupts = <3 6>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 365>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_mcuctl: sysmmu@132B0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x132B0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_mcuctl";
> > +               interrupts = <5 4>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 366>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_odc: sysmmu@132C0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x132C0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_odc";
> > +               interrupts = <11 0>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 367>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_dis0: sysmmu@132D0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x132D0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_dis0";
> > +               interrupts = <10 4>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 368>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_dis1: sysmmu@132E0000{
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x132E0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_dis1";
> > +               interrupts = <9 4>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 369>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_3dnr: sysmmu@132F0000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x132F0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_3dnr";
> > +               interrupts = <5 6>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 370>;
> > +               samsung,power-domain = <&pd_isp>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_lite0: sysmmu@13C40000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13C40000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_lite0";
> > +               interrupts = <3 4>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 346>, <&clock 345>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_lite1: sysmmu@13C50000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x13C50000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-fimc_lite1";
> > +               interrupts = <24 1>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 347>, <&clock 345>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_jpeg: sysmmu@11F20000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x11F20000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-jpeg";
> > +               interrupts = <4 2>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 273>, <&clock 270>;
> > +               samsung,power-domain = <&pd_gsc>;
> > +               status = "ok";
> > +       };
> > +
> > +       sysmmu_fimc_2d: sysmmu@10A60000 {
> > +               compatible = "samsung,exynos4210-sysmmu";
> > +               reg = <0x10A60000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupt-names = "sysmmu-2d";
> > +               interrupts = <24 5>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 361>;
> > +               status = "ok";
> >         };
> >  };
> > --
> > 1.7.2.5
> >
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

