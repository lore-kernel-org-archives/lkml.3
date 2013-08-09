Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab3HIEBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:01:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30772 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3HIEBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:01:38 -0400
X-AuditID: cbfee68f-b7f436d000000f81-1f-5204699eb27a
Date: Fri, 09 Aug 2013 13:01:33 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
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
Subject: Re: [PATCH v9 01/16] iommu/exynos: do not include removed header
Message-id: <20130809130133.fea18aa350c831ece07188e3@samsung.com>
In-reply-to: <21505674.fdNgPGp76O@amdc1227>
References: <002501ce941a$e3d87f40$ab897dc0$@samsung.com>
 <21505674.fdNgPGp76O@amdc1227>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zY915mSxBBremK1jcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxYHf48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZxWWTkpqTWZZapG+XwJXxY+JpxoJHfBXPH/1ia2C8yN3FyMkhIWAi8XrxbWYI
	W0ziwr31bF2MXBxCAssYJf5u+c8IU3Tn4X92EFtIYDqjROtfKYiiSUwS91u/soIkWARUJZ7v
	ugdmswloSayeexysWURAReLyqelgNrPADxaJT9v4QGxhAU+Jh5MbWUBsXgFHiYPTDoBdwSmg
	LXHr/iOoZVESHy8/YIU4wkLiQlMHO0S9oMSPyfdYIGZqSWze1sQKYctLbF7zlhnkOAmBhRwS
	X6/dY4Y4TkDi2+RDQA0cQAlZiU0HoD6WlDi44gbLBEaxWUjGzkIydhaSsQsYmVcxiqYWJBcU
	J6UXGesVJ+YWl+al6yXn525ihMR6/w7GuwesDzEmA62cyCwlmpwPTBV5JfGGxmZGFqYmpsZG
	5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamCcMNG/WXvtld8FvbxRX3Y8
	iWNX9i0OPL7o8PGvhz8rcNTIlq4PvTBDskRgt/l9low5TLfyDVTesOs+6TOaP/1et6L5ttha
	mUnTLgp1xO4K3epivKOvp+Pauu+PXi9t5Pj19UrJ061Bm86JRDhI972IrPrfLWQ6nfXb4rOT
	ZD89OHDR6PShJfWTlViKMxINtZiLihMB+bo+ZwsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKKsWRmVeSWpSXmKPExsVy+t9jQd15mSxBBovmSVncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzeLjqePsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi5N/
	ehktWq73Mlmsn/GaxYHf48nBeUwesxsusnjcubaHzeP8pjXMHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48fE04wFj/gq
	nj/6xdbAeJG7i5GTQ0LAROLOw//sELaYxIV769lAbCGB6YwSrX+luhi5gOxJTBL3W7+ygiRY
	BFQlnu+6B2azCWhJrJ57nBHEFhFQkbh8ajqYzSzwg0Xi0zY+EFtYwFPi4eRGFhCbV8BR4uC0
	A8wgNqeAtsSt+4/YIZZFSXy8/IAV4ggLiQtNHewQ9YISPybfY4GYqSWxeVsTK4QtL7F5zVvm
	CYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYnkmfQOxlUNFocY
	BTgYlXh4FbczBwmxJpYVV+YeYpTgYFYS4X2RBRTiTUmsrEotyo8vKs1JLT7EmAwMjYnMUqLJ
	+cAkl1cSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjNYLzZh6
	SkLPf3LKWMYwZ92/afcWZm9L4nz4X24dj5TndFv3+aeVtY9cuxYj9yfk75bJT2dxf3l/SY25
	7sqS3KbqD1/530a4v9t5uzlT4TNHwo99ZekrOqPSLrsVHXyxmjlmhzzX4tOGWxryPFP8Plc6
	xb57+v9R4YJzrn94ZJYv2fhu/dmPiU+UWIozEg21mIuKEwF86KZlaAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Aug 2013 15:42:24 +0200, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On Thursday 08 of August 2013 18:37:25 Cho KyongHo wrote:
> > This commit remove <mach/sysmmu.h> which is removed.
> 
> I would prefer a more meaningful commit message, something among following 
> lines:
> 
> 8<---
> Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from 
> exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without 
> removing remaining use of it from exynos-iommu driver, thus causing a 
> compilation error.
> 
> This patch fixes the error by removing respective include line from exynos-
> iommu.c.
> --->8
> 

Ok.

> Also a sentence explaining why linux/kernel.h header must be included would 
> be nice.
> 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> 
> Please note that as far as I'm aware of, tags should be made using western 
> name writing convention, i.e. starting with first name.
> 

Oh, I didn't think that the order of family/given names are the matter.
I don't care about changing the order.

Thanks.

KyongHo.

> Best regards,
> Tomasz
> 
> > ---
> >  drivers/iommu/exynos-iommu.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 3f32d64..233f382 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -12,6 +12,7 @@
> >  #define DEBUG
> >  #endif
> > 
> > +#include <linux/kernel.h>
> >  #include <linux/io.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/platform_device.h>
> > @@ -29,8 +30,6 @@
> >  #include <asm/cacheflush.h>
> >  #include <asm/pgtable.h>
> > 
> > -#include <mach/sysmmu.h>
> > -
> >  /* We does not consider super section mapping (16MB) */
> >  #define SECT_ORDER 20
> >  #define LPAGE_ORDER 16
