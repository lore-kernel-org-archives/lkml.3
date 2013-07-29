Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3G2H51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:57:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42404 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3G2H5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:57:24 -0400
X-AuditID: cbfee691-b7fef6d000002d62-86-51f620624a3a
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
In-reply-to: 
Subject: RE: [PATCH v8 06/12] ARM: dts: Add description of System MMU of Exynos
 SoCs
Date: Mon, 29 Jul 2013 16:57:22 +0900
Message-id: <003e01ce8c31$41d0c450$c5724cf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQJ8iaVttThmxHyrdfHNT5d6MXLI1gKK1rNQmArt9KCAAAm2sA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t8zA90khW+BBtP2mFncuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujNZ/7awFm7gqTk96xNbA+Ja9i5GTQ0LARGLJ1sNs
	ELaYxIV764FsLg4hgWWMEv0fj8IVda3YxAyRmM4o8W7fRSYI5y+jRPvCk4wgVWwCWhKr5x4H
	s0UEdCRW7FoLVsQs0MMq8fvnHKi5DYwSK2cdA1vIKcAjse5PJzOILSwQJrH3xnqwOIuAqsTh
	OX1gcV4BS4mPC1cyQdiCEj8m32MBsZmBtq3feZwJwpaX2LzmLTPErQoSO86+ZoSIi0jse/EO
	6iIniQcbjjCCHCEhcIBDon/WO3aIZQIS3yYfAhrKAZSQldh0AGqOpMTBFTdYJjBKzEKyehaS
	1bOQrJ6FZN0CRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCGJY+IOxvsHrA8xJgOtn8gs
	JZqcD0w8eSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgvLDWrEZR+ua1NVVBM37Vypxy6p98f8HUzw0KksurXtTc5hS591vOXSg1JlBvlfzJ8oBV
	8wy1i9O/b+LO1GQPNZ9UHFjOrnfq4abgekbpiU+u3grmzHEKeFM3OyroMJ9c5Te7Kyv35Enr
	Cn/lZK07r7BxRm4i15LOjtsMZvo7c3lZxcyf/RVXYinOSDTUYi4qTgQAeNv5DzIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsVy+t9jQd0khW+BBlu+GFjcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBmt/9pZCzZx
	VZye9IitgfEtexcjJ4eEgIlE14pNzBC2mMSFe+vZuhi5OIQEpjNKvNt3kQnC+cso0b7wJCNI
	FZuAlsTqucfBbBEBHYkVu9aCFTEL9LBK/P45B6q9gVFi5axjbCBVnAI8Euv+dILtEBYIk9h7
	Yz1YnEVAVeLwnD6wOK+ApcTHhSuZIGxBiR+T77GA2MxA29bvPM4EYctLbF7zFupWBYkdZ18z
	QsRFJPa9eAd1kZPEgw1HGCcwCs1CMmoWklGzkIyahaR9ASPLKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgtPRMegfjqgaLQ4wCHIxKPLwPnL4ECrEmlhVX5h5ilOBgVhLh5TD6GijEm5JY
	WZValB9fVJqTWnyIMRno04nMUqLJ+cCUmVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjLNevFfb9Ob4tfBt/77UOS1+cZJpgsG+xjkz8yU5a6PsVrx3b171
	5ObHR4EcpmeWMFj/ae47r2A7a1b/i+sP13faXT4V9Ftlu9UN9aTFptKTih0WTX1nFJSznkU+
	XdPsFe8L+1n79B1qnyp/2yO1X3TxF4ZKhdhTLCyepX43ZivF3Hzk0VH2rEOJpTgj0VCLuag4
	EQCmLnKgjwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Cho KyongHo [mailto:pullip.cho@samsung.com]
> Sent: Monday, July 29, 2013 4:20 PM
> 
> > -----Original Message-----
> > From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> > Sent: Monday, July 29, 2013 3:38 PM
> >
> > Hi KyongHo,
> >
> > On 26 July 2013 16:58, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > ---
> > >  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
> > >  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
> > >  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
> > >  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
> > >  arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
> > >  5 files changed, 617 insertions(+), 0 deletions(-)
> > >  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
> >
> > This patch does not apply on the mainline Linus' tree (3.11-rc2). Please rebase.
> >
> 
> OK. I will rebase the next patches on that.

I don't get any conflict both on the latest of Linus's tree (3.11-rc3)
and for-next branch  of Samsung git.
Can you show me the diff?

> 
> Thank you.
> 
> Cho KyongHo.
> > --
> > With warm regards,
> > Sachin

