Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3GOMUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 08:20:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59758 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3GOMUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:20:52 -0400
X-AuditID: cbfee68f-b7f436d000000f81-3a-51e3e9220ef6
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
In-reply-to: 
Subject: RE: [PATCH v7 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Mon, 15 Jul 2013 21:20:50 +0900
Message-id: <00a701ce8155$be139240$3a3ab6c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHImoHYg6CdDvKKKhqc0+dxpB73qAL6z534mVmPq4CAAA4RoA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zga7Sy8eBBjuaJS3OLjvIZvHqyA8m
	iwX7rS06Z29gt9h8cB2LRe+Cq2wWjfcmsFlsenyN1eLyrjlsFjPO72OyuLBiI7vFlEWHWS1a
	rvcyOfB6PDk4j8ljdsNFFo871/aweWxeUu8x+cZyRo++LasYPT5vkgtgj+KySUnNySxLLdK3
	S+DKmL9hHlNBj2TFvpMRDYxPhLsYOTkkBEwk3k6/wQRhi0lcuLeeDcQWEljGKLF0dyxMzYZf
	qxi7GLmA4osYJebPeckG4fxllLg38Qc7SBWbgJbE6rnHgao4OEQEdCTmL7EHqWEW2MQicej/
	MlaIhgZGief3DzKCNHAK8Eis+9PJ3MXIziEskChx2RkkyiKgKtHV+5wFxOYVsJT4cmE/E4Qt
	KPFj8j0WkPHMAuoSU6bkgoSZBeQlNq95ywxxp4LEjrOvwYaLCDhJvDnUzQhRIyKx78U7sPsl
	BJZySHxd/oINYpeAxLfJh8BmSgjISmw6ADVHUuLgihssExglZiHZPAth8ywkm2ch2bCAkWUV
	o2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkgK6N/BePeA9SHGZKDtE5mlRJPzgSkkryTe0NjM
	yMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MRXtWbLvc1esx
	8dX9AM4pzYsZXiRH8f95O7VVKTfth4R3deEcDcUPLpclQtcnlK3Tq+efxLDe2LYwKH7Lrqa/
	HSdt5pb+YS2qLv+xKW6+Y2iAjOdTCe+mC0eeO55qvjBndk1oyNq/DNsUubivPyptcvN74rDj
	oI3jcmUG09MVjFmdp7/P7mFRYinOSDTUYi4qTgQAbbXyixcDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAV2ll48DDW4sFbY4u+wgm8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGax6fE1VovLu+awWcw4v4/J4sKKjewWUxYdZrVo
	ud7L5MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT36tqxi9Pi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8b8DfOYCnokK/adjGhgfCLcxcjJISFgIrHh1ypG
	CFtM4sK99WxdjFwcQgKLGCXmz3kJ5fxllLg38Qc7SBWbgJbE6rnHgTo4OEQEdCTmL7EHqWEW
	2MQicej/MlaIhgZGief3D4KN5RTgkVj3p5O5i5GdQ1ggUeKyM0iURUBVoqv3OQuIzStgKfHl
	wn4mCFtQ4sfkeywg45kF1CWmTMkFCTMLyEtsXvOWGeJOBYkdZ1+DDRcRcJJ4c6ibEaJGRGLf
	i3eMExiFZiGZNAth0iwkk2Yh6VjAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjFPJPe
	wbiqweIQowAHoxIPb4ba40Ah1sSy4srcQ4wSHMxKIrxLLwKFeFMSK6tSi/Lji0pzUosPMSYD
	/TmRWUo0OR+Y/vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1Oq
	gTE/qccsv+Vft8GaixOnR7knleVW/l/Pw9nQvci1d1nzSjsH5v8qe8wZ9rfXF8/+Zl1n8OTr
	x1Oucj/c/eyYMqPTQz0LCkr+l+fxvH/a6c83OyF15rQdZbVer3Z6JRzeuYd9Cu/P+XILtj2J
	fly292bGsjCBCxmz/a9MPfWZd1c+o//zTP7lfkosxRmJhlrMRcWJADWApKd1AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cho KyongHo [mailto:pullip.cho@samsung.com]
> Sent: Monday, July 15, 2013 8:24 PM
> 
> > From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> > Sent: Friday, July 12, 2013 2:23 AM
> >
> > On Fri, Jul 5, 2013 at 5:29 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > > The current exynos-iommu(System MMU) driver does not work autonomously
> > > since it is lack of support for power management of peripheral blocks.
> > ...
> > > Patch summary:
> > > [PATCH v7 1/9] iommu/exynos: do not include removed header
> > > [PATCH v7 2/9] iommu/exynos: add missing cache flush for removed page table entries
> > > [PATCH v7 3/9] iommu/exynos: fix page table maintenance
> > > [PATCH v7 4/9] iommu/exynos: allocate lv2 page table from own slab
> > > [PATCH v7 5/9] iommu/exynos: change rwlock to spinlock
> > > [PATCH v7 6/9] clk: exynos5250: add gate clock descriptions of System MMU
> > > [PATCH v7 7/9] ARM: dts: Add description of System MMU of Exynos SoCs
> > > [PATCH v7 8/9] iommu/exynos: support for device tree
> > > [PATCH v7 9/9] iommu/exynos: add bus notifier for registering System MMU
> >
> > Cho,
> > Of the above patches, nearly all have been applied to chromeos-3.8
> > (kernel-next git tree) by Doug Anderson and others.
> >
> > AFAICT, the only ones not applied are:
> >    [v7,3/9] iommu/exynos: fix page table maintenance
> >    [v7,6/9] clk: exynos5250: add gate clock descriptions of System MMU
> > (conflicts in this one)
> >    [v7,7/9] ARM: dts: Add description of System MMU of Exynos SoCs
> > (depends on 6/9)
> >
> > We also already have parts of:
> >    [v7,9/9] iommu/exynos: add bus notifier for registering System MMU
> >
> > Some of those are being further discussed but I've lost track now
> > exactly which ones.
> >
> > I'm telling you about chromeos-3.8 status since the adopted changes
> > have been reviewed (by me and others) are being tested manually here
> > on several different Samsung Exynos platforms (including 5250 which is
> > our "snow" platform). Not sure how you should to mark those patches
> > since they aren't identical to your changes (which apply to post 3.10
> > kernels, not 3.8).  You might consider splitting those patches out
> > from the 4 I've listed above to get that series accepted upstream
> > since the additional review/testing should provide some confidence
> > those patches are good.
> >
> 
> I understand what you are concerning about.
> Have you applied v6 patchset?
> 
> I will try to split the patches and make the changes from v6
> on top of the v6 patcheset.
> 

Actually, as you know, the previous patches include setting a System MMU
as the parent device of its master device in probe() of System MMU.
I asked Greg KH about changing device hierarchy in probe() and he answered
that it is not a good idea because it modifies sysfs even though probe() of
System MMU driver is called before sysfs is constructed.

That's why I uses genpd_pm_ops.
It results in big change in the patches after registering device tree.

I want to ask your opinion about this change :)

> > cheers,
> > grant
> 
> Thank you.
> 
> Cho KyonogHo.

