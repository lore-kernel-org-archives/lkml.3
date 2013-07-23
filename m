Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab3GWMgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:36:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14740 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab3GWMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:36:45 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-40-51ee78dbb485
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Antonios Motakis'" <a.motakis@virtualopensystems.com>
Cc: "'Inki Dae'" <inki.dae@samsung.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
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
 <002901ce879d$fbec5db0$f3c51910$@samsung.com>
 <CAG8rG2xSzMrUU813RPQbDpdoYnj-_Kcx689TMZgX8kYXQRidHg@mail.gmail.com>
In-reply-to: <CAG8rG2xSzMrUU813RPQbDpdoYnj-_Kcx689TMZgX8kYXQRidHg@mail.gmail.com>
Subject: RE: [PATCH] iommu/exynos: add devices attached to the System MMU to an
 IOMMU group
Date: Tue, 23 Jul 2013 21:36:43 +0900
Message-id: <002d01ce87a1$499e5240$dcdaf6c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGLs/3UlWnsymDjNhIVBhSMEqojNAIwyDORAmT7Z2EBVHEfXwKiUV6CAjruWzWZoZ28MA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+Zvu7tineBBg/2qFvcuXuO1WLS/Qks
	Fgv2W1vsnrOYxaJz9gZ2i4+njrNbbHp8jdXi8q45bBYzzu9jsjj5p5fRYue6TnYHbo8nB+cx
	edy5tofN4/ymNcwem5fUe0y+sZzRo2/LKkaPMwuOsHssvXeU0ePzJjmPK0fPMAVwRXHZpKTm
	ZJalFunbJXBl3P7wnKVgkXnF560n2BsYf2h2MXJySAiYSOy5s4YRwhaTuHBvPRuILSSwjFHi
	9233LkYOsJp9H427GLmAwosYJa6cf8wOUfOXUeLhdRcQm01AS2L13ONgc0QELCU2LvrBAtLA
	LHCaWeLPzG+sEN0/mCTun1zLBjKVUyBY4uNmN5AGYYFYia7Fl8DCLAKqEk23uEHCvEBzZkw7
	zwZhC0r8mHyPBcRmBtq1fudxJghbXmLzmrfMEPcrSOw4+xrqhgiJazOeskHUiEjse/EO6se1
	HBLNs0xAbBYBAYlvkw+xQPwoK7HpANQYSYmDK26wTGCUmIVk8ywkm2ch2TwLyYYFjCyrGEVT
	C5ILipPSiwz1ihNzi0vz0vWS83M3MULSQe8OxtsHrA8xJgOtn8gsJZqcD0wneSXxhsZmRham
	JqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpgbNWQaDc2WCBaH/pL
	Z+VK2xMGRx7rPndMk/5z1PfDlelKWxgFttV4blt0yFEvoFfqEce2Wb5Jn4z8bFVDezK23FqS
	b52QqTd3yZFHwonT58q+TAqWsk/V6vZ8LxUeIjY/uSRaO+gj047/1wz1TBX+6Gee3n6KYX7D
	g5XlL6JDg3dvuMxbOPuoEktxRqKhFnNRcSIAYI7S/B0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t9jAd3bFe8CDW7vVrS4c/ccq8Wk+xNY
	LBbst7bYPWcxi0Xn7A3sFh9PHWe32PT4GqvF5V1z2CxmnN/HZHHyTy+jxc51newO3B5PDs5j
	8rhzbQ+bx/lNa5g9Ni+p95h8YzmjR9+WVYweZxYcYfdYeu8oo8fnTXIeV46eYQrgimpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOllJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHH7w3OWgkXmFZ+3nmBvYPyh2cXIwSEh
	YCKx76NxFyMnkCkmceHeerYuRi4OIYFFjBJXzj9mB0kICfxllHh43QXEZhPQklg99zgjiC0i
	YCmxcdEPFpAGZoHTzBJ/Zn5jhej+wSRx/+RaNpANnALBEh83u4E0CAvESnQtvgQWZhFQlWi6
	xQ0S5gWaM2PaeTYIW1Dix+R7LCA2M9Cu9TuPM0HY8hKb17xlhjhUQWLH2ddQN0RIXJvxlA2i
	RkRi34t3jBMYhWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw
	wnkmvYNxVYPFIUYBDkYlHl4P77eBQqyJZcWVuYcYJTiYlUR4l0q9CxTiTUmsrEotyo8vKs1J
	LT7EmAz06ERmKdHkfGAyzCuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHM
	FiYOTqkGxkUSGxZsup/NszXpIlv1O570WwWXeo7du76/QzXm65aTnxeUceQ3cMdc/Nkd6fJL
	9HRLislPQ+8VxT49y+bn9Hz44p/cJM+k42fbzeiwZkPA4b0KmzuklN4lqoXxPnwy3XjjskcZ
	V/r8F78rW5UhfO5W4YcJ64uE9LWz/OZ+5r4W+n+64VXly0osxRmJhlrMRcWJAHEWld18AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Antonios Motakis [mailto:a.motakis@virtualopensystems.com]
> Sent: Tuesday, July 23, 2013 9:23 PM
> 
> On Tue, Jul 23, 2013 at 2:13 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >> -----Original Message-----
> >> From: Inki Dae [mailto:inki.dae@samsung.com]
> >> Sent: Tuesday, July 23, 2013 8:21 PM
> >>
> >> > -----Original Message-----
> >> > From: Antonios Motakis [mailto:a.motakis@virtualopensystems.com]
> >> > Sent: Tuesday, July 23, 2013 8:00 PM
> >> > To: Inki Dae
> >> > Cc: Linux ARM Kernel; Linux IOMMU; Linux Samsung SOC; kvm-arm; Cho
> >> KyongHo;
> >> > Joerg Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> >> > Subject: Re: [PATCH] iommu/exynos: add devices attached to the System MMU
> >> > to an IOMMU group
> >> >
> >> > On Tue, Jul 23, 2013 at 12:31 PM, Inki Dae <inki.dae@samsung.com> wrote:
> >> > >
> >> > >
> >> > >
> >> > > > -----Original Message-----
> >> > > > From: linux-samsung-soc-owner@vger.kernel.org [mailto:linux-samsung-
> >> > soc-
> >> > > > owner@vger.kernel.org] On Behalf Of Antonios Motakis
> >> > > > Sent: Tuesday, July 23, 2013 7:02 PM
> >> > > > To: linux-arm-kernel@lists.infradead.org;
> >> > > iommu@lists.linux-foundation.org;
> >> > > > linux-samsung-soc@vger.kernel.org
> >> > > > Cc: kvmarm@lists.cs.columbia.edu; Antonios Motakis; Cho KyongHo; Joerg
> >> > > > Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> >> > > > Subject: [PATCH] iommu/exynos: add devices attached to the System MMU
> >> > to
> >> > > > an IOMMU group
> >> > > >
> >> > > > IOMMU groups are expected by certain users of the IOMMU API,
> >> > > > e.g. VFIO. Since each device is behind its own System MMU, we
> >> > > > can allocate a new IOMMU group for each device.
> >> > > >
> >> > > > This patch depends on Cho KyongHo's patch series titled "[PATCH v7
> >> > 00/12]
> >> > > > iommu/exynos: Fixes and Enhancements of System MMU driver with DT",
> >> > > > applied on a Linux 3.10.1 kernel. It has been tested on the Arndale
> >> > board.
> >> > > >
> >> > > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> >> > > > ---
> >> > > >  drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++++++
> >> > > >  1 file changed, 24 insertions(+)
> >> > > >
> >> > > > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-
> >> > iommu.c
> >> > > > index 51d43bb..9f39eaa 100644
> >> > > > --- a/drivers/iommu/exynos-iommu.c
> >> > > > +++ b/drivers/iommu/exynos-iommu.c
> >> > > > @@ -1134,6 +1134,28 @@ static phys_addr_t
> >> > exynos_iommu_iova_to_phys(struct
> >> > > > iommu_domain *domain,
> >> > > >       return phys;
> >> > > >  }
> >> > > >
> >> > > > +static int exynos_iommu_add_device(struct device *dev)
> >> > > > +{
> >> > > > +     struct iommu_group *group;
> >> > > > +     int ret;
> >> > > > +
> >> > > > +     group = iommu_group_alloc();
> >> > >
> >> > > Is that correct? I don't see why you allocate a group object every time
> >> > > add_device callback is called. That doesn't have any meaning we have to
> >> > use
> >> > > iommu group feature. I think the implementation should be one more
> >> > devices
> >> > > per a group. So I guess a given device object should be wrapped by
> >> > higher
> >> > > device object than the given device object. For a good example, you can
> >> > > refer to intel-iommu.c file.
> >> >
> >> > With an Intel IOMMU it can be the case that 2 devices have to share
> >> > the same IOMMU mappings (i.e. you can't program them separately). With
> >> > the Exynos System MMU, there is always one System MMU per device, so
> >> > there is nothing stopping you from programming any 2 devices' mappings
> >> > differently. So yes, the right thing to do here is to have a one to
> >> > one relationship between devices and IOMMU groups.
> >>
> >> In case of Exynos drm driver, a unified iommu mapping table is used for all
> >> devices (fimd, g2d, hdmi, fimc, gsc, rotator) based on drm so they use the
> >> same iommu mapping table even though they have each iommu hardware unit. And
> >> the iommu mapping table is just logical data structure for hardware
> >> translation process by each DMA. Actually, I am considering using iommu
> >> group feature for more generic implementation.
> >>
> >> And one question. Why do you allocate a iommu group object if we should have
> >> one to one relationship between devices and iommu groups? In this case, is
> >> there any reason you have to use the iommu group object?
> >>
> >> Thanks,
> >> Inki Dae
> >>
> > Antonios,
> >
> > Your patch always creates new iommu group whenever .add_device() is called,
> > which results in memory leak. You need to check if the given device is already
> > involved in an iommu group.
> >
> > BTW, I will post new patchset in a few days.
> > It will not be such different from previous one and your patch
> > will be rebased on that in a trivial manner.
> 
> It is not clear to me why this is the case, can add_device be called
> multiple times per device? I will take a look into this.
> 
Yes, the case you have mentioned.
Even though it must not happen with perfect device drivers,
IOMMU driver needs to care about it IMHO.

> Anyway thanks for taking this into account.
> 
> >
> > Regards,
> > Cho KyongHo
> >
> >> >
> >> > (resending because of html mail)
> >> >
> >> > Cheers,
> >> > Antonios
> >> >
> >> > >
> >> > >
> >> > > Thanks,
> >> > > Inki Dae
> >> > >
> >> > > > +     if (IS_ERR(group)) {
> >> > > > +             dev_err(dev, "Failed to allocate IOMMU group\n");
> >> > > > +             return PTR_ERR(group);
> >> > > > +     }
> >> > > > +
> >> > > > +     ret = iommu_group_add_device(group, dev);
> >> > > > +     iommu_group_put(group);
> >> > > > +
> >> > > > +     return ret;
> >> > > > +}
> >> > > > +
> >> > > > +static void exynos_iommu_remove_device(struct device *dev)
> >> > > > +{
> >> > > > +     iommu_group_remove_device(dev);
> >> > > > +}
> >> > > > +
> >> > > >  static struct iommu_ops exynos_iommu_ops = {
> >> > > >       .domain_init = &exynos_iommu_domain_init,
> >> > > >       .domain_destroy = &exynos_iommu_domain_destroy,
> >> > > > @@ -1142,6 +1164,8 @@ static struct iommu_ops exynos_iommu_ops = {
> >> > > >       .map = &exynos_iommu_map,
> >> > > >       .unmap = &exynos_iommu_unmap,
> >> > > >       .iova_to_phys = &exynos_iommu_iova_to_phys,
> >> > > > +     .add_device     = exynos_iommu_add_device,
> >> > > > +     .remove_device  = exynos_iommu_remove_device,
> >> > > >       .pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
> >> > > >  };
> >> > > >
> >> > > > --
> >> > > > 1.8.1.2
> >> > > >
> >> > > > --
> >> > > > To unsubscribe from this list: send the line "unsubscribe linux-
> >> > samsung-
> >> > > > soc" in
> >> > > > the body of a message to majordomo@vger.kernel.org
> >> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > >
> >

