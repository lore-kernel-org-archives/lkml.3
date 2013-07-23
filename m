Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3GWLVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:21:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64047 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3GWLVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:21:18 -0400
X-AuditID: cbfee68e-b7f276d000002279-8b-51ee672c2c51
From: Inki Dae <inki.dae@samsung.com>
To: "'Antonios Motakis'" <a.motakis@virtualopensystems.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'kvm-arm'" <kvmarm@lists.cs.columbia.edu>,
        "'Cho KyongHo'" <pullip.cho@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1374573694-30595-1-git-send-email-a.motakis@virtualopensystems.com>
 <00d701ce878f$da099fe0$8e1cdfa0$%dae@samsung.com>
 <CAG8rG2wNG9wVjKxtaDzLRybvh3wPVR08j9G9OPcK=a2Gwbtg-g@mail.gmail.com>
In-reply-to: <CAG8rG2wNG9wVjKxtaDzLRybvh3wPVR08j9G9OPcK=a2Gwbtg-g@mail.gmail.com>
Subject: RE: [PATCH] iommu/exynos: add devices attached to the System MMU to an
 IOMMU group
Date: Tue, 23 Jul 2013 20:21:13 +0900
Message-id: <00e601ce8796$bdca50c0$395ef240$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6Hk9jxmopFtkB9ReWnHYd9GYvOsAAAPqEQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42JZI2JSqKuT/i7QoHeGjMWdu+dYLRbst7bY
	PWcxi0Xn7A3sFh9PHWe32PT4GqvF5V1z2CxmnN/HZPGv9yCjxck/vYwWO9d1sjtwezw5OI/J
	4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXqcWXCE3WPpvaOMHp83yXlcOXqGKYArissmJTUn
	syy1SN8ugStj5XyBgjbNivY1s5gbGB/LdzFyckgImEis2bSDEcIWk7hwbz1bFyMXh5DAUkaJ
	mzdOssAUPTzxjwUisYhR4mPzQmYI5zejxI57j5hBqtgEVCUmrrjPBmKLCFhKbFz0A6yDWeAC
	s8TOu81Qc88ySuxdd4IVpIpTIFjiyr3ZYDuEBWIluhZfAutmAZrUsu072FReAVuJE0sWMkLY
	ghI/Jt8Dq2cW0JJYv/M4E4QtL7F5zVugeg6gW9UlHv3VhTjCSOLb1BtQJSIS+168YwS5QUJg
	JYfEyZmbWCB2CUh8m3yIBaJXVmLTAWaIlyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y0itOzC0uzUvXS87P3cQITAun/z3r28F484D1IcZkoPUTmaVEk/OBaSWvJN7Q
	2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwhshmZU3fK
	vZu24arHN/ea3AnbfWxS9UX2bv5kVarJ7XN4lvaGTzW6FYy73aROX9C3X1J6MTA0tsnnfYtU
	aKv/IbGE21nRLxoSNGvXGhdmfm2KZKxcZPX3Zy6TbyfLFNPfhX8NVsZ/MphezZkvImLTxsh8
	UIWvgjHjoMDte22LTXg2FfR0KrEUZyQaajEXFScCANAYW5IhAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t9jAV2d9HeBBp82CFncuXuO1WLBfmuL
	3XMWs1h0zt7AbvHx1HF2i02Pr7FaXN41h81ixvl9TBb/eg8yWpz808tosXNdJ7sDt8eTg/OY
	PO5c28PmcX7TGmaPzUvqPSbfWM7o0bdlFaPHmQVH2D2W3jvK6PF5k5zHlaNnmAK4ohoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlZSKEvMKQUK
	BSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZqycL1DQplnRvmYWcwPjY/kuRk4OCQET
	iYcn/rFA2GISF+6tZ+ti5OIQEljEKPGxeSEzhPObUWLHvUfMIFVsAqoSE1fcZwOxRQQsJTYu
	+sECUsQscIFZYufdZqj2s4wSe9edYAWp4hQIlrhybzbYDmGBWImuxZfAulmAJrVs+w42lVfA
	VuLEkoWMELagxI/J98DqmQW0JNbvPM4EYctLbF7zFqieA+hWdYlHf3UhjjCS+Db1BlSJiMS+
	F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCk80x6
	B+OqBotDjAIcjEo8vB7ebwOFWBPLiitzDzFKcDArifAulXoXKMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wISYVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2MvmbnVr6es7qL92fXRstgmWaF3fue3864tvltw5nG77LK94JznopWm8wPPcGzPidNc/3i
	QykXRHw2lD0Jvce5hPsLF5OL86LFHHMEXq936l8zN9U4x4Vr5dQFJjK8ATcuhrJtL357ju/9
	3+z935o6Xp/Svcwz79zBbavMXDK/y/gLLfGeJ3qcR4mlOCPRUIu5qDgRADwSJu5+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Antonios Motakis [mailto:a.motakis@virtualopensystems.com]
> Sent: Tuesday, July 23, 2013 8:00 PM
> To: Inki Dae
> Cc: Linux ARM Kernel; Linux IOMMU; Linux Samsung SOC; kvm-arm; Cho
KyongHo;
> Joerg Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> Subject: Re: [PATCH] iommu/exynos: add devices attached to the System MMU
> to an IOMMU group
> 
> On Tue, Jul 23, 2013 at 12:31 PM, Inki Dae <inki.dae@samsung.com> wrote:
> >
> >
> >
> > > -----Original Message-----
> > > From: linux-samsung-soc-owner@vger.kernel.org [mailto:linux-samsung-
> soc-
> > > owner@vger.kernel.org] On Behalf Of Antonios Motakis
> > > Sent: Tuesday, July 23, 2013 7:02 PM
> > > To: linux-arm-kernel@lists.infradead.org;
> > iommu@lists.linux-foundation.org;
> > > linux-samsung-soc@vger.kernel.org
> > > Cc: kvmarm@lists.cs.columbia.edu; Antonios Motakis; Cho KyongHo; Joerg
> > > Roedel; Sachin Kamat; Jiri Kosina; Wei Yongjun; open list
> > > Subject: [PATCH] iommu/exynos: add devices attached to the System MMU
> to
> > > an IOMMU group
> > >
> > > IOMMU groups are expected by certain users of the IOMMU API,
> > > e.g. VFIO. Since each device is behind its own System MMU, we
> > > can allocate a new IOMMU group for each device.
> > >
> > > This patch depends on Cho KyongHo's patch series titled "[PATCH v7
> 00/12]
> > > iommu/exynos: Fixes and Enhancements of System MMU driver with DT",
> > > applied on a Linux 3.10.1 kernel. It has been tested on the Arndale
> board.
> > >
> > > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > > ---
> > >  drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++++++
> > >  1 file changed, 24 insertions(+)
> > >
> > > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-
> iommu.c
> > > index 51d43bb..9f39eaa 100644
> > > --- a/drivers/iommu/exynos-iommu.c
> > > +++ b/drivers/iommu/exynos-iommu.c
> > > @@ -1134,6 +1134,28 @@ static phys_addr_t
> exynos_iommu_iova_to_phys(struct
> > > iommu_domain *domain,
> > >       return phys;
> > >  }
> > >
> > > +static int exynos_iommu_add_device(struct device *dev)
> > > +{
> > > +     struct iommu_group *group;
> > > +     int ret;
> > > +
> > > +     group = iommu_group_alloc();
> >
> > Is that correct? I don't see why you allocate a group object every time
> > add_device callback is called. That doesn't have any meaning we have to
> use
> > iommu group feature. I think the implementation should be one more
> devices
> > per a group. So I guess a given device object should be wrapped by
> higher
> > device object than the given device object. For a good example, you can
> > refer to intel-iommu.c file.
> 
> With an Intel IOMMU it can be the case that 2 devices have to share
> the same IOMMU mappings (i.e. you can't program them separately). With
> the Exynos System MMU, there is always one System MMU per device, so
> there is nothing stopping you from programming any 2 devices' mappings
> differently. So yes, the right thing to do here is to have a one to
> one relationship between devices and IOMMU groups.

In case of Exynos drm driver, a unified iommu mapping table is used for all
devices (fimd, g2d, hdmi, fimc, gsc, rotator) based on drm so they use the
same iommu mapping table even though they have each iommu hardware unit. And
the iommu mapping table is just logical data structure for hardware
translation process by each DMA. Actually, I am considering using iommu
group feature for more generic implementation.

And one question. Why do you allocate a iommu group object if we should have
one to one relationship between devices and iommu groups? In this case, is
there any reason you have to use the iommu group object?

Thanks,
Inki Dae

> 
> (resending because of html mail)
> 
> Cheers,
> Antonios
> 
> >
> >
> > Thanks,
> > Inki Dae
> >
> > > +     if (IS_ERR(group)) {
> > > +             dev_err(dev, "Failed to allocate IOMMU group\n");
> > > +             return PTR_ERR(group);
> > > +     }
> > > +
> > > +     ret = iommu_group_add_device(group, dev);
> > > +     iommu_group_put(group);
> > > +
> > > +     return ret;
> > > +}
> > > +
> > > +static void exynos_iommu_remove_device(struct device *dev)
> > > +{
> > > +     iommu_group_remove_device(dev);
> > > +}
> > > +
> > >  static struct iommu_ops exynos_iommu_ops = {
> > >       .domain_init = &exynos_iommu_domain_init,
> > >       .domain_destroy = &exynos_iommu_domain_destroy,
> > > @@ -1142,6 +1164,8 @@ static struct iommu_ops exynos_iommu_ops = {
> > >       .map = &exynos_iommu_map,
> > >       .unmap = &exynos_iommu_unmap,
> > >       .iova_to_phys = &exynos_iommu_iova_to_phys,
> > > +     .add_device     = exynos_iommu_add_device,
> > > +     .remove_device  = exynos_iommu_remove_device,
> > >       .pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
> > >  };
> > >
> > > --
> > > 1.8.1.2
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-
> samsung-
> > > soc" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

