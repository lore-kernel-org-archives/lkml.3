Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab3HFJrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:47:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48093 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab3HFJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:47:45 -0400
X-AuditID: cbfee68e-b7f276d000002279-46-5200c63f574e
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Grant Grundler'" <grundler@chromium.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Jiri Kosina'" <jkosina@suse.cz>,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>
References: <1372781307-7906-1-git-send-email-grundler@chromium.org>
 <CANEJEGu2B9FUDLn5EOPm1hOau1Y+s6rFZy3WVFQCO=3T6acgmg@mail.gmail.com>
In-reply-to: <CANEJEGu2B9FUDLn5EOPm1hOau1Y+s6rFZy3WVFQCO=3T6acgmg@mail.gmail.com>
Subject: RE: [PATCH] iommu/exynos: remove dead code (set_prefbuf)
Date: Tue, 06 Aug 2013 18:47:43 +0900
Message-id: <001f01ce9289$ff4f1230$fded3690$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQFhsUmBlF5OCIOeXbucLAUwP0uSPwIxDMEDmlAoS9A=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t8zY137YwxBBu/Oilm8OvKDyWLBfmuL
	3XMWs1h0zt7AbtG74CqbxeVdc9gsTv7pZbTYua6T3YHD48nBeUwesxsusnjcubaHzWPyjeWM
	Hn1bVjF6nFlwhN1j6b2jjB6fN8kFcERx2aSk5mSWpRbp2yVwZexfuo2l4JlExdz7tQ2MD/i6
	GDk5JARMJI5s+cEMYYtJXLi3nq2LkYtDSGAZo8Shpb+YYYo23m1mhEgsYpSY2fmHHcL5yyix
	dutXNpAqNgEtidVzjzOC2CICCRLzeieAFTELfGSUaDr7F2puN6PEgttbWEGqOAWCJTov/2QB
	sYUFHCWW/rwIFmcRUJW40rkQbCqvgKXEm+7HULagxI/J98DqmQXUJSbNW8QMYctLbF7zFupW
	BYkdZ18zQsRFJPa9eAdkcwBdZCWx/1UCyA0SAq0cEuv+X2GD2CUg8W3yIRaQGgkBWYlNB6DG
	SEocXHGDZQKjxCwkm2ch2TwLyeZZSLYtYGRZxSiaWpBcUJyUXmSkV5yYW1yal66XnJ+7iRES
	5307GG8esD7EmAy0fiKzlGhyPjBN5JXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5Ykpqd
	mlqQWhRfVJqTWnyIkYmDU6qBsWzmta2ttzdkNb8N9y6bV73mUtS8WoNVfr88X880L67XVZJu
	eMn/P1Xms/t2OaZ22ducAft/mTP1fp/Pk78xpGvyZUlGT+nsh1JbzjZ4Sx+dVFiWd2Ud37TV
	M5paJh3LWcbhvuas1MXFO7VfnZq/u8tkbw5fuG/T73Nznk5VsBNYfzq9dULmEyWW4oxEQy3m
	ouJEACnlt08JAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsVy+t9jAV37YwxBBo/XCFq8OvKDyWLBfmuL
	3XMWs1h0zt7AbtG74CqbxeVdc9gsTv7pZbTYua6T3YHD48nBeUwesxsusnjcubaHzWPyjeWM
	Hn1bVjF6nFlwhN1j6b2jjB6fN8kFcEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoa
	WlqYKynkJeam2iq5+AToumXmAJ2mpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gA
	DSSsY8zYv3QbS8EziYq592sbGB/wdTFyckgImEhsvNvMCGGLSVy4t56ti5GLQ0hgEaPEzM4/
	7BDOX0aJtVu/soFUsQloSayeexysQ0QgQWJe7wSwImaBj4wSTWf/QrV3M0osuL2FFaSKUyBY
	ovPyTxYQW1jAUWLpz4tgcRYBVYkrnQvBpvIKWEq86X4MZQtK/Jh8D6yeWUBdYtK8RcwQtrzE
	5jVvmSFuVZDYcfY1I0RcRGLfi3dANgfQRVYS+18lTGAUmoVk0iwkk2YhmTQLSfcCRpZVjKKp
	BckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFJ5JnUDsaVDRaHGAU4GJV4eBOv/g8UYk0sK67MPcQo
	wcGsJMKrspMhSIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgQkuryTe0NjEzMjSyMzCyMTc
	nDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYbbe/Sq2sZO4REe8/ExHfa/JshVX3huub
	wxPU130+epFJ1qi1+s3PRb53Xb8mz5jRVRQeq/eaxXGq7O83S/PtH8kvPBP3JHNGlfaZ9Nzu
	nZ27CwSrVz3nmjm35SJvUd2VdallvL7TlkWcNnO4kdBo5afNlTq1JLU59UdHc7X676jcpUan
	nogosRRnJBpqMRcVJwIAwnYabWYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: grundler@google.com [mailto:grundler@google.com] On Behalf Of Grant Grundler
> Sent: Tuesday, August 06, 2013 1:40 AM
> 
> Ping?
> 
> Adding linux-iommu ML.
> 
> thanks,
> grant
> 
> On Tue, Jul 2, 2013 at 9:08 AM, Grant Grundler <grundler@chromium.org> wrote:
> > exynos_sysmmu_set_prefbuf() is not called any where.
> >
> > Signed-off-by: Grant Grundler <grundler@chromium.org>

Reviewed-by: Cho KyongHo <pullip.cho@samsung.com>

Thank you.

KyongHo.
> > ---
> >  drivers/iommu/exynos-iommu.c | 44 --------------------------------------------
> >  1 file changed, 44 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 3f32d64..0740189 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -247,50 +247,6 @@ static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
> >         __raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
> >  }
> >
> > -void exynos_sysmmu_set_prefbuf(struct device *dev,
> > -                               unsigned long base0, unsigned long size0,
> > -                               unsigned long base1, unsigned long size1)
> > -{
> > -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > -       unsigned long flags;
> > -       int i;
> > -
> > -       BUG_ON((base0 + size0) <= base0);
> > -       BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
> > -
> > -       read_lock_irqsave(&data->lock, flags);
> > -       if (!is_sysmmu_active(data))
> > -               goto finish;
> > -
> > -       for (i = 0; i < data->nsfrs; i++) {
> > -               if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
> > -                       if (!sysmmu_block(data->sfrbases[i]))
> > -                               continue;
> > -
> > -                       if (size1 == 0) {
> > -                               if (size0 <= SZ_128K) {
> > -                                       base1 = base0;
> > -                                       size1 = size0;
> > -                               } else {
> > -                                       size1 = size0 -
> > -                                               ALIGN(size0 / 2, SZ_64K);
> > -                                       size0 = size0 - size1;
> > -                                       base1 = base0 + size0;
> > -                               }
> > -                       }
> > -
> > -                       __sysmmu_set_prefbuf(
> > -                                       data->sfrbases[i], base0, size0, 0);
> > -                       __sysmmu_set_prefbuf(
> > -                                       data->sfrbases[i], base1, size1, 1);
> > -
> > -                       sysmmu_unblock(data->sfrbases[i]);
> > -               }
> > -       }
> > -finish:
> > -       read_unlock_irqrestore(&data->lock, flags);
> > -}
> > -
> >  static void __set_fault_handler(struct sysmmu_drvdata *data,
> >                                         sysmmu_fault_handler_t handler)
> >  {
> > --
> > 1.8.3
> >

