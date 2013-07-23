Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3GWMNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:13:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12271 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3GWMNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:13:06 -0400
X-AuditID: cbfee68f-b7f436d000000f81-cd-51ee7350673a
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Inki Dae'" <inki.dae@samsung.com>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'kvm-arm'" <kvmarm@lists.cs.columbia.edu>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1374573694-30595-1-git-send-email-a.motakis@virtualopensystems.com>
 <00d701ce878f$da099fe0$8e1cdfa0$%dae@samsung.com>
 <CAG8rG2wNG9wVjKxtaDzLRybvh3wPVR08j9G9OPcK=a2Gwbtg-g@mail.gmail.com>
 <00e601ce8796$bdca50c0$395ef240$%dae@samsung.com>
In-reply-to: <00e601ce8796$bdca50c0$395ef240$%dae@samsung.com>
Subject: RE: [PATCH] iommu/exynos: add devices attached to the System MMU to an
 IOMMU group
Date: Tue, 23 Jul 2013 21:13:04 +0900
Message-id: <002901ce879d$fbec5db0$f3c51910$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGLs/3UlWnsymDjNhIVBhSMEqojNAIwyDORAmT7Z2EBVHEfX5nIf8nA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+ZkW5A8btAg2O7dS3u3D3HajHp/gQW
	iwX7rS12z1nMYtE5ewO7xcdTx9ktNj2+xmpxedccNosZ5/cxWZz808tosXNdJ7sDt8eTg/OY
	PO5c28PmcX7TGmaPzUvqPSbfWM7o0bdlFaPHmQVH2D2W3jvK6PF5k5zHlaNnmAK4orhsUlJz
	MstSi/TtErgyZq/4zVIwVb+i6fkctgbGRpUuRk4OCQETiUfLmtkgbDGJC/fWg9lCAssYJU79
	5YGpOfB/C0sXIxdQfBGjxNffvcwQzl9GifbHT1hBqtgEtCRWzz3OCGKLCMRJLJw1gRGkiFlg
	GbPEu/ZGJoixjUwSO38agticAnYS509OAGsWFoiV6Fp8CWw1i4CqxLRPfcwgNq+ApcTR1wtZ
	IGxBiR+T74HZzEDL1u88zgRhy0tsXvOWGeJUBYkdZ19DHeEmMffgdEaIGhGJfS/egR0kIbCW
	Q+LezQmMEMsEJL5NPgQ0lAMoISux6QDUHEmJgytusExglJiFZPUsJKtnIVk9C8mKBYwsqxhF
	UwuSC4qT0ouM9YoTc4tL89L1kvNzNzFC0kL/Dsa7B6wPMSYDrZ/ILCWanA9MK3kl8YbGZkYW
	piamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYGRrnXvWfx3L7ypb
	+dMHXvi7PnrLIHzhY13hs5Tm17mPt9i7mJrNjLi+vOBob078Idk5RjaJMY62Uz/89FvHuOfj
	w0mrnva52iQ5ilme33Z/4d3r7s+FfrBwW3V+9b52dWauSIZK/Ba/xYqtTklvZU9nXpx0YHX7
	fscKz9beS66n01xdvWcc36bEUpyRaKjFXFScCABbywi9IQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDKsWRmVeSWpSXmKPExsVy+t9jAd2A4neBBie3qVvcuXuO1WLS/Qks
	Fgv2W1vsnrOYxaJz9gZ2i4+njrNbbHp8jdXi8q45bBYzzu9jsjj5p5fRYue6TnYHbo8nB+cx
	edy5tofN4/ymNcwem5fUe0y+sZzRo2/LKkaPMwuOsHssvXeU0ePzJjmPK0fPMAVwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJi94jdLwVT9iqbnc9gaGBtVuhg5OSQE
	TCQO/N/CAmGLSVy4t56ti5GLQ0hgEaPE19+9zBDOX0aJ9sdPWEGq2AS0JFbPPc4IYosIxEks
	nDWBEaSIWWAZs8S79kYmkISQQCOTxM6fhiA2p4CdxPmTE8CahQViJboWX2IDsVkEVCWmfepj
	BrF5BSwljr5eyAJhC0r8mHwPzGYGWrZ+53EmCFteYvOat8wQpypI7Dj7GuoIN4m5B6czQtSI
	SOx78Y5xAqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE47
	z6R3MK5qsDjEKMDBqMTD6+H9NlCINbGsuDL3EKMEB7OSCO9SqXeBQrwpiZVVqUX58UWlOanF
	hxiTgT6dyCwlmpwPTIl5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnC
	xMEp1cBoYHXlycN9lRz2G5y35zJfPXJxDb/Mmme1TxMWS2aL56wPiGJYcCrS74Dcz1cGsuFV
	m2sqWJqurSquWjRnZ9tuq1WH/6pcX3j0WV5JqM+V6h8OK3uuf/wadm5+3UOGjQt7LB2kWVZd
	/b7GsDRn8rNV1bI9HR8v7Vv3K6LP/KtIl/8uKbE7Yb27lFiKMxINtZiLihMBPcNvlH8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Inki Dae [mailto:inki.dae@samsung.com]
> Sent: Tuesday, July 23, 2013 8:21 PM
> 
> > -----Original Message-----
> > From: Antonios Motakis [mailto:a.motakis@virtualopensystems.com]
> > Sent: Tuesday, July 23, 2013 8:00 PM
> > To: Inki Dae
> > Cc: Linux ARM Kernel; Linux IOMMU; Linux Samsung SOC; kvm-arm; Cho
> KyongHo;
> > Joerg Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> > Subject: Re: [PATCH] iommu/exynos: add devices attached to the System MMU
> > to an IOMMU group
> >
> > On Tue, Jul 23, 2013 at 12:31 PM, Inki Dae <inki.dae@samsung.com> wrote:
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: linux-samsung-soc-owner@vger.kernel.org [mailto:linux-samsung-
> > soc-
> > > > owner@vger.kernel.org] On Behalf Of Antonios Motakis
> > > > Sent: Tuesday, July 23, 2013 7:02 PM
> > > > To: linux-arm-kernel@lists.infradead.org;
> > > iommu@lists.linux-foundation.org;
> > > > linux-samsung-soc@vger.kernel.org
> > > > Cc: kvmarm@lists.cs.columbia.edu; Antonios Motakis; Cho KyongHo; Joerg
> > > > Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> > > > Subject: [PATCH] iommu/exynos: add devices attached to the System MMU
> > to
> > > > an IOMMU group
> > > >
> > > > IOMMU groups are expected by certain users of the IOMMU API,
> > > > e.g. VFIO. Since each device is behind its own System MMU, we
> > > > can allocate a new IOMMU group for each device.
> > > >
> > > > This patch depends on Cho KyongHo's patch series titled "[PATCH v7
> > 00/12]
> > > > iommu/exynos: Fixes and Enhancements of System MMU driver with DT",
> > > > applied on a Linux 3.10.1 kernel. It has been tested on the Arndale
> > board.
> > > >
> > > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > > ---
> > > >  drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++++++
> > > >  1 file changed, 24 insertions(+)
> > > >
> > > > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-
> > iommu.c
> > > > index 51d43bb..9f39eaa 100644
> > > > --- a/drivers/iommu/exynos-iommu.c
> > > > +++ b/drivers/iommu/exynos-iommu.c
> > > > @@ -1134,6 +1134,28 @@ static phys_addr_t
> > exynos_iommu_iova_to_phys(struct
> > > > iommu_domain *domain,
> > > >       return phys;
> > > >  }
> > > >
> > > > +static int exynos_iommu_add_device(struct device *dev)
> > > > +{
> > > > +     struct iommu_group *group;
> > > > +     int ret;
> > > > +
> > > > +     group = iommu_group_alloc();
> > >
> > > Is that correct? I don't see why you allocate a group object every time
> > > add_device callback is called. That doesn't have any meaning we have to
> > use
> > > iommu group feature. I think the implementation should be one more
> > devices
> > > per a group. So I guess a given device object should be wrapped by
> > higher
> > > device object than the given device object. For a good example, you can
> > > refer to intel-iommu.c file.
> >
> > With an Intel IOMMU it can be the case that 2 devices have to share
> > the same IOMMU mappings (i.e. you can't program them separately). With
> > the Exynos System MMU, there is always one System MMU per device, so
> > there is nothing stopping you from programming any 2 devices' mappings
> > differently. So yes, the right thing to do here is to have a one to
> > one relationship between devices and IOMMU groups.
> 
> In case of Exynos drm driver, a unified iommu mapping table is used for all
> devices (fimd, g2d, hdmi, fimc, gsc, rotator) based on drm so they use the
> same iommu mapping table even though they have each iommu hardware unit. And
> the iommu mapping table is just logical data structure for hardware
> translation process by each DMA. Actually, I am considering using iommu
> group feature for more generic implementation.
> 
> And one question. Why do you allocate a iommu group object if we should have
> one to one relationship between devices and iommu groups? In this case, is
> there any reason you have to use the iommu group object?
> 
> Thanks,
> Inki Dae
> 
Antonios,

Your patch always creates new iommu group whenever .add_device() is called,
which results in memory leak. You need to check if the given device is already
involved in an iommu group.

BTW, I will post new patchset in a few days.
It will not be such different from previous one and your patch
will be rebased on that in a trivial manner.

Regards,
Cho KyongHo

> >
> > (resending because of html mail)
> >
> > Cheers,
> > Antonios
> >
> > >
> > >
> > > Thanks,
> > > Inki Dae
> > >
> > > > +     if (IS_ERR(group)) {
> > > > +             dev_err(dev, "Failed to allocate IOMMU group\n");
> > > > +             return PTR_ERR(group);
> > > > +     }
> > > > +
> > > > +     ret = iommu_group_add_device(group, dev);
> > > > +     iommu_group_put(group);
> > > > +
> > > > +     return ret;
> > > > +}
> > > > +
> > > > +static void exynos_iommu_remove_device(struct device *dev)
> > > > +{
> > > > +     iommu_group_remove_device(dev);
> > > > +}
> > > > +
> > > >  static struct iommu_ops exynos_iommu_ops = {
> > > >       .domain_init = &exynos_iommu_domain_init,
> > > >       .domain_destroy = &exynos_iommu_domain_destroy,
> > > > @@ -1142,6 +1164,8 @@ static struct iommu_ops exynos_iommu_ops = {
> > > >       .map = &exynos_iommu_map,
> > > >       .unmap = &exynos_iommu_unmap,
> > > >       .iova_to_phys = &exynos_iommu_iova_to_phys,
> > > > +     .add_device     = exynos_iommu_add_device,
> > > > +     .remove_device  = exynos_iommu_remove_device,
> > > >       .pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
> > > >  };
> > > >
> > > > --
> > > > 1.8.1.2
> > > >
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-
> > samsung-
> > > > soc" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >

