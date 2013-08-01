Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3HANOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 09:14:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31250 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3HANOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 09:14:05 -0400
X-AuditID: cbfee691-b7fef6d000002d62-45-51fa5f1b8ef1
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>
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
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
References: <003d01ce89f3$44ec2cf0$cec486d0$@samsung.com>
 <1743111.Ek7FldnHal@flatron>
In-reply-to: <1743111.Ek7FldnHal@flatron>
Subject: RE: [PATCH v8 07/12] iommu/exynos: support for device tree
Date: Thu, 01 Aug 2013 22:14:03 +0900
Message-id: <003a01ce8eb8$fe946db0$fbbd4910$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHQ5YhAg1lAtZVFxjYlVA5zIV5HFAK85i+ZmWW/ikA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zfV3p+F+BBtd6DS3u3D3HavHqyA8m
	iwX7rS06Z29gt9h8cB2LRe+Cq2wWjfcmsFl8PHWc3WLT42usFpd3zWGzmHF+H5PFhRUb2S2m
	LDrManHyTy+jRcv1XiaLVbv+MDoIeDw5OI/JY3bDRRaPnbPusnvcubaHzeP8pjXMHpuX1HtM
	vrGc0aNvyypGj8+b5DyuHD3DFMAVxWWTkpqTWZZapG+XwJXxZtYyloLF3BWnTm9lb2D8zdHF
	yMEhIWAicfSubhcjJ5ApJnHh3no2EFtIYBmjROf/WIi4icTSUxsZuxi5gOLTGSUunG1ignD+
	MkrsO9/PBFLFJqAlsXrucUYQW0RAU+LYk2fsIEXMAttYJZqfXmGFGBshcaq/kRnE5gQq+jj5
	Bdg6YQFniVcNF8GaWQRUJWZMhxjKK2ApceFGDzuELSjxY/I9FhCbGWjZ+p3HmSBseYnNa94y
	Q5yqILHj7GtGkM9EBKwk/t7SgygRkdj34h3YBxICFzgk/i2+A7VLQOLb5EMskJCQldh0AGqM
	pMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFJ
	ZOIOxvsHrA8xJgOtn8gsJZqcD0xCeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGan
	phakFsUXleakFh9iZOLglGpgnHImuat2n9Oe+f75L3JOqh8W6o65EfZX5oPpr2BTRqPDPgt+
	h59nYWEQjkmr10w8yJ6yIufy4hJnb92D6xp+Tfp5/07MkhAnrl7TrgVHXAw9b10PP3+y4te2
	6RyxX2YrWb5Lfxk773z6R391t1lKslNOVl225DJzsf+SElToyf+w+HPlPd9aJZbijERDLeai
	4kQAgSdxDDgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e+xoK50/K9Ag+MrtS3u3D3HavHqyA8m
	iwX7rS06Z29gt9h8cB2LRe+Cq2wWjfcmsFl8PHWc3WLT42usFpd3zWGzmHF+H5PFhRUb2S2m
	LDrManHyTy+jRcv1XiaLVbv+MDoIeDw5OI/JY3bDRRaPnbPusnvcubaHzeP8pjXMHpuX1HtM
	vrGc0aNvyypGj8+b5DyuHD3DFMAV1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQ
	sI4x482sZSwFi7krTp3eyt7A+Juji5GTQ0LARGLpqY2MELaYxIV769m6GLk4hASmM0pcONvE
	BOH8ZZTYd76fCaSKTUBLYvXc42AdIgKaEseePGMHKWIW2MYq0fz0CitIQkggQuJUfyMziM0J
	VPRx8gs2EFtYwFniVcNFsGYWAVWJGdMhhvIKWEpcuNHDDmELSvyYfI8FxGYGWrZ+53EmCFte
	YvOat8wQpypI7Dj7GmgOB9ARVhJ/b+lBlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIU
	TS1ILihOSs811CtOzC0uzUvXS87P3cQITlPPpHYwrmywOMQowMGoxMObsfVnoBBrYllxZe4h
	RgkOZiUR3scavwKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YQvNK4g2NTcyMLI3MLIxM
	zM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgXGyVl+Rwo+f+Tq8kWsbI9NuiE9zdby1
	U9p4d9Qlzpvic9k1F2wudhMXdcyrZFi/rkVur+78Yofb+60uPiz4Vr94/w/1HxvTDptyvAvZ
	ai/H6z3h/LXP50oUuzXVNtnd+e5Q4DPTpSPSdppp5qH983lFfTcnv2o4Hxm++Whz+8T5X4y5
	Gz2z7ZVYijMSDbWYi4oTAQPWwBSXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Tomasz Figa [mailto:tomasz.figa@gmail.com]
> Sent: Saturday, July 27, 2013 11:07 PM
> 
> Hi,
> 
> On Friday 26 of July 2013 20:28:36 Cho KyongHo wrote:
> > This commit adds device tree support for System MMU.
> > This also include the following changes and enhancements:
> >
> > * use managed device helper functions.
> > Simplyfies System MMU device driver.
> >
> > * use only a single clock descriptor.
> > System MMU device descriptor is seperate if it is imposible to make
> > a single clock descriptor to make a device descriptor for a group of
> > System MMUs.
> >
> > * removed dbgname member from sysmmu_drvdata structure.
> > debugging kernel message for a System MMU is distinguisheable with the
> > name of device descroptors.
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/Kconfig        |    5 +-
> >  drivers/iommu/exynos-iommu.c |  182
> > ++++++++++++++++-------------------------- 2 files changed, 70
> > insertions(+), 117 deletions(-)
> 
> Whenever you introduce or modify (extend) a device tree binding please
> don't forget about reflecting that in documentation
> (Documentation/devicetree/bindings) and CCing devicetree mailing list
> (devicetree@vger.kernel.org). Both of these steps are necessary to get any
> device tree stuff merged.
> 

Oh I see.
Thank you for advice.

> Best regards,
> Tomasz

