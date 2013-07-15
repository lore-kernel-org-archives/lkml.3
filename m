Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698Ab3GOLWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 07:22:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65175 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab3GOLV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 07:21:58 -0400
X-AuditID: cbfee68f-b7f436d000000f81-6d-51e3db55e10d
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
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
        "'Grant Grundler'" <grundler@chromium.org>
References: <002b01ce797b$44d4ad10$ce7e0730$@samsung.com>
 <1933986.4vddYccClk@amdc1032>
In-reply-to: <1933986.4vddYccClk@amdc1032>
Subject: RE: [PATCH v7 3/9] iommu/exynos: fix page table maintenance
Date: Mon, 15 Jul 2013 20:21:56 +0900
Message-id: <009a01ce814d$840b48c0$8c21da40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQLNCGHc5Tw70Lg/Z1yb1OqFMpmE+gJtmRjql1UMXxA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+ZsW7o7ceBBivusVhsnLGe1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLPY9Pgaq8XlXXPYLGac38dkcWHFRnaLKYsOs1q0
	XO9lcuD1eHJwHpPH7IaLLB53ru1h89i8pN5j8o3ljB59W1YxenzeJBfAHsVlk5Kak1mWWqRv
	l8CVsfvedPaCC5oVJ3/4NDBOVuhi5OSQEDCR+PBjHiOELSZx4d56ti5GLg4hgWWMEo2tE9hg
	ijovbGKCSExnlFh2+h47hPOXUaL5WSM7SBWbgJbE6rnHwUaJCFhJPJ5xFqyIWWAzi0RX/xIW
	kISQQKTEt4cnmbsYOTg4gRru/uACCQsLuEicub6QGcRmEVCVuPPgFlg5r4ClxO3JbxkhbEGJ
	H5PvgcWZgVrX7zzOBGHLS2xe85YZ4lIFiR1nXzOCjAe54f3uPIgSEYl9L94xgpwjIbCQQ2LB
	k14WiF0CEt8mH2IBqZcQkJXYdABqjKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJ
	BcVJ6UXGesWJucWleel6yfm5mxghiaB/B+PdA9aHGJOB1k9klhJNzgcmkrySeENjMyMLUxNT
	YyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MMpO7JflUT90t+rwUUuR
	dwrckSqXH+95dIxfKILP9Cj3L+mpjH87dufJM6z+x/jKXWXzx+VZvNfmXPzLxDV5a6PeIbkN
	fVtP6u45z5LVx/rr23xVG74gg2imRz0fOM5GTtwmYr/liKsL2/RNe9JuNineCu28FxbCbBOg
	PFVG6G6Ut3zihMRWYSWW4oxEQy3mouJEAFm8p9EaAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jQd2Q248DDVZstbbYOGM9q8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGax6fE1VovLu+awWcw4v4/J4sKKjewWUxYdZrVo
	ud7L5MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT36tqxi9Pi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bue9PZCy5oVpz84dPAOFmhi5GTQ0LARKLzwiYm
	CFtM4sK99WxdjFwcQgLTGSWWnb7HDuH8ZZRoftbIDlLFJqAlsXrucUYQW0TASuLxjLNgRcwC
	m1kkuvqXsIAkhAQiJb49PMncxcjBwQnUcPcHF0hYWMBF4sz1hcwgNouAqsSdB7fAynkFLCVu
	T37LCGELSvyYfA8szgzUun7ncSYIW15i85q3zBCXKkjsOPuaEWQ8yA3vd+dBlIhI7HvxjnEC
	o9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITjPPpHYwrmyw
	OMQowMGoxMN7QONxoBBrYllxZe4hRgkOZiUR3qUXgUK8KYmVValF+fFFpTmpxYcYk4Eencgs
	JZqcD0yBeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKP+c
	t/90wfx5nLIWWY9manvLz6g+tkl51cM5GtsaH/53P3Jb5HOZX5jA6Z9P7iscT5wSUXWtxe2i
	z8tPv79VvXtRHW0etufp3PbeT3+leCXvHdW34vFumej3u3Fx2bYQh1Uvs39/VzbneCBZ0f+8
	OVHNIGl29tGntxpPCSzoW5a2uf9LUhG7khJLcUaioRZzUXEiAMtKKeV3AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bartlomiej Zolnierkiewicz [mailto:b.zolnierkie@samsung.com]
> Sent: Friday, July 12, 2013 2:38 AM
> 
> Hi,
> 
> Some minor nitpicks below.
> 
> On Friday, July 05, 2013 09:29:18 PM Cho KyongHo wrote:
> > This prevents allocating lv2 page table for the lv1 page table entry
> > that already has 1MB page mapping. In addition some BUG_ON() is
> > changed to WARN_ON().
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |   34 ++++++++++++++++++++++++++--------
> >  1 files changed, 26 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index e3be3e5..2bfe9fa 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -862,12 +862,14 @@ static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
> >  		pent = kzalloc(LV2TABLE_SIZE, GFP_ATOMIC);
> >  		BUG_ON((unsigned long)pent & (LV2TABLE_SIZE - 1));
> >  		if (!pent)
> > -			return NULL;
> > +			return ERR_PTR(-ENOMEM);
> >
> >  		*sent = mk_lv1ent_page(__pa(pent));
> >  		*pgcounter = NUM_LV2ENTRIES;
> >  		pgtable_flush(pent, pent + NUM_LV2ENTRIES);
> >  		pgtable_flush(sent, sent + 1);
> > +	} else if (lv1ent_section(sent)) {
> > +		return ERR_PTR(-EADDRINUSE);
> >  	}
> >
> >  	return page_entry(sent, iova);
> > @@ -944,16 +946,16 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
> >  		pent = alloc_lv2entry(entry, iova,
> >  					&priv->lv2entcnt[lv1ent_offset(iova)]);
> >
> > -		if (!pent)
> > -			ret = -ENOMEM;
> > +		if (IS_ERR(pent))
> > +			ret = PTR_ERR(pent);
> >  		else
> >  			ret = lv2set_page(pent, paddr, size,
> >  					&priv->lv2entcnt[lv1ent_offset(iova)]);
> >  	}
> >
> >  	if (ret) {
> > -		pr_debug("%s: Failed to map iova 0x%lx/0x%x bytes\n",
> > -							__func__, iova, size);
> > +		pr_err("%s: Failed(%d) to map iova 0x%#x bytes @ %#lx\n",
> > +						__func__, ret, size, iova);
> >  	}
> 
> Intendation is a bit weird, it should be more like:
> 
> 		pr_err("%s: Failed(%d) to map iova 0x%#x bytes @ %#lx\n",
> 			__func__, ret, size, iova);
> 
> to be consistent with the rest of the driver.
> 
> You could have also removed superfluous braces while at it.
> 

Do you think it is better to read the code?
Hmm, I think it is better too.
Thanks.

> >  	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> > @@ -968,6 +970,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >  	struct sysmmu_drvdata *data;
> >  	unsigned long flags;
> >  	unsigned long *ent;
> > +	size_t err_page;
> >
> >  	BUG_ON(priv->pgtable == NULL);
> >
> > @@ -976,7 +979,8 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >  	ent = section_entry(priv->pgtable, iova);
> >
> >  	if (lv1ent_section(ent)) {
> > -		BUG_ON(size < SECT_SIZE);
> > +		if (WARN_ON(size < SECT_SIZE))
> > +			goto err;
> >
> >  		*ent = 0;
> >  		pgtable_flush(ent, ent + 1);
> > @@ -1008,7 +1012,8 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >  	}
> >
> >  	/* lv1ent_large(ent) == true here */
> > -	BUG_ON(size < LPAGE_SIZE);
> > +	if (WARN_ON(size < LPAGE_SIZE))
> > +		goto err;
> >
> >  	memset(ent, 0, sizeof(*ent) * SPAGES_PER_LPAGE);
> >  	pgtable_flush(ent, ent + SPAGES_PER_LPAGE);
> > @@ -1023,8 +1028,21 @@ done:
> >  		sysmmu_tlb_invalidate_entry(data->dev, iova);
> >  	spin_unlock_irqrestore(&priv->lock, flags);
> >
> > -
> >  	return size;
> > +err:
> > +	spin_unlock_irqrestore(&priv->pgtablelock, flags);
> > +
> > +	err_page = (
> > +		((unsigned long)ent - (unsigned long)priv->pgtable)
> > +			< (NUM_LV1ENTRIES * sizeof(long))
> 
> Maybe you could add LV1TABLE_SIZE define and use it here (there is
> already a LV2TABLE_SIZE define)?

Yes. But, LV2TABLE_SIZE is used in more places than one.
I do not feel that it is needed to define LV1TABLE_SIZE for the single line.

> 
> > +			   ) ?  SECT_SIZE : LPAGE_SIZE;
> 
> It also seems that err_page should be of unsigned long type, no need
> to make it size_t one.
> 

err_page is the page size.
I agree that the name of the variable is not proper to indicate size.

> The above code is quite ugly currently, it could be rewritten into
> something prettier, i.e.:
> 
> 	err_page = (unsigned long)ent - (unsigned long)priv->pgtable;
> 	err_page = (err_page < LV1TABLE_SIZE) ? SECT_SIZE : LPAGE_SIZE;
> 
Ah, this is the reason that you addresses err_page could be unsigned long.
I agree that it is prettier.

> > +	pr_err("%s: Failed due to size(%#lx) @ %#x is"\
> > +		" smaller than page size %#x\n",
> > +		__func__, iova, size, err_page);
> 
> Aren't iova and size arguments interchanged here?
Oh, it is my mistake.

It will should be fixed in the next patchset with the change in
calculation of err_page.
> 
> > +
> > +	       return 0;
> 
> There is an intendation issue here (extra whitespaces).

Yes. Thanks.

> 
> > +
> >  }
> >
> >  static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics

Thank you.

Cho KyongHo.

