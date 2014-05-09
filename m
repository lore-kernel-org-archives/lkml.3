Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaEIKyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:54:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52594 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaEIKyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:54:43 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-34-536cb3f199a0
Date: Fri, 09 May 2014 19:54:40 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: Re: [PATCH v12 18/31] iommu/exynos: allow having multiple System MMUs
 for a master H/W
Message-id: <20140509195440.ae989be464cde24ade92eec2@samsung.com>
In-reply-to: <5369245A.1060001@gmail.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <1398584283-22846-19-git-send-email-shaik.ameer@samsung.com>
 <5369245A.1060001@gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zI92Pm3OCDT7uVLO4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7xfdcXdoveBVfZLDY9vsZqcXnXHDaLGef3MVlcWLGR3WLKosOsFoff
	tLNanPzTy2hx5OFudouW671MFutnvGaxWLXrD6PFzFtrWByEPZ4cnMfkMbvhIovHv8P9TB47
	Z91l97hzbQ+bx+Yl9R6Tbyxn9OjbsorR4/MmOY8rR88wBXBFcdmkpOZklqUW6dslcGV8un6O
	teCpeMWhrj72BsaJwl2MnBwSAiYSf9asZYawxSQu3FvP1sXIxSEksIxR4t6aE+wwRQ9/rGWB
	SCxilGh58pIZwpnMJPHmXTMrSBWLgKrEyc0PGUFsNgEtidVzj4PZIgLqEt+m9LODNDALtLFI
	fP5zEmgUB4ewQKLEk6mVICavgKPE7f+5IOWcApoSX/6fhLpiKaPEmy0HWSGusJC40NQBdhGv
	gKDEj8n3WEBsZqBdm7c1sULY8hKb17yFeucMh8ShFYkQtwlIfJt8CGythICsxKYDUCWSEgdX
	3GCZwCg2C8nUWUimzkIydQEj8ypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MkOTQt4Px5gHr
	Q4zJQCsnMkuJJucDk0teSbyhsZmRhamJqbGRuaUZacJK4ryLHiYFCQmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamD0LA+o9dLr1GwOTpvA+mR7ip3el8y+hIdvWm1LH5gX9zfnLjhg365x481D
	rsSUSI1yBqct0zLmmNyVs1pZfb6xSPalc6isRYhUbtjkvWdPNL2dYTvNsVIlyOKo8pIZn8p6
	4+Yff37lu1jFbWmGlK5nEk49V6pnlKaEWAiETxCpunbe/or6XyWW4oxEQy3mouJEAMhkD5Ik	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jAd2Pm3OCDc4vVrC4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7xfdcXdoveBVfZLDY9vsZqcXnXHDaLGef3MVlcWLGR3WLKosOsFoff
	tLNanPzTy2hx5OFudouW671MFutnvGaxWLXrD6PFzFtrWByEPZ4cnMfkMbvhIovHv8P9TB47
	Z91l97hzbQ+bx+Yl9R6Tbyxn9OjbsorR4/MmOY8rR88wBXBFNTDaZKQmpqQWKaTmJeenZOal
	2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gC9pqRQlphTChQKSCwuVtK3wzQhNMRN
	1wKmMULXNyQIrsfIAA0krGPM+HT9HGvBU/GKQ1197A2ME4W7GDk5JARMJB7+WMsCYYtJXLi3
	nq2LkYtDSGARo0TLk5fMEM5kJok375pZQapYBFQlTm5+yAhiswloSayeexzMFhFQl/g2pZ8d
	pIFZoI1F4vOfk0BjOTiEBRIlnkytBDF5BRwlbv/PBSnnFNCU+PL/JNSypYwSb7YcZIW4wkLi
	QlMHO4jNKyAo8WPyPbDrmIF2bd7WxAphy0tsXvOWeQKjwCwkZbOQlM1CUraAkXkVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRnDyeSa1g3Flg8UhRgEORiUe3hdTsoOFWBPLiitzDzFKcDAr
	ifA+m54TLMSbklhZlVqUH19UmpNafIgxGRgaE5mlRJPzgYkxryTe0NjEzMjSyMzCyMTcnDRh
	JXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYzwnd32KkdWh1wj3B8IBT1nwKGXsiXr7La98W
	8OeOwtediQ9mLtz00jMk1URKnmfXJ+e0GS2fHRIvPHsf6NO1WePA1JKEgyqSbyvuak/a0+M/
	0bjbr9H8xPcNfBWbdwUtWrP89rsHdq9WuP7zkpGQisq9P+9dzinlKl2WxGNCYWcdGTvZdrrN
	UmIpzkg01GIuKk4EAMFIH8SCAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2014 20:05:14 +0200, Tomasz Figa wrote:
> On 27.04.2014 09:37, Shaik Ameer Basha wrote:
> > From: Cho KyongHo <pullip.cho@samsung.com>
> >
> > Some master device descriptor like fimc-is which is an abstraction
> > of very complex H/W may have multiple System MMUs. For those devices,
> > the design of the link between System MMU and its master H/W is needed
> > to be reconsidered.
> >
> > A link structure, sysmmu_list_data is introduced that provides a link
> > to master H/W and that has a pointer to the device descriptor of a
> > System MMU. Given a device descriptor of a master H/W, it is possible
> > to traverse all System MMUs that must be controlled along with the
> > master H/W.
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >   drivers/iommu/exynos-iommu.c |  545 ++++++++++++++++++++++++++----------------
> >   1 file changed, 335 insertions(+), 210 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index fefedec3..c2e6365 100755
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -117,6 +117,10 @@
> >   #define REG_PB1_EADDR		0x058
> >
> >   #define has_sysmmu(dev)		(dev->archdata.iommu != NULL)
> > +#define for_each_sysmmu_list(dev, list_data)				\
> > +	list_for_each_entry(list_data,					\
> > +		&((struct exynos_iommu_owner *)dev->archdata.iommu)->mmu_list, \
> > +		entry)
> 
> Sorry, NAK.
> 
> Please don't add this kind of complexity and business logic to low level 
> code. We want the configuration functions to be simple, easy to read, 
> maintain and extend.
> 
> The proper way to do it is to let the IOMMUs be grouped together on 
> IOMMU subsystem level, so that each IOMMU consumer driver would see just 
> one IOMMU, but then IOMMU driver callbacks would handle just particular 
> instances of the IOMMU IP blocks, without any loops, lists and other 
> crazy code...
> 

It is done in IOMMU driver internally.
IOMMU consumer driver(IOMMU client device driver?) sees IOMMU domain
but IOMMU itself. How to handle IOMMUs of the client device is just
in charge of IOMMU driver according to the hardwired bus topology.

If a master and IOMMU device should be 1:1 relationship as you contend,
the master device driver should be responsible for express the bus
topology in its business logic. I think it is not good as I told earlier.

IOMMU group is different from the grouping System MMUs in Exynos IOMMU driver.
IOMMU group is invented to group several IOMMUs on different bus with different
masters to assign the same IOMMU domain.
It is useful for user level virtualization but for expressing bus topology.
Exynos IOMMU driver just groups System MMUs that have the same master device.
Even though Exynos IOMMU driver implements IOMMU group which is already
implemented by 20/31 patch, such looping is still required.

However, I will consider other elegant way of interation of multiple System MMUs.

Regards,

KyongHo
