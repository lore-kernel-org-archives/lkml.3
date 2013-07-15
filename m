Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3GOLYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:24:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65417 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab3GOLYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:24:33 -0400
X-AuditID: cbfee691-b7fef6d000002d62-20-51e3dbed2b99
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>
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
        "'Doug Anderson'" <dianders@chromium.org>
References: <002801ce797b$3d2fbc80$b78f3580$@samsung.com>
 <CANEJEGvajhgzUPG6ppbjwBb4-9TdU9em3T_SejBpz8NCjGHYTQ@mail.gmail.com>
In-reply-to: <CANEJEGvajhgzUPG6ppbjwBb4-9TdU9em3T_SejBpz8NCjGHYTQ@mail.gmail.com>
Subject: RE: [PATCH v7 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Mon, 15 Jul 2013 20:24:29 +0900
Message-id: <009b01ce814d$def7a6c0$9ce6f440$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHImoHYg6CdDvKKKhqc0+dxpB73qAL6z534mVmPq4A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zge7b248DDW5+MbE4u+wgm8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGax6fE1VovLu+awWcw4v4/J4sKKjewWUxYdZrVo
	ud7L5MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT36tqxi9Pi8SS6APYrLJiU1J7MstUjf
	LoErY9GXNraC3cIV83b8YWlgPMjfxcjJISFgIrGjeTobhC0mceHeeiCbi0NIYBmjxPyvr1hg
	in5eus8MYgsJTGeUWPZSG6LoL6PEuk9N7CAJNgEtidVzjzN2MXJwiAjoSMxfYg9SwyywiUXi
	0P9lrBANDYwSz+8fZARp4BQIljh+fSJQMzuHsECixGVnkCiLgKrE2edzwfbyClhKXN3zEMoW
	lPgx+R4LyHhmAXWJKVNyQcLMAvISm9e8ZYY4U0Fix9nXYMNFBKwkXjV/YIKoEZHY9+IdI8gF
	EgIrOSSeNu5jhNglIPFt8iGwmRICshKbDkDNkZQ4uOIGywRGiVlINs9C2DwLyeZZSDYsYGRZ
	xSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRGSBCbuYLx/wPoQYzLQ9onMUqLJ+cAkklcSb2hs
	ZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpBLR6r39c/k
	nX3YLFfwqMGz6U+Ld/2SjRDm2bT91jmGGdPybZ056z9U7HgY4c6+PSfs1KO7L1n/XN/1YK/8
	2S3bllyv0z0378Gd79YMfyNUAiuUDz1/NrlC1UL2hUmZO8PucteOlDfTTnV+EWxoaNl50aQx
	tPTs1oeKL9S4F/3etmvDZMXAVUuUWIozEg21mIuKEwFA7b0+GAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQd23tx8HGtyao29xdtlBNotXR34w
	WSzYb23ROXsDu8Xmg+tYLHoXXGWzaLw3gc1i0+NrrBaXd81hs5hxfh+TxYUVG9ktpiw6zGrR
	cr2XyYHX48nBeUwesxsusnjcubaHzWPzknqPyTeWM3r0bVnF6PF5k1wAe1QDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0LVKCmWJOaVAoYDE4mIl
	fTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoxFX9rYCnYLV8zb8YelgfEgfxcjJ4eEgInEz0v3
	mSFsMYkL99azgdhCAtMZJZa91O5i5AKy/zJKrPvUxA6SYBPQklg99zhjFyMHh4iAjsT8JfYg
	NcwCm1gkDv1fxgrR0MAo8fz+QUaQBk6BYInj1ycCNbNzCAskSlx2BomyCKhKnH0+lwXE5hWw
	lLi65yGULSjxY/I9FpDxzALqElOm5IKEmQXkJTaveQt1poLEjrOvwYaLCFhJvGr+wARRIyKx
	78U7xgmMQrOQTJqFMGkWkkmzkHQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcYp5J
	7WBc2WBxiFGAg1GJh/eAxuNAIdbEsuLK3EOMEhzMSiK8Sy8ChXhTEiurUovy44tKc1KLDzEm
	A/05kVlKNDkfmP7ySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNT
	qoFxU7Nv/c/r+yQeNXj3Sr44Pmty+cVFOw0UZjaeOyYfcN2gYs6l2XJ65z9srks9e7FMN1n5
	h9p1mc1pcQF2s46sm7727hrvhybt0yat33yilGE3j1Sgq5zQkuxz01Z1LF5WkHZ3q6f7pe9X
	rpZmnznPOn92yNLSsCsu/GWzLyrfv59XVFL78g7LaSWW4oxEQy3mouJEAOWg4GR1AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> Sent: Friday, July 12, 2013 2:23 AM
> 
> On Fri, Jul 5, 2013 at 5:29 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > The current exynos-iommu(System MMU) driver does not work autonomously
> > since it is lack of support for power management of peripheral blocks.
> ...
> > Patch summary:
> > [PATCH v7 1/9] iommu/exynos: do not include removed header
> > [PATCH v7 2/9] iommu/exynos: add missing cache flush for removed page table entries
> > [PATCH v7 3/9] iommu/exynos: fix page table maintenance
> > [PATCH v7 4/9] iommu/exynos: allocate lv2 page table from own slab
> > [PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
> > [PATCH v7 6/9] clk: exynos5250: add gate clock descriptions of System MMU
> > [PATCH v7 7/9] ARM: dts: Add description of System MMU of Exynos SoCs
> > [PATCH v7 8/9] iommu/exynos: support for device tree
> > [PATCH v7 9/9] iommu/exynos: add bus notifier for registering System MMU
> 
> Cho,
> Of the above patches, nearly all have been applied to chromeos-3.8
> (kernel-next git tree) by Doug Anderson and others.
> 
> AFAICT, the only ones not applied are:
>    [v7,3/9] iommu/exynos: fix page table maintenance
>    [v7,6/9] clk: exynos5250: add gate clock descriptions of System MMU
> (conflicts in this one)
>    [v7,7/9] ARM: dts: Add description of System MMU of Exynos SoCs
> (depends on 6/9)
> 
> We also already have parts of:
>    [v7,9/9] iommu/exynos: add bus notifier for registering System MMU
> 
> Some of those are being further discussed but I've lost track now
> exactly which ones.
> 
> I'm telling you about chromeos-3.8 status since the adopted changes
> have been reviewed (by me and others) are being tested manually here
> on several different Samsung Exynos platforms (including 5250 which is
> our "snow" platform). Not sure how you should to mark those patches
> since they aren't identical to your changes (which apply to post 3.10
> kernels, not 3.8).  You might consider splitting those patches out
> from the 4 I've listed above to get that series accepted upstream
> since the additional review/testing should provide some confidence
> those patches are good.
> 

I understand what you are concerning about.
Have you applied v6 patchset?

I will try to split the patches and make the changes from v6
on top of the v6 patcheset.

> cheers,
> grant

Thank you.

Cho KyonogHo.

