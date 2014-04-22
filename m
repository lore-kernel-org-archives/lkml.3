Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaDVMge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:36:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25823 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbaDVMgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:36:31 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-f7-5356624abc18
Date: Tue, 22 Apr 2014 21:36:25 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
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
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 12/27] ARM: dts: Add description of System MMU of
 Exynos SoCs
Message-id: <20140422213625.e5470ec6680bd4c875f0f02f@samsung.com>
In-reply-to: <CAOD6ATr56P03Y3GChOTfTSHGrokU3do-YcRhk_voXSKcJVi8mA@mail.gmail.com>
References: <20140314140649.dc5958f420770af48e2376d9@samsung.com>
 <CAOD6ATr56P03Y3GChOTfTSHGrokU3do-YcRhk_voXSKcJVi8mA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+Zga5XUliwwdMlChZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C16F1xls9j0+BqrxeVdc9gsZpzfx2RxYcVGdospiw6zWhx+085qcfJP
	L6PFup2T2C3Wz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx85Zd9k97lzbw+axeUm9x+Qb
	yxk9+rasYvT4vEnO48rRM0wBXFFcNimpOZllqUX6dglcGS8eXWUteBBccWzZJrYGxnUmXYyc
	HBICJhJf7z1ghbDFJC7cW8/WxcjFISSwjFGi+cNDFpiihX+6mUFsIYHpjBJd31QgiiYzSUzf
	foypi5GDg0VAVWJpvyhIDZuAlsTquccZQWwRAX2JE/e7mUBsZoHFrBIfHsuD2MIC4RK3Zz0A
	m88r4Chx89hksBpOgWCJ80c3M0HM72CU6J3WzQZxhIXEhaYOdogGQYkfk++xQAzVkti8rYkV
	wpaX2LzmLTNE/RYOiR194SA2i4CAxLfJh1hA7pQQkJXYdACqRFLi4IobLBMYxWYhmToLydRZ
	SKYuYGRexSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRES/X07GG8esD7EmAy0ciKzlGhyPjB5
	5JXEGxqbGVmYmpgaG5lbmpEmrCTOu+hhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxkls
	whrCv76FC8lxyk3r0ai+aVqW3/GNu+/PykC/X8kBm9bs60qwZXHr7JjJs69B3XYTm9xpA9uT
	Ub68G2XmOm26HD+Ht0t3xxnLLZxFeiUxZYnhiffNLk/5FLBhwomQHU4ns/pb9cqvvSlY/oG/
	Zp3h3SW3PySdq5nBKqgXfU5U/dWPDvYSJZbijERDLeai4kQAcTqO7RQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jQV2vpLBgg20TJS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLdTsnsVusn/GaxWLmrTUsDgIeTw7OY/KY3XCRxePf4X4mj52z7rJ73Lm2h81j85J6j8k3
	ljN69G1ZxejxeZOcx5WjZ5gCuKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MWa8eHSVteBBcMWxZZvYGhjXmXQxcnJICJhILPzTzQxhi0lcuLeeDcQWEpjOKNH1TaWLkQvI
	nswkMX37MaYuRg4OFgFViaX9oiA1bAJaEqvnHmcEsUUE9CVO3O9mArGZBRazSnx4LA9iCwuE
	S9ye9YAFxOYVcJS4eWwyWA2nQLDE+aObmSDmdzBK9E7rZoM4wkLiQlMHO0SDoMSPyfdYIIZq
	SWze1sQKYctLbF7zlnkCo8AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwcnkmtYNxZYPFIUYBDkYlHl4Jg9BgIdbEsuLK3EOMEhzMSiK8ryLCgoV4UxIrq1KL8uOL
	SnNSiw8xJgNDYyKzlGhyPjDx5ZXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUg
	tQhmCxMHp1QDo0PXL+E9BSdfvFkZounUdivDS5PvfnTio6uBGbuil88Te+CwSW9PzWuDnadP
	/G89PldeupClZ86hOVOPfOw5xp6p+yXjyS8nnkWbE2v+cZ6s9+7r+96XvH+9+coywe77JyS3
	d0ZNOB605Ff2xjo+9jcF3N0Bp766ukmkXD2Ucunri0JpT/Elj5VYijMSDbWYi4oTAVKzChdy	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2014 15:25:59 +0530, Shaik Ameer Basha wrote:
> Hi KyongHo Cho,
> 
> Please find the comments inline.
> 
> On Fri, Mar 14, 2014 at 10:36 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > This patch adds dts entries for the System MMU devices found on
> > Exynos4 and Exynos5 SoC series and the System MMU binding
> > documentation.
> >
> > CC: Rob Herring <robherring2@gmail.com>
> > CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   86 +++++++
> >  arch/arm/boot/dts/exynos4.dtsi                     |  107 ++++++++
> >  arch/arm/boot/dts/exynos4210.dtsi                  |   23 +-
> >  arch/arm/boot/dts/exynos4x12.dtsi                  |   77 +++++-
> >  arch/arm/boot/dts/exynos5250.dtsi                  |  266 +++++++++++++++++++-
> >  arch/arm/boot/dts/exynos5420.dtsi                  |  205 ++++++++++++++-
> >  6 files changed, 758 insertions(+), 6 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
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
> 
> [snip]
> 
> 
> > diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> > index 8f6300f..df336ea 100644
> > --- a/arch/arm/boot/dts/exynos5250.dtsi
> > +++ b/arch/arm/boot/dts/exynos5250.dtsi
> > @@ -80,6 +80,16 @@
> >                 reg = <0x10044040 0x20>;
> >         };
> >
> > +       pd_isp: isp-power-domain@0x10044020 {
> > +               compatible = "samsung,exynos4210-pd";
> > +               reg = <0x10044020 0x20>;
> > +       };
> > +
> > +       pd_disp1: disp1-power-domain@0x100440A0 {
> > +               compatible = "samsung,exynos4210-pd";
> > +               reg = <0x100440A0 0x20>;
> > +       };
> > +
> >         clock: clock-controller@10010000 {
> >                 compatible = "samsung,exynos5250-clock";
> >                 reg = <0x10010000 0x30000>;
> > @@ -679,7 +689,7 @@
> >                                 "sclk_hdmiphy", "mout_hdmi";
> >         };
> >
> > -       mixer {
> > +       mixer: mixer {
> >                 compatible = "samsung,exynos5250-mixer";
> >                 reg = <0x14450000 0x10000>;
> >                 interrupts = <0 94 0>;
> > @@ -700,7 +710,7 @@
> >                 phy-names = "dp";
> >         };
> >
> > -       fimd@14400000 {
> > +       fimd: fimd@14400000 {
> >                 clocks = <&clock 133>, <&clock 339>;
> >                 clock-names = "sclk_fimd", "fimd";
> >         };
> > @@ -715,4 +725,256 @@
> >                 io-channel-ranges;
> >                 status = "disabled";
> >         };
> > +
> > +       sysmmu_g2d: sysmmu@10A60000 {
> > +               compatible = "samsung,sysmmu-v1";
> > +               reg = <0x10A60000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <24 5>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 361>;
> > +       };
> > +
> > +       sysmmu_mfc_r: sysmmu@11200000 {
> > +               compatible = "samsung,sysmmu-v2";
> > +               reg = <0x11200000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <6 2>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 268>, <&clock 266>;
> 
> Add mmu-masters...
>                     mmu-masters = <&mfc>;
> 

Ok.

> > +               samsung,power-domain = <&pd_mfc>;
> > +       };
> > +
> > +       sysmmu_mfc_l: sysmmu@11210000 {
> > +               compatible = "samsung,sysmmu-v2";
> > +               reg = <0x11210000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <8 5>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 267>, <&clock 266>;
> 
> Add mmu-masters...
>                     mmu-masters = <&mfc>;
> 

OK.

> 
> > +               samsung,power-domain = <&pd_mfc>;
> > +       };
> > +
> > +       sysmmu_rotator: sysmmu@11D40000 {
> > +               compatible = "samsung,sysmmu-v1";
> > +               reg = <0x11D40000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <4 0>;
> > +               clock-names = "sysmmu";
> > +               clocks = <&clock 272>;
> > +       };
> > +
> 
> [snip]
> 
> >  };
> > diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> > index 45e2e65..a736f09 100644
> > --- a/arch/arm/boot/dts/exynos5420.dtsi
> > +++ b/arch/arm/boot/dts/exynos5420.dtsi
> > @@ -470,7 +470,7 @@
> >                 phy-names = "dp";
> >         };
> >
> > -       fimd@14400000 {
> > +       fimd: fimd@14400000 {
> >                 samsung,power-domain = <&disp_pd>;
> >                 clocks = <&clock 147>, <&clock 421>;
> >                 clock-names = "sclk_fimd", "fimd";
> > @@ -641,7 +641,7 @@
> >                 status = "disabled";
> >         };
> >
> > -       mixer@14450000 {
> > +       mixer: mixer@14450000 {
> >                 compatible = "samsung,exynos5420-mixer";
> >                 reg = <0x14450000 0x10000>;
> >                 interrupts = <0 94 0>;
> > @@ -720,4 +720,205 @@
> >                 clock-names = "watchdog";
> >                 samsung,syscon-phandle = <&pmu_system_controller>;
> >          };
> > +
> > +       sysmmu_g2dr: sysmmu@10A60000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x10A60000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <24 5>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 482>, <&clock 481>;
> > +       };
> > +
> > +       sysmmu_g2dw: sysmmu@10A70000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x10A60000 0x1000>;
> 
> Duplicate sysmmu reg base address.
>                     reg = <0x10A70000 0x1000>;
> 

Oh, really it is.
Thanks.

> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <22 2>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 482>, <&clock 481>;
> > +       };
> > +
> > +       sysmmu_scaler0r: sysmmu@12880000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x12880000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <22 4>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 384>, <&clock 381>;
> > +       };
> > +
> > +       sysmmu_scaler1r: sysmmu@12890000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x12890000 0x1000>;
> > +               interrupts = <0 186 0>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 385>, <&clock 382>;
> > +       };
> > +
> > +       sysmmu_scaler2r: sysmmu@128A0000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x128A0000 0x1000>;
> > +               interrupts = <0 188 0>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 386>, <&clock 383>;
> > +       };
> > +
> > +       sysmmu_scaler0w: sysmmu@128C0000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x128C0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <27 2>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 384>, <&clock 381>;
> > +       };
> > +
> > +       sysmmu_scaler1w: sysmmu@128D0000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x128D0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <22 6>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 385>, <&clock 382>;
> > +       };
> > +
> > +       sysmmu_scaler2w: sysmmu@128E0000 {
> > +               compatible = "samsung,sysmmu-v3.2";
> > +               reg = <0x128E0000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <19 6>;
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 386>, <&clock 383>;
> > +       };
> > +
> > +       sysmmu_mfc_r: sysmmu@11200000 {
> 
> 0x11200000 belongs to mfc_l
>              sysmmu_mfc_l: sysmmu@11200000
> 

OK. thanks.

> > +               compatible = "samsung,sysmmu-v2";
> > +               reg = <0x11200000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <6 2>;
> 
>                     interrupts = <8 5>;
> Add mmu-masters field,
>                     mmu-masters = <&mfc>;

Oh, irq is also changed.
Thanks.

> 
> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 402>, <&clock 401>;
> 
> clocks = <&clock 403>, <&clock 401>;

Thanks.

This will be fixed with macro names.

> 
> > +               samsung,power-domain = <&mfc_pd>;
> > +       };
> > +
> > +       sysmmu_mfc_l: sysmmu@11210000 {
> 
> 0x11210000 belongs to mfc_r
>                     sysmmu_mfc_r: sysmmu@11210000
> 

OK.

> > +               compatible = "samsung,sysmmu-v2";
> > +               reg = <0x11210000 0x1000>;
> > +               interrupt-parent = <&combiner>;
> > +               interrupts = <8 5>;
> 
> interrupts = <6 2>;
> Add mmu-masters field,
>                     mmu-masters = <&mfc>;
> 

OK. 

> > +               clock-names = "sysmmu", "master";
> > +               clocks = <&clock 403>, <&clock 401>;
> 
> clocks = <&clock 402>, <&clock 401>;
> 

Thanks for pointing out many mistakes.

Regards,

KyongHo
