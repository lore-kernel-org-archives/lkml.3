Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3JHEjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 00:39:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35775 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab3JHEi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 00:38:57 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-6c-52538c5ecb39
Date: Tue, 08 Oct 2013 13:38:53 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu, Rahul Sharma <rahul.sharma@samsung.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Message-id: <20131008133853.8b8277b70d69e05edd011945@samsung.com>
In-reply-to: <CAL_JsqLny8sOgn9y0Tm9-Vq_3YPdtqkr5nTJ67Y0Zx1hDmduNQ@mail.gmail.com>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <CAL_JsqLny8sOgn9y0Tm9-Vq_3YPdtqkr5nTJ67Y0Zx1hDmduNQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+ZkW5cT3CQwb6NPBZ37p5jtXh15AeT
	xYL91hadszewW2w+uI7FonfBVTaLxnsT2Cw+njrObrHp8TVWi8u75rBZzDi/j8niwoqN7BZT
	Fh1mtfj+7Rubxck/vYwWLdd7mSxefjzB4iDo8eTgPCaPNfPWMHrMbrjI4rFz1l12jzvX9rB5
	nN+0htlj85J6j8k3ljN69G1ZxejxeZOcx5WjZ5gCuKO4bFJSczLLUov07RK4MtacvcRW8EK+
	4vymeWwNjHcluhg5OCQETCSeT7TvYuQEMsUkLtxbz9bFyMUhJLCMUWLOn8OsEAkTiRXTO9kh
	EtMZJS51P2SCcCYxSTQtuckCUsUioCpx+c9ZMJtNQEti9dzjjCC2iIC6xLflx9lAbGaBvawS
	3z+XgNjCAmESKx7+AovzCjhKzFnUwQRicwoES3zY1sUOYgsJNDBKLH7HBnGFhcSFpg52iHpB
	iR+T77FAzNSS2LytiRXClpfYvOYtM8hxEgJHOCSuT3rEBnGcgMS3yYdYIF6Wldh0gBlipqTE
	wRU3WCYwis1CMnYWkrGzkIxdwMi8ilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkJUzcwXj/
	gPUhxmSglROZpUST84EpJa8k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW60AhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjCve3e1WWPNb5VeR7N73801qdP44NqzL1ApNnOKalvKPL1LF/6/Rbr8I
	ZkOZvmIGna/Ps1Rv3habnlV552lCgZDGbC7h6yU5m28V3i7YOu1+aXX7EodrfN+We4cu9lHP
	Y1FfwlrhUWt5SWR5QmCG1y7xJ2q77teK3Y+adfhoBWv8pUVfVgROVGIpzkg01GIuKk4EABw6
	GMIfAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t9jQd24nuAgg3vtbBZ37p5jtXh15AeT
	xYL91hadszewW2w+uI7FonfBVTaLxnsT2Cw+njrObrHp8TVWi8u75rBZzDi/j8niwoqN7BZT
	Fh1mtfj+7Rubxck/vYwWLdd7mSxefjzB4iDo8eTgPCaPNfPWMHrMbrjI4rFz1l12jzvX9rB5
	nN+0htlj85J6j8k3ljN69G1ZxejxeZOcx5WjZ5gCuKMaGG0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgL5SUihLzCkFCgUkFhcr6dthmhAa4qZrAdMY
	oesbEgTXY2SABhLWMWasOXuJreCFfMX5TfPYGhjvSnQxcnJICJhIrJjeyQ5hi0lcuLeerYuR
	i0NIYDqjxKXuh0wQziQmiaYlN1lAqlgEVCUu/zkLZrMJaEmsnnucEcQWEVCX+Lb8OBuIzSyw
	l1Xi++cSEFtYIExixcNfYHFeAUeJOYs6mEBsToFgiQ/busA2Cwk0MEosfscGcYWFxIWmDnaI
	ekGJH5PvsUDM1JLYvK2JFcKWl9i85i3zBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4JTzTHoH46oGi0OMAhyMSjy8AoeDgoRYE8uKK3MPMUpwMCuJ8AoYBQcJ
	8aYkVlalFuXHF5XmpBYfYkwGhsZEZinR5HxgOswriTc0NjEzsjQyszAyMTcnTVhJnPdgq3Wg
	kEB6YklqdmpqQWoRzBYmDk6pBkaG6hfFFw7Pm3KD02l7/cmTz+KquCLVnm91FoguTRN2Efp5
	6Xm5mtIFHfazTbH/atc8e2AZIb1ISeB2jdjZwu2s/+f8vp/Go3Blu3pcR2//y+vF16y33DmS
	qfgmpaXj3ds1GY/eqO34bSawZpfvIk+F3xlpfAWiup8zfarevpbOPBEeUq+rVaXEUpyRaKjF
	XFScCABz0lcmfQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Oct 2013 08:44:54 -0500, Rob Herring wrote:
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
> 
> You have not addressed my comments from the last version. We do not
> need 2 (or more) different ways to describe the connection between
> masters and iommu's. Use mmu-masters property here to describe the
> connection.
> 

Sorry, I forgot to reply.
I just thought the meaning of your comment that it should be align with ARM System MMU.
I now understand and it should be changed to mmu-masters property
because it is now in the kernel.

Thank you.


> Rob
