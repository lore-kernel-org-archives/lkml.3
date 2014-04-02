Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaDBEgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 00:36:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32275 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaDBEgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 00:36:31 -0400
X-AuditID: cbfee68e-b7f566d000002344-fe-533b93cdc5e9
From: Jungseok Lee <jays.lee@samsung.com>
To: "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, sungjinn.chung@samsung.com,
        "'linux-samsung-soc'" <linux-samsung-soc@vger.kernel.org>
References: <011801cf4d4c$f7ba51f0$e72ef5d0$@samsung.com>
 <20140401124606.GA7135@phenom.dumpdata.com>
In-reply-to: <20140401124606.GA7135@phenom.dumpdata.com>
Subject: Re: [PATCH] swiotlb: Correct kernel command line handler
Date: Wed, 02 Apr 2014 13:36:29 +0900
Message-id: <004c01cf4e2d$1d84a1c0$588de540$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQH/eYOrp7F4fAtMYt33A7B+7Ps6dgHNl7kWmo7wVoA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI92zk62DDba1ilssW/yU0eLyrjls
	FjPO72Oy+DBjJaMDi8fHp7dYPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj9fY3LAUfRSte
	zj/F0sA4SbCLkZNDQsBE4syZtSwQtpjEhXvr2UBsIYFljBILTjDC1HT+/wZkcwHFFzFKdL5f
	xwzh/GGUaN/4gxmkik1AU+LR3R52EFsEqONI1y+wqcwC5RKz/l5kh5iaLjFzXgdYnFPAQuLa
	/kNMILawgKPEzhsdYJtZBFQllnX/ZQWxeQUsJU7O7GeEsAUlfky+BzVTS2L9zuNMELa8xOY1
	b5khLlWQ2HH2NSNEXERi34t3jBD3WEmsP/aVHeRoCYFD7BKfrv1nglgmIPFt8iGgoRxACVmJ
	TQeg5khKHFxxg2UCo8QsJKtnIVk9C8nqWUjWLWBkWcUomlqQXFCclF5kpFecmFtcmpeul5yf
	u4kREo19OxhvHrA+xJgMtH4is5Rocj4wmvNK4g2NzYwsTE1MjY3MLc1IE1YS5130MCkIGL6J
	JanZqakFqUXxRaU5qcWHGJk4OKUaGP0Eth2I9drk83jJWu8sM2+N8gKjuBnJCZcTlLY/bJgz
	5fL2YI7HYp0vEl5dlcv93fv9XQPDuRMF9d7pb2YW3Lv2aNEvhU3qDh8XX3G48vGUx83Hba2M
	su31l108Ki5nle8s2CO4Un76c//4B9cjVjJu0vKb5BDxVzrzxp8dj/SNLr7uig9pMVViKc5I
	NNRiLipOBAAVFL1F3AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jAd2zk62DDe7dELJYtvgpo8XlXXPY
	LGac38dk8WHGSkYHFo+PT2+xePRtWcXo8XmTXABzVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
	c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QOiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6
	viFBcD1GBmggYR1jxuvtb1gKPopWvJx/iqWBcZJgFyMnh4SAiUTn/2+MELaYxIV769m6GLk4
	hAQWMUp0vl/HDOH8YZRo3/iDGaSKTUBT4tHdHnYQWwSo+0jXLxYQm1mgXGLW34tgcSGBdImZ
	8zrA4pwCFhLX9h9iArGFBRwldt7oYAOxWQRUJZZ1/2UFsXkFLCVOzuxnhLAFJX5Mvgc1U0ti
	/c7jTBC2vMTmNW+ZIS5VkNhx9jUjRFxEYt+Ld4wQ91hJrD/2lX0Co9AsJKNmIRk1C8moWUja
	FzCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvZn0jsYVzVYHGIU4GBU4uE9cN4qWIg1
	say4MvcQowQHs5IIL+ck62Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcmorySeENjEzMj
	SyMzCyMTc3PShJXEeQ+2WgcCQzexJDU7NbUgtQhmCxMHp1QD4+LdalXr70Vt3FG4XVXlm81x
	9yWLinheplw/alLKMf197JoUE277JQbxT5oyJ+g4PfvxnFdFRLpF8qdFm3LyugmTfTIev9FV
	UZ2W+3dv9OG9n3amBpyvnfntoI9yRfkEqU5X0+xe/lkfWVbX10kq7N60erbDjUcP3kizdU/Z
	GemlvIJldt6REiWW4oxEQy3mouJEADBslp86AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 01, 2014 9:46 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Apr 01, 2014 at 10:51:58AM +0900, Jungseok Lee wrote:
> > This patch corrects kernel command line handler when io_tlb_nslabs is
> > set to 0.
> >
> > A current implementation allocates default size memory (64MB) when
> > 0 is given to io_tlb_nslabs ("swiotlb=0") by kernel command line.
> > In other words, memory is allocated unintentionally.
> 
> What are the other IOMMUs that end up taking over the DMA ops?

I think that no other IOMMUs take over it on ARM64 system, except Xen.

> Or do you end up with no DMA ops?

I focus on ARM64 system which uses swiotlb as default DMA ops.

If some ARM64 platforms would like to use memory only from
__get_free_pages in swiotlb_alloc_coherent function, an
interface would be needed to configure reserved memory size.

Thus, I add it to kernel command line handler.

Best Regards
Jungseok Lee

> >
> > Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
> > Signed-off-by: Sungjinn Chung <sungjinn.chung@samsung.com>
> > ---
> >  lib/swiotlb.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c index b604b83..9fe9f71
> > 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -55,6 +55,8 @@
> >
> >  int swiotlb_force;
> >
> > +static int swiotlb_no_use;
> > +
> >  /*
> >   * Used to do a quick range check in swiotlb_tbl_unmap_single and
> >   * swiotlb_tbl_sync_single_*, to see if the memory was in fact
> > allocated by this @@ -102,6 +104,8 @@ setup_io_tlb_npages(char *str)
> >  		io_tlb_nslabs = simple_strtoul(str, &str, 0);
> >  		/* avoid tail segment of size < IO_TLB_SEGSIZE */
> >  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> > +		if (!io_tlb_nslabs)
> > +			swiotlb_no_use = 1;
> >  	}
> >  	if (*str == ',')
> >  		++str;
> > @@ -212,7 +216,7 @@ swiotlb_init(int verbose)
> >  	unsigned char *vstart;
> >  	unsigned long bytes;
> >
> > -	if (!io_tlb_nslabs) {
> > +	if (!swiotlb_no_use && !io_tlb_nslabs) {
> >  		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
> >  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> >  	}
> > @@ -244,7 +248,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
> >  	unsigned int order;
> >  	int rc = 0;
> >
> > -	if (!io_tlb_nslabs) {
> > +	if (!swiotlb_no_use && !io_tlb_nslabs) {
> >  		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
> >  		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
> >  	}
> > --
> > 1.7.10.4
> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in the body of a message
> to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

