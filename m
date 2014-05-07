Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbaEGAo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:44:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13031 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaEGAo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:44:56 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-d0-53698206b5c1
Date: Wed, 07 May 2014 09:44:53 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>,
        Shaik Ameer Basha <shaik.samsung@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        "supash.ramaswamy" <supash.ramaswamy@linaro.org>,
        sunil joshi <joshi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: [PATCH v12 00/31] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Message-id: <20140507094453.28f0429152e5b59a5dda9fd8@samsung.com>
In-reply-to: <5369252F.4070402@gmail.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <26065037.GxQQuIURPg@wuerfel>
 <CAOD6ATqZ5UwRwSKiPDQLrgmX=UUrJVE7ybM_RhXz_CEUjM3W7w@mail.gmail.com>
 <20140506175904.GB12376@8bytes.org> <5369252F.4070402@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zA122psxgg6dHVCzu3D3HavF30jF2
	i/lHgKxXR34wWSzYb23ROXsDu8X3XV/YLXoXXGWz2PT4GqvF5V1z2CxmnN/HZHFhxUZ2iymL
	DrNaHH7Tzmpx8k8vo8WRh7vZLdbtnMRu0XK9l8li/YzXLBardv1htJh5aw2Lg6jHk4PzmDx+
	/5rE6DG74SKLx7/D/UweO2fdZfe4c20Pm8fmJfUek28sZ/To27KK0ePzJjmPK0fPMAVwR3HZ
	pKTmZJalFunbJXBlLN+wiaVgD1fFylfXmRoYJ3F0MXJySAiYSHxt2MoEYYtJXLi3nq2LkYtD
	SGAZo8S9CyAORNG/u62MEInpjBJrbs1mhnAmM0nMXrmbFaSKRUBV4uKVjWCj2AS0JFbPPc4I
	YosIqEt8m9LPDtLALPCdTWJ1yymwBmGBJIk3Zx6CreAVcJTovPMIrJlTQFPi5fYlLBAbPjJK
	3Jm2hRHiDguJC00d7BANghI/Jt9jAbGZgbZt3tbECmHLS2xe8xbsPAmBBxwSTcchprIICEh8
	m3wIqIEDKCErsekAM8RMSYmDK26wTGAUm4Vk7CwkY2chGbuAkXkVo2hqQXJBcVJ6kaFecWJu
	cWleul5yfu4mRkgC6d3BePuA9SHGZKCVE5mlRJPzgQkoryTe0NjMyMLUxNTYyNzSjDRhJXHe
	pIdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYFba0fF224IPeSr0I7ZTmTRyC5Vt32G/U
	OXzIu03rX8IRrY3c83JWlDMIzfLluhS6ivXGu9KABJGLEg831wmFd5/S2RBjY52ZPpXX4MS/
	5uv6Zbs5hdfZVuTdfvbsgXb8P7Y2wTMph3ZfsPSq/qH4YEnzxS5x7awfsWmhdo/8lwqvO856
	3ddViaU4I9FQi7moOBEAkSJcHjYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e+xoC5bU2awwfTfshZ37p5jtfg76Ri7
	xfwjQNarIz+YLBbst7bonL2B3eL7ri/sFr0LrrJZbHp8jdXi8q45bBYzzu9jsriwYiO7xZRF
	h1ktDr9pZ7U4+aeX0eLIw93sFut2TmK3aLney2SxfsZrFotVu/4wWsy8tYbFQdTjycF5TB6/
	f01i9JjdcJHF49/hfiaPnbPusnvcubaHzWPzknqPyTeWM3r0bVnF6PF5k5zHlaNnmAK4oxoY
	bTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAPlVSKEvM
	KQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZizfsImlYA9XxcpX15kaGCdxdDFy
	ckgImEj8u9vKCGGLSVy4t56ti5GLQ0hgOqPEmluzmSGcyUwSs1fuZgWpYhFQlbh4ZSMTiM0m
	oCWxeu5xsG4RAXWJb1P62UEamAW+s0msbjkF1iAskCTx5sxDNhCbV8BRovPOI7BmTgFNiZfb
	l7BAbPjIKHFn2haoOywkLjR1sEM0CEr8mHyPBcRmBtq2eVsTK4QtL7F5zVvmCYwCs5CUzUJS
	NgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwenpmfQOxlUNFocYBTgYlXh4Ld5m
	BAuxJpYVV+YeYpTgYFYS4b2pmxksxJuSWFmVWpQfX1Sak1p8iDEZGB4TmaVEk/OBqTOvJN7Q
	2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgT384VacnxfeO68Ynj
	15XW0TWVzQYvAlx3mPJN37oib/2azUkx/hfqZG/xTPCPu7dp99mbTIWfX1UZG8tvaVszudvC
	r6ebd/Jqg0+vu6XnJS93eLemNlRaunG7W4R+2qpjNzKCqrlXPuRfYpGo5RLrz3u+4eX/Gekb
	8iLyvO31hT2u8s/e3qbEUpyRaKjFXFScCACXOAo4kwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2014 20:08:47 +0200, Tomasz Figa wrote:
> On 06.05.2014 19:59, Joerg Roedel wrote:
> > On Wed, Apr 30, 2014 at 04:27:10PM +0530, Shaik Ameer Basha wrote:
> >> This series is going on for quite a long time and most of the patches here
> >> doesn't depend on dt bindings. As Exynos IOMMU h/w is introducing new versions
> >> very frequently, maintaining and reviewing all these patches again and
> >> again is quite a hard job.
> >>
> >> If it is acceptable, I can post one more series with the subset of
> >> above patches,
> >> which doesn't depend on dt-bindings. As all the patches which doesn't depend on
> >> DT bindings are already tested,  I hope merging these subset of patches may help
> >> in reducing the rework and review effort every time.
> >>
> >> Once we finalize the generic DT bindings for the IOMMU devices, the driver
> >> can be updated with the proposed DT bindings in mind.
> >
> > Sounds reasonable to me if the patch subset is self-contained. When
> > Arnd is OK with that and no one else has objections I can take the
> > dt-independend parts.
> 
> +1.
> 
> I would also suggest dropping patch 18/31, for the reasons I mentioned 
> in my reply to it.
> 

Great.

We will prepare the next patch series that are independent upon DT bindings soon.

Thank you.

KyongHo
