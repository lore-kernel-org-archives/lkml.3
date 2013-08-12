Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3HLCAD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:00:03 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16445 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3HLB77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 21:59:59 -0400
X-AuditID: cbfee691-b7fef6d000002d62-c9-5208419d0a46
Date: Mon, 12 Aug 2013 10:59:57 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        devicetree@vger.kernel.org, "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v9 04/16] iommu/exynos: allocate lv2 page table from own
 slab
Message-id: <20130812105957.918cc24dc835034365525cbc@samsung.com>
In-reply-to: <12183506.4f14O99EfL@amdc1227>
References: <002801ce941a$fb6369e0$f22a3da0$@samsung.com>
 <2101296.S6JDU5igl3@flatron>
 <20130809175156.c7ffc68b865e4bca48ef47dd@samsung.com>
 <12183506.4f14O99EfL@amdc1227>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplleLIzCtJLcpLzFFi42I5/e+Zse5cR44gg0XbtCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZvHx1HF2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxck/
	vYwWLdd7mSzWz3jNYrFq1x9GBwGPJwfnMXnMbrjI4rFz1l12jzvX9rB5nN+0htlj85J6j8k3
	ljN69G1ZxejxeZOcx5WjZ5gCuKK4bFJSczLLUov07RK4MiY0HWApuGdc8fbFVvYGxrcqXYyc
	HBICJhJr/35mhLDFJC7cW8/WxcjFISSwjFFiwuqPbDBFc7/8ZYdILGKUWN+/igXCmcQkcXXl
	UVaQKhYBVYlle7ewgNhsAloSq+ceBxsrIqAicfnUdEaQBmaB+awSv6c3gDUICwRLbHr2E6yI
	V8BRYuGPPrA4p4C2RMfTY1B3bGSUeNnXyApxh4XEhaYOdogGQYkfk++BbWMG2rZ5WxMrhC0v
	sXnNW2aQZgmBLRwSvzdcYoY4T0Di2+RDQA0cQAlZiU0HmCFmSkocXHGDZQKj2CwkY2chGTsL
	ydgFjMyrGEVTC5ILipPSi0z1ihNzi0vz0vWS83M3MUKSwMQdjPcPWB9iTAZaOZFZSjQ5H5hE
	8kriDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuHfD
	uv6K2fl3bX9d95yinV2uOlO85EPQink5shXfFuu+NziW6Z55OSrh9Z5Xcj5KRx4FR+npvft3
	RVlzGcPjMy8etQbuYq/8pDHrwteuj7EcPXVbv37g77OpDNB/emn933LJB892z1aSN/Yqttz9
	/kD+FbVO/+XNy5Q9V1eb78jIWvM6sYvPWYmlOCPRUIu5qDgRALT+iosYAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jAd25jhxBBiumq1jcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxWLVrj+MDgIeTw7OY/KY3XCRxWPnrLvsHneu7WHzOL9pDbPH5iX1HpNv
	LGf06NuyitHj8yY5jytHzzAFcEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqY
	KynkJeam2iq5+AToumXmAP2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSs
	Y8yY0HSApeCeccXbF1vZGxjfqnQxcnJICJhIzP3ylx3CFpO4cG89WxcjF4eQwCJGifX9q1gg
	nElMEldXHmUFqWIRUJVYtncLC4jNJqAlsXrucUYQW0RAReLyqemMIA3MAvNZJX5PbwBrEBYI
	ltj07CdYEa+Ao8TCH31gcU4BbYmOp8eg1m1klHjZ18gKcYeFxIWmDnaIBkGJH5PvgW1jBtq2
	eVsTK4QtL7F5zVvmCYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsY
	wSnmmfQOxlUNFocYBTgYlXh4Pb6wBwmxJpYVV+YeYpTgYFYS4a035ggS4k1JrKxKLcqPLyrN
	SS0+xJgMDI+JzFKiyfnA9JdXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQi
	mC1MHJxSDYz1yybMZdoV0iF1//OVhy/Yyq/Oj05aU/uKrf0A/40zR261OPy3+3q9drNU3fXN
	5zNWuTy7vfxQXZpxl7nrVs6j98/xLdzVxjQ9+MC1aZPDp8y6uH7bJa3bz0uK+H38Op5ZTJoq
	3f/eL9mdo+L/jn26Gb+fJdu3BAWy3Op5dX7RopapOqVuRqIxSizFGYmGWsxFxYkACk66t3UD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Aug 2013 11:35:20 +0200, Tomasz Figa wrote:
> On Friday 09 of August 2013 17:51:56 Cho KyongHo wrote:
> > On Fri, 09 Aug 2013 09:55:30 +0200, Tomasz Figa wrote:
> > > Hi KyongHo,
> > > 
> > > On Friday 09 of August 2013 14:58:49 Cho KyongHo wrote:
> > > > On Thu, 08 Aug 2013 16:00:18 +0200, Tomasz Figa wrote:
> > > > > On Thursday 08 of August 2013 18:38:04 Cho KyongHo wrote:
> > > > > > Since kmalloc() does not guarantee that the allignment of 1KiB
> > > > > > when
> > > > > > it
> > > > > > allocates 1KiB, it is required to allocate lv2 page table from
> > > > > > own
> > > > > > slab that guarantees alignment of 1KiB
> > > > > > 
> > > > > > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > > > > > ---
> > > > > > 
> > > > > >  drivers/iommu/exynos-iommu.c |   24 ++++++++++++++++++++----
> > > > > >  1 files changed, 20 insertions(+), 4 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/iommu/exynos-iommu.c
> > > > > > b/drivers/iommu/exynos-iommu.c index d90e6fa..a318049 100644
> > > > > > --- a/drivers/iommu/exynos-iommu.c
> > > > > > +++ b/drivers/iommu/exynos-iommu.c
> > > > > > @@ -100,6 +100,8 @@
> > > > > > 
> > > > > >  #define REG_PB1_SADDR		0x054
> > > > > >  #define REG_PB1_EADDR		0x058
> > > > > > 
> > > > > > +static struct kmem_cache *lv2table_kmem_cache;
> > > > > > +
> > > > > > 
> > > > > >  static unsigned long *section_entry(unsigned long *pgtable,
> > > > > >  unsigned
> > > > > > 
> > > > > > long iova) {
> > > > > > 
> > > > > >  	return pgtable + lv1ent_offset(iova);
> > > > > > 
> > > > > > @@ -765,7 +767,8 @@ static void
> > > > > > exynos_iommu_domain_destroy(struct
> > > > > > iommu_domain *domain)
> > > > > > 
> > > > > >  	for (i = 0; i < NUM_LV1ENTRIES; i++)
> > > > > >  	
> > > > > >  		if (lv1ent_page(priv->pgtable + i))
> > > > > > 
> > > > > > -			kfree(__va(lv2table_base(priv->pgtable + i)));
> > > > > > +			kmem_cache_free(lv2table_kmem_cache,
> > > > > > +					__va(lv2table_base(priv->pgtable +
> > > 
> > > i)));
> > > 
> > > > > >  	free_pages((unsigned long)priv->pgtable, 2);
> > > > > >  	free_pages((unsigned long)priv->lv2entcnt, 1);
> > > > > > 
> > > > > > @@ -861,7 +864,7 @@ static unsigned long *alloc_lv2entry(unsigned
> > > > > > long
> > > > > > *sent, unsigned long iova, if (lv1ent_fault(sent)) {
> > > > > > 
> > > > > >  		unsigned long *pent;
> > > > > > 
> > > > > > -		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> > > > > > +		pent = kmem_cache_zalloc(lv2table_kmem_cache, GFP_ATOMIC);
> > > > > > 
> > > > > >  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> > > > > >  		if (!pent)
> > > > > >  		
> > > > > >  			return ERR_PTR(-ENOMEM);
> > > > > > 
> > > > > > @@ -881,7 +884,7 @@ static int lv1set_section(unsigned long
> > > > > > *sent,
> > > > > > phys_addr_t paddr, short *pgcnt)
> > > > > > 
> > > > > >  	if (lv1ent_page(sent)) {
> > > > > >  	
> > > > > >  		BUG_ON(*pgcnt != NUM_LV2ENTRIES);
> > > > > > 
> > > > > > -		kfree(page_entry(sent, 0));
> > > > > > +		kmem_cache_free(lv2table_kmem_cache, page_entry(sent, 0));
> > > > > > 
> > > > > >  		*pgcnt = 0;
> > > > > >  	
> > > > > >  	}
> > > > > > 
> > > > > > @@ -1082,10 +1085,23 @@ static int __init exynos_iommu_init(void)
> > > > > > 
> > > > > >  {
> > > > > >  
> > > > > >  	int ret;
> > > > > > 
> > > > > > +	lv2table_kmem_cache =
> > > > > > kmem_cache_create("exynos-iommu-lv2table",
> > > > > > +				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> > > > > > +	if (!lv2table_kmem_cache) {
> > > > > > +		pr_err("%s: Failed to create kmem cache\n", __func__);
> > > > > > +		return -ENOMEM;
> > > > > > +	}
> > > > > > +
> > > > > > 
> > > > > >  	ret = platform_driver_register(&exynos_sysmmu_driver);
> > > > > >  	
> > > > > >  	if (ret == 0)
> > > > > > 
> > > > > > -		bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > > > > > +		ret = bus_set_iommu(&platform_bus_type,
> > > 
> > > &exynos_iommu_ops);
> > > 
> > > > > > +
> > > > > > +	if (ret) {
> > > > > > +		pr_err("%s: Failed to register exynos-iommu driver.\n",
> > > > > > +								__func__);
> > > > > > +		kmem_cache_destroy(lv2table_kmem_cache);
> > > > > > +	}
> > > > > 
> > > > > What about making the return value handling here cleaner? For 
> example:
> > > > > 	lv2table_kmem_cache = kmem_cache_create("exynos-iommu-lv2table",
> > > > > 	
> > > > > 				LV2TABLE_SIZE, LV2TABLE_SIZE, 0, NULL);
> > > > > 	
> > > > > 	if (!lv2table_kmem_cache) {
> > > > > 	
> > > > > 		...
> > > > > 		return -ENOMEM;
> > > > > 	
> > > > > 	}
> > > > > 	
> > > > > 	ret = platform_driver_register(&exynos_sysmmu_driver);
> > > > > 	if (ret) {
> > > > > 	
> > > > > 		...
> > > > > 		goto err_destroy_kmem_cache;
> > > > > 	
> > > > > 	}
> > > > > 	
> > > > > 	ret = bus_set_iommu(&platform_bus_type, &exynos_iommu_ops);
> > > > > 	if (ret) {
> > > > > 	
> > > > > 		...
> > > > > 		goto err_platform_unregister;
> > > > > 	
> > > > > 	}
> > > > > 	
> > > > > 	return 0;
> > > > > 
> > > > > err_platform_unregister:
> > > > > 	...
> > > > > 
> > > > > err_destroy_kmem_cache:
> > > > > 	...
> > > > > 	return ret;
> > > > > 
> > > > > }
> > > > 
> > > > Thank you for suggestion.
> > > > I think you are worrying about missing the information who makes
> > > > 'ret'
> > > > non-zero.
> > > 
> > > Oh, this is a valid point, but it was more a nitpick about the coding
> > > style. Single path error handling (with goto) is widely used in the
> > > kernel in cases when more than one thing has to be undone and so I
> > > suggested this method of error handling here as well.
> > > 
> > > > Ok. I will process it separately.
> > > 
> > > Since this patch adds most of the error handling to this function, I
> > > think it should be fine to do it as a part of this patch.
> > 
> > I meant 'separately' that checking all return values each.
> > I think it can be simpler without goto.
> >
> > There are just 2 cases to rollback previous changes in that function.
> 
> It might end up with less lines, but having roll back in single place is 
> more readable. That's why it's the preferred error handling way in Linux 
> kernel, if you have more than one action to undo on your error path.
> 

I fully understand what you are concerning about and I also agree.
Actually it is simple choice without any side effect.
It is just a preference.
I will change it into 'goto'.
Then we can determine what looks better :) 

Thank you.

KyongHo.

> Best regards,
> Tomasz
> 
