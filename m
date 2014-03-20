Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbaCTJz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:55:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19881 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaCTJzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:55:24 -0400
X-AuditID: cbfee690-b7f266d00000287c-02-532abb0879a9
Date: Thu, 20 Mar 2014 18:55:19 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Grant Grundler <grundler@chromium.org>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 24/27] iommu/exynos: use exynos-iommu specific typedef
Message-id: <20140320185519.0035bf69004da6c570133414@samsung.com>
In-reply-to: <CANEJEGu=yDfYi-gH7W7h7up2gd7MxBOg9bz4konLoe-UGf4RYA@mail.gmail.com>
References: <20140314141302.393cfdf96dd7b82eee3f700e@samsung.com>
 <CANEJEGu=yDfYi-gH7W7h7up2gd7MxBOg9bz4konLoe-UGf4RYA@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zA12O3VrBBrs6BCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4MqYvmoRU8FkvoqOJr0Gxs3cXYycHBICJhLnnz9ig7DF
	JC7cWw9kc3EICSxjlPj98CkzTNGV9xdZIRLTGSW6rjYxQTiTmSSa1v4Hcjg4WARUJR511YE0
	sAloSayee5wRxBYBsmfsPwfWzCzwk0WiZVITC0hCWMBPYt6zZiYQm1fAUaKrZSvYGZwCwRKP
	Go6wgthCAh2MEr92q0NcYSFxoamDHaJeUOLH5Htgc5iBFmze1sQKYctLbF7zlhlkmYTAUg6J
	HRNOgBWxCAhIfJt8iAXkUAkBWYlNB6A+k5Q4uOIGywRGsVlIxs5CMnYWkrELGJlXMYqmFiQX
	FCelF5noFSfmFpfmpesl5+duYoTE+oQdjPcOWB9iTAZaOZFZSjQ5H5gq8kriDY3NjCxMTUyN
	jcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBkfnG19sTrnv2rp7XsmO9
	nz2D0Z/e83Ixb5XdM3VY8o/mcTDxGmp+nH2iuYP9yqErsk3a5f08ptONVv6NNb0t8s7LkEsk
	L15CWj1rMvfXwin9Z1/kHe3YeJujZdfk6hPf+tiZuNoUW7ozuPfvm3hwp0YaT1W2iI/SDPc1
	9/wV8/XOqF27mTRJiaU4I9FQi7moOBEA0EHfHwsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jQV2O3VrBBstncFncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY/qqRUwFk/kq
	Opr0Ghg3c3cxcnJICJhIXHl/kRXCFpO4cG89WxcjF4eQwHRGia6rTUwQzmQmiaa1/4EcDg4W
	AVWJR111IA1sAloSq+ceZwSxRYDsGfvPsYLUMwv8ZJFomdTEApIQFvCTmPesmQnE5hVwlOhq
	2coGYnMKBEs8ajgCtllIoINR4tdudYgrLCQuNHWwQ9QLSvyYfA9sDjPQgs3bmlghbHmJzWve
	Mk9gFJiFpGwWkrJZSMoWMDKvYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAhOJM+kdjCubLA4
	xCjAwajEw7tij2awEGtiWXFl7iFGCQ5mJRFea3etYCHelMTKqtSi/Pii0pzU4kOMycDQmMgs
	JZqcD0xyeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAeNDL
	Ze5Jh6tTOpnbfJ3fXb/H+PtihqPTce1p8xT+/gu04lrLH94Vku1waLmIQrb+3q839l/bbFN0
	cfYZz5pHoZkK3xRWmgoGRnxomhP1dKo6k+bpeTsvfXc9LtBd9THnohWXcEVEWnWI3qn/idu9
	b0249OSX4c1Xc8Ptvx2++W/y4lOycxYFMSqxFGckGmoxFxUnAgDWH0SsaAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 18:33:20 -0700, Grant Grundler wrote:
> On Thu, Mar 13, 2014 at 10:13 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > This commit introduces sysmmu_pte_t for page table entries and
> > sysmmu_iova_t vor I/O virtual address that is manipulated by
> > exynos-iommu driver. The purpose of the typedef is to remove
> > dependencies to the driver code from the change of CPU architecture
> > from 32 bit to 64 bit.
> 
> hi Cho,
> I noticed this before but understood this code was only compiled for
> ILP-32 programming model. I'm assuming that is going to change in the
> not-to-distant future. Good. :)
> 

Thanks.

> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |  103 ++++++++++++++++++++++--------------------
> >  1 file changed, 54 insertions(+), 49 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index e375501..6e716cc 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -56,19 +56,19 @@
> >  #define lv2ent_large(pent) ((*(pent) & 3) == 1)
> >
> >  #define section_phys(sent) (*(sent) & SECT_MASK)
> > -#define section_offs(iova) ((iova) & 0xFFFFF)
> > +#define section_offs(iova) ((sysmmu_iova_t)(iova) & 0xFFFFF)
> 
> The cast will mask abuses of iova. Define section_offs as a static
> function and GCC can type check iova parameter to make sure it's a
> sysmmu_iova_t.
> Thoughts?
> 
> I was thinking "((iova) & (sysmmu_iova_t) 0XFFFFF)" might do what you
> want but it doesn't warn on abuse that I tried. I believe GCC knows
> the upper bits are being ignored.

Thank you for advice.

I agree that type checking by compiler will be more helpful
as you mentioned.

Regards,

KyongHo
