Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3HANMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:12:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19548 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3HANMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:12:17 -0400
X-AuditID: cbfee68e-b7f276d000002279-1d-51fa5eaf0e93
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
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
        kvmarm@lists.cs.columbia.edu
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
 <CAK9yfHy2btp1W+5-GiVQnkffDnJ-CgqXuAjGktkiKYyf7kKQbQ@mail.gmail.com>
 <003e01ce8c31$41d0c450$c5724cf0$@samsung.com>
 <CAK9yfHyeOQZzf_3Nv-fmuYdZtL8dzZequdx2ZddnUyXDn66bOg@mail.gmail.com>
In-reply-to: <CAK9yfHyeOQZzf_3Nv-fmuYdZtL8dzZequdx2ZddnUyXDn66bOg@mail.gmail.com>
Subject: RE: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Date: Thu, 01 Aug 2013 22:12:14 +0900
Message-id: <003901ce8eb8$bdd877d0$39896770$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ8iaVttThmxHyrdfHNT5d6MXLI1gKK1rNQAewNtlkB5jODhpfxdF5w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t8zY931cb8CDZZdl7W4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLeY
	sugwq8XJP72MFi3Xe5kc+D2eHJzH5DG74SKLx51re9g8zm9aw+yxeUm9x+Qbyxk9+rasYvT4
	vEnO48rRM0wBnFFcNimpOZllqUX6dglcGe//nmYpaBerWLzlL3sD4yHBLkYODgkBE4kZtw27
	GDmBTDGJC/fWs3UxcnEICSxjlOh4MZsRImEi0dy+nBUisYhR4sKaCVBVfxkldk9/zQpSxSag
	JbF67nGwDhEBHYkVu9YygRQxC/SwSvz+OQeq4zujxNWWC2BVnALBEgtefQCzhQXCJPbeAFnO
	ycEioCqxvvkC2FReAUuJ9RPesEDYghI/Jt8Ds5mBtq3feZwJwpaX2LzmLTPErQoSO86+hrrC
	TWL/zVZmiBoRiX0v3jGCHCEhcIBD4mrjJ2aIZQIS3yYfYoEEhqzEpgNQcyQlDq64wTKBUWIW
	ktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQISRt9OxhvHrA+xJgM
	tH4is5Rocj4w7eSVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgdHuzFnz0I8lZ3SeC330PNZesXxK3lQm3YgMo7zXt2ckF/TxCly1bY+RsPR+MSmt
	WnS31fTiicUHtXJOP+XRVi1rXF60Wvupi+51zrw9LEJ9UzK05l+8um2ZlR/vyTdmyizyrFI6
	q9m7Gh62h/fd4p75+IiT28l1fuf2xX86Fbw/PtDu6V7xF0osxRmJhlrMRcWJACceKg0xAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t9jAd31cb8CDe5sFLe4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLeY
	sugwq8XJP72MFi3Xe5kc+D2eHJzH5DG74SKLx51re9g8zm9aw+yxeUm9x+Qbyxk9+rasYvT4
	vEnO48rRM0wBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDPe/z3NUtAu
	VrF4y1/2BsZDgl2MnBwSAiYSze3LWSFsMYkL99azdTFycQgJLGKUuLBmApTzl1Fi9/TXYFVs
	AloSq+ceZwSxRQR0JFbsWssEUsQs0MMq8fvnHKiO74wSV1sugFVxCgRLLHj1AcwWFgiT2HsD
	ZAcnB4uAqsT65gtgU3kFLCXWT3jDAmELSvyYfA/MZgbatn7ncSYIW15i85q3zBC3KkjsOPsa
	6go3if03W5khakQk9r14xziBUWgWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIEp6Vn0jsYVzVYHGIU4GBU4uHN2PozUIg1say4MvcQowQHs5II72ONX4FCvCmJ
	lVWpRfnxRaU5qcWHGJOBPp3ILCWanA9MmXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhP
	LEnNTk0tSC2C2cLEwSnVwLg2Ke7IvvsdGZN+8hRG9m0PeB2+59C8LY+D1K9U+DT8enKlcVrN
	vauafWeTV094mR93h/Hbxgk98sEfJ9Xu/DLj/9NKoQxpS43nFe8uOPs9Wmwrt0atTqe78nxv
	i2nKUsZ5j0t+b7li/f516Sop6QSWRRO+fTOIcdxxLe+KVizv2sytyZeVLLKUWIozEg21mIuK
	EwEguX90jwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Monday, July 29, 2013 5:05 PM
> 
> On 29 July 2013 13:27, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >> -----Original Message-----
> >> From: Cho KyongHo [mailto:pullip.cho@samsung.com]
> >> Sent: Monday, July 29, 2013 4:20 PM
> >>
> >> > -----Original Message-----
> >> > From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> >> > Sent: Monday, July 29, 2013 3:38 PM
> >> >
> >> > Hi KyongHo,
> >> >
> >> > On 26 July 2013 16:58, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >> > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> >> > > ---
> >> > >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> >> > >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> >> > >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> >> > >  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
> >> > >  arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
> >> > >  5 files changed, 617 insertions(+), 0 deletions(-)
> >> > >  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> >> >
> >> > This patch does not apply on the mainline Linus' tree (3.11-rc2). Please rebase.
> >> >
> >>
> >> OK. I will rebase the next patches on that.
> >
> > I don't get any conflict both on the latest of Linus's tree (3.11-rc3)
> > and for-next branch  of Samsung git.
> > Can you show me the diff?
> >
> 
> I get the following error when I do git am on this patch (linus' tree
> 3.11-rc3). Other patches apply fine.
> 
> Applying: ARM: dts: Add description of System MMU of Exynos SoCs
> <local_path>/linux/.git/rebase-apply/patch:120: new blank line at EOF.
> +
> error: patch failed: arch/arm/boot/dts/exynos4.dtsi:161
> error: arch/arm/boot/dts/exynos4.dtsi: patch does not apply
> error: patch failed: arch/arm/boot/dts/exynos4210.dtsi:119
> error: arch/arm/boot/dts/exynos4210.dtsi: patch does not apply
> error: patch failed: arch/arm/boot/dts/exynos4x12.dtsi:79
> error: arch/arm/boot/dts/exynos4x12.dtsi: patch does not apply
> error: patch failed: arch/arm/boot/dts/exynos5250.dtsi:614
> error: arch/arm/boot/dts/exynos5250.dtsi: patch does not apply
> Patch failed at 0001 ARM: dts: Add description of System MMU of Exynos SoCs
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
> 

I wonder why you get the errors.
The error message shows the patch has extra blank line after the mark of EOF.
Or, maybe the patch I posted omitted some format information...

> --
> With warm regards,
> Sachin

